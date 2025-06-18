import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class TaskService {
  final taskRef = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    await taskRef.add(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await taskRef.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await taskRef.doc(id).delete();
  }

  Stream<List<Task>> getTasks() {
    return taskRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}
