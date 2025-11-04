import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../mock_data/mock_tasks.dart';

/// Service for loading mock/sample data into the app.
class MockDataService {
  MockDataService({required TaskRepository repository}) : _repository = repository;

  final TaskRepository _repository;

  /// Loads mock data if no tasks exist (first launch).
  Future<void> initializeMockDataIfNeeded() async {
    try {
      final existingTasks = await _repository.getAllTasks();
      if (existingTasks.isEmpty) {
        await _loadMockData();
      }
    } catch (e) {
      print('Failed to initialize mock data: $e');
    }
  }

  Future<void> _loadMockData() async {
    final mockTasks = MockTasks.getDailyChores();
    for (final task in mockTasks) {
      await _repository.upsertTask(task);
    }
  }

  /// Loads daily chores mock data.
  Future<void> loadMockData() async {
    await _loadMockData();
  }

  /// Loads weekend chores mock data.
  Future<void> loadWeekendChores() async {
    final weekendTasks = MockTasks.getWeekendChores();
    for (final task in weekendTasks) {
      await _repository.upsertTask(task);
    }
  }

  /// Loads all mock data (daily + weekend).
  Future<void> loadAllMockData() async {
    final allTasks = MockTasks.getAllMockTasks();
    for (final task in allTasks) {
      await _repository.upsertTask(task);
    }
  }

  /// Deletes all existing tasks and loads fresh mock data.
  Future<void> resetToMockData() async {
    try {
      final existingTasks = await _repository.getAllTasks();
      for (final task in existingTasks) {
        await _repository.deleteTask(task.id);
      }
      await _loadMockData();
    } catch (e) {
      print('Failed to reset to mock data: $e');
      rethrow;
    }
  }
}

