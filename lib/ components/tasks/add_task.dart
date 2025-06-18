import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> showAddTaskDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  DateTime? selectedDate;
  String priority = 'low';

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Create Task'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) => value!.isEmpty ? 'Enter title' : null,
                ),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter description' : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(labelText: 'Priority'),
                  items: ['low', 'medium', 'high']
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (val) => priority = val!,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      selectedDate = date;
                    }
                  },
                  child: Text('Select Due Date'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && selectedDate != null) {
                await FirebaseFirestore.instance.collection('tasks').add({
                  'title': titleController.text,
                  'description': descController.text,
                  'priority': priority,
                  'dueDate': Timestamp.fromDate(selectedDate!),
                  'isCompleted': false,
                  'createdAt': Timestamp.now(),
                });
                Navigator.pop(context);
              }
            },
            child: Text('Create'),
          )
        ],
      );
    },
  );
}

Future<void> showEditTaskDialog(
    BuildContext context, String taskId, Map<String, dynamic> taskData) async {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController(text: taskData['title']);
  final descController = TextEditingController(text: taskData['description']);
  DateTime selectedDate = (taskData['dueDate'] as Timestamp).toDate();
  String priority = taskData['priority'];

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Task'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) => value!.isEmpty ? 'Enter title' : null,
                ),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter description' : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(labelText: 'Priority'),
                  items: ['low', 'medium', 'high']
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (val) => priority = val!,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      selectedDate = date;
                    }
                  },
                  child: Text('Update Due Date'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(taskId)
                    .update({
                  'title': titleController.text,
                  'description': descController.text,
                  'priority': priority,
                  'dueDate': Timestamp.fromDate(selectedDate),
                });
                Navigator.pop(context);
              }
            },
            child: Text('Update'),
          )
        ],
      );
    },
  );
}
