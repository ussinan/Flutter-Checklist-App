import 'dart:async';
import 'dart:convert';

import '../../core/network/api_client.dart';
import '../../domain/entities/task.dart';

/// Interface for remote task data operations.
abstract class TaskRemoteDataSource {
  Future<List<Task>> getAll();
  Future<Task> getById(String id);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String id);
}

/// Remote data source implementation that simulates API calls.
/// Currently uses in-memory storage for demonstration purposes.
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  static const Duration _simulatedDelay = Duration(milliseconds: 500);
  static final Map<String, Map<String, dynamic>> _simulatedServerStorage = {};

  @override
  Future<List<Task>> getAll() async {
    await Future.delayed(_simulatedDelay);

    try {
      if (DateTime.now().millisecond % 10 == 0) {
        throw NetworkException('Simulated network error for demo');
      }

      final tasks = _simulatedServerStorage.values
          .map((json) => Task.fromJson(json))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return tasks;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<Task> getById(String id) async {
    await Future.delayed(_simulatedDelay);

    try {
      final taskJson = _simulatedServerStorage[id];
      if (taskJson == null) {
        throw NetworkException('Task not found');
      }

      return Task.fromJson(taskJson);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to fetch task: $e');
    }
  }

  @override
  Future<Task> createTask(Task task) async {
    await Future.delayed(_simulatedDelay);

    try {
      final taskJson = task.toJson();
      _simulatedServerStorage[task.id] = taskJson;
      return task;
    } catch (e) {
      throw NetworkException('Failed to create task: $e');
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    await Future.delayed(_simulatedDelay);

    try {
      if (!_simulatedServerStorage.containsKey(task.id)) {
        throw NetworkException('Task not found');
      }

      _simulatedServerStorage[task.id] = task.toJson();
      return task;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await Future.delayed(_simulatedDelay);

    try {
      if (!_simulatedServerStorage.containsKey(id)) {
        throw NetworkException('Task not found');
      }

      _simulatedServerStorage.remove(id);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to delete task: $e');
    }
  }
}

