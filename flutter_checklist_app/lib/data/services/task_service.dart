/// Example Task Service Layer
/// 
/// This is an OPTIONAL service layer that demonstrates how you could
/// structure your app if you need more separation of concerns.
/// 
/// **Current Recommendation:** Keep the current structure (ApiClient → DataSource → Repository)
/// 
/// **Consider this service layer if:**
/// - Your app grows in complexity
/// - You need to coordinate multiple API calls
/// - You have complex business logic around API calls
/// - You're working with a team

import '../../core/network/api_client.dart';
import '../../domain/entities/task.dart';

/// Service layer that handles API endpoints and business logic
/// 
/// Responsibilities:
/// - Define API endpoints
/// - Handle API request/response logic
/// - Transform data between API and domain models
/// - Coordinate multiple API calls if needed
class TaskService {
  TaskService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  // API Endpoints - centralized here
  static const String _tasksEndpoint = '/api/tasks';

  /// Get all tasks from API
  Future<List<Task>> getAllTasks() async {
    try {
      final response = await _apiClient.get(_tasksEndpoint);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to fetch tasks: $e');
    }
  }

  /// Get task by ID from API
  Future<Task> getTaskById(String id) async {
    try {
      final response = await _apiClient.get('$_tasksEndpoint/$id');
      final data = response.data as Map<String, dynamic>;
      return Task.fromJson(data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to fetch task: $e');
    }
  }

  /// Create new task via API
  Future<Task> createTask(Task task) async {
    try {
      final response = await _apiClient.post(
        _tasksEndpoint,
        data: task.toJson(),
      );
      final data = response.data as Map<String, dynamic>;
      return Task.fromJson(data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to create task: $e');
    }
  }

  /// Update task via API
  Future<Task> updateTask(Task task) async {
    try {
      final response = await _apiClient.put(
        '$_tasksEndpoint/${task.id}',
        data: task.toJson(),
      );
      final data = response.data as Map<String, dynamic>;
      return Task.fromJson(data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to update task: $e');
    }
  }

  /// Delete task via API
  Future<void> deleteTask(String id) async {
    try {
      await _apiClient.delete('$_tasksEndpoint/$id');
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to delete task: $e');
    }
  }

  /// Example: Complex business logic that coordinates multiple API calls
  Future<void> syncTasksWithServer(List<Task> localTasks) async {
    try {
      // Get tasks from server
      final serverTasks = await getAllTasks();

      // Compare and merge logic here
      // This is the kind of business logic that benefits from service layer
      
      // Example: Update local tasks that changed on server
      for (final serverTask in serverTasks) {
        final localTask = localTasks.firstWhere(
          (t) => t.id == serverTask.id,
          orElse: () => serverTask,
        );

        if (serverTask.updatedAt.isAfter(localTask.updatedAt)) {
          // Server version is newer, update local
          await updateTask(serverTask);
        }
      }
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to sync tasks: $e');
    }
  }
}

