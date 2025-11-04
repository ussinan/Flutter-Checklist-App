import '../../core/network/api_client.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';

/// Repository implementation that manages task data from local and remote sources.
/// Uses offline-first strategy: reads from local storage, writes to both local and remote.
class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required TaskLocalDataSource localDataSource,
    TaskRemoteDataSource? remoteDataSource,
  })  : _local = localDataSource,
        _remote = remoteDataSource;

  final TaskLocalDataSource _local;
  final TaskRemoteDataSource? _remote;

  bool get _shouldSync => _remote != null;

  @override
  Future<void> deleteTask(String id) async {
    await _local.delete(id);
    if (_shouldSync) {
      _syncDelete(id);
    }
  }

  @override
  Future<List<Task>> getAllTasks() async {
    return _local.getAll();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    return _local.getById(id);
  }

  @override
  Future<void> upsertTask(Task task) async {
    await _local.upsert(task);
    if (_shouldSync) {
      _syncUpsert(task);
    }
  }

  @override
  Stream<List<Task>> watchAllTasks() {
    return _local.watchAll().asBroadcastStream();
  }

  Future<void> _syncUpsert(Task task) async {
    try {
      if (task.id.isEmpty) {
        await _remote!.createTask(task);
      } else {
        await _remote!.updateTask(task);
      }
    } on NetworkException catch (e) {
      print('Failed to sync task to remote: ${e.message}');
    } catch (e) {
      print('Unexpected error syncing task: $e');
    }
  }

  Future<void> _syncDelete(String id) async {
    try {
      await _remote!.deleteTask(id);
    } on NetworkException catch (e) {
      print('Failed to sync delete to remote: ${e.message}');
    } catch (e) {
      print('Unexpected error syncing delete: $e');
    }
  }

  /// Fetches all tasks from remote API and updates local storage.
  Future<void> syncFromRemote() async {
    if (!_shouldSync) return;

    try {
      final remoteTasks = await _remote!.getAll();
      for (final task in remoteTasks) {
        await _local.upsert(task);
      }
    } on NetworkException catch (e) {
      print('Failed to sync from remote: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error syncing from remote: $e');
      rethrow;
    }
  }
}
