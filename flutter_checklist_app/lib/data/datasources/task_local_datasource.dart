import 'dart:async';

import 'package:hive/hive.dart';

import '../../domain/entities/task.dart';

/// Interface for local task data storage operations.
abstract class TaskLocalDataSource {
  Future<List<Task>> getAll();
  Stream<List<Task>> watchAll();
  Future<void> upsert(Task task);
  Future<void> delete(String id);
  Future<Task?> getById(String id);
}

/// Local data source implementation using Hive for persistent storage.
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  TaskLocalDataSourceImpl({required Future<Box<Map>> Function() boxFuture})
      : _openBox = boxFuture;

  final Future<Box<Map>> Function() _openBox;

  static const String _keyPrefix = 'task_';

  @override
  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete('$_keyPrefix$id');
  }

  @override
  Future<List<Task>> getAll() async {
    final box = await _openBox();
    return box.values
        .map((raw) => Task.fromJson(Map<String, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Task?> getById(String id) async {
    final box = await _openBox();
    final raw = box.get('$_keyPrefix$id');
    if (raw == null) return null;
    return Task.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<void> upsert(Task task) async {
    final box = await _openBox();
    await box.put('$_keyPrefix${task.id}', task.toJson());
  }

  @override
  Stream<List<Task>> watchAll() async* {
    final box = await _openBox();
    yield _readBox(box);
    yield* box.watch().map((_) => _readBox(box));
  }

  List<Task> _readBox(Box<Map> box) {
    final tasks = box.values
        .map((raw) => Task.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }
}


