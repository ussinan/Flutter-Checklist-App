import '../entities/task.dart';

/// Repository interface for task data operations.
abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Stream<List<Task>> watchAllTasks();
  Future<void> upsertTask(Task task);
  Future<void> deleteTask(String id);
  Future<Task?> getTaskById(String id);
}


