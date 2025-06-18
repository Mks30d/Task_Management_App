import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import 'add_task.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  bool sortByPriority = false;

  int _priorityValue(String priority) {
    switch (priority) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskRef = FirebaseFirestore.instance.collection('tasks');

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: 'Sort by Priority',
            onPressed: () {
              setState(() {
                sortByPriority = !sortByPriority;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: taskRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(child: Text('Error loading tasks'));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          List<QueryDocumentSnapshot> tasks = snapshot.data!.docs;

// Separate completed and incomplete tasks
          List<QueryDocumentSnapshot> incompleteTasks = [];
          List<QueryDocumentSnapshot> completedTasks = [];

          for (var task in tasks) {
            if ((task['isCompleted'] ?? false) == true) {
              completedTasks.add(task);
            } else {
              incompleteTasks.add(task);
            }
          }

// Sort incomplete tasks if sorting is enabled
          if (sortByPriority) {
            incompleteTasks.sort((a, b) {
              final aPriority = _priorityValue(a['priority']);
              final bPriority = _priorityValue(b['priority']);
              return bPriority.compareTo(aPriority); // high to low
            });
          }

// Merge lists: incomplete first, completed last
          tasks = [...incompleteTasks, ...completedTasks];

          if (sortByPriority) {
            tasks.sort((a, b) {
              final aPriority = _priorityValue(a['priority']);
              final bPriority = _priorityValue(b['priority']);
              return bPriority.compareTo(aPriority); // high to low
            });
          }

          if (tasks.isEmpty) return const Center(child: Text('No tasks found'));

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final id = task.id;
              final title = task['title'];
              final description = task['description'];
              final priority = task['priority'];
              final dueDate = (task['dueDate'] as Timestamp).toDate();
              final isCompleted = task['isCompleted'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: Checkbox(
                    value: isCompleted,
                    onChanged: (val) {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(id)
                          .update({
                        'isCompleted': val,
                      });
                    },
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: TextStyle(
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        "Due: ${DateFormat('yyyy-MM-dd').format(dueDate)}",
                        style: TextStyle(
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        "Priority: ${priority.toUpperCase()}",
                        style: TextStyle(
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          showEditTaskDialog(
                              context, id, task.data() as Map<String, dynamic>);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                  'Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(id)
                                        .delete();
                                    Navigator.pop(ctx);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
