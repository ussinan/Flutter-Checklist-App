import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

part 'task_cubit.freezed.dart';

/// Filter options for task list display.
enum TaskFilter { 
  all, 
  completed, 
  incomplete 
}

/// Sort options for task list.
enum TaskSort { 
  createdAtDesc, 
  createdAtAsc, 
  alphabetical, 
  status 
}

@freezed
class TaskState with _$TaskState {
  const factory TaskState({
    @Default(false) bool isLoading,
    @Default(<Task>[]) List<Task> allTasks,
    @Default('') String searchQuery,
    @Default(TaskFilter.all) TaskFilter filter,
    @Default(TaskSort.createdAtDesc) TaskSort sort,
    @Default(1) int currentPage,
    @Default(20) int pageSize,
    String? errorMessage,
  }) = _TaskState;

  const TaskState._();

  List<Task> get filteredSortedTasks {
    Iterable<Task> tasks = allTasks;

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      tasks = tasks.where((t) =>
          t.name.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q));
    }

    switch (filter) {
      case TaskFilter.completed:
        tasks = tasks.where((t) => t.isCompleted);
        break;
      case TaskFilter.incomplete:
        tasks = tasks.where((t) => !t.isCompleted);
        break;
      case TaskFilter.all:
        break;
    }

    final list = tasks.toList();
    switch (sort) {
      case TaskSort.createdAtDesc:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSort.createdAtAsc:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TaskSort.alphabetical:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case TaskSort.status:
        list.sort((a, b) => (a.isCompleted ? 1 : 0).compareTo(b.isCompleted ? 1 : 0));
        break;
    }

    return list;
  }

  int get totalCount => filteredSortedTasks.length;

  List<Task> get currentPageItems {
    final start = (currentPage - 1) * pageSize;
    if (start >= filteredSortedTasks.length) return <Task>[];
    final end = min(start + pageSize, filteredSortedTasks.length);
    return filteredSortedTasks.sublist(start, end);
  }
}

class TaskCubit extends Cubit<TaskState> {
  TaskCubit({required TaskRepository repository})
      : _repository = repository,
        super(const TaskState());

  final TaskRepository _repository;

  StreamSubscription<List<Task>>? _subscription;

  /// Initializes the cubit and starts listening to task updates.
  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _subscription?.cancel();
      _subscription = _repository.watchAllTasks().listen(
        (tasks) {
          emit(state.copyWith(isLoading: false, allTasks: tasks));
        },
        onError: (e) {
          emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void setSearch(String query) {
    emit(state.copyWith(searchQuery: query, currentPage: 1));
  }

  void setFilter(TaskFilter filter) {
    emit(state.copyWith(filter: filter, currentPage: 1));
  }

  void setSort(TaskSort sort) {
    emit(state.copyWith(sort: sort, currentPage: 1));
  }

  void setPage(int page) {
    emit(state.copyWith(currentPage: max(1, page)));
  }

  Future<void> addOrUpdateTask({
    String? id,
    required String name,
    String description = '',
    bool isCompleted = false,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final now = DateTime.now();
      final task = Task(
        id: id ?? now.microsecondsSinceEpoch.toString(),
        name: name.trim(),
        description: description.trim(),
        isCompleted: isCompleted,
        createdAt: id == null ? now : (await _repository.getTaskById(id))?.createdAt ?? now,
        updatedAt: now,
      );
      await _repository.upsertTask(task);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> toggleComplete(Task task) async {
    await addOrUpdateTask(
      id: task.id,
      name: task.name,
      description: task.description,
      isCompleted: !task.isCompleted,
    );
  }

  Future<void> deleteTask(String id) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _repository.deleteTask(id);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Syncs tasks from remote API to local storage.
  Future<void> syncFromRemote() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      if (_repository is TaskRepositoryImpl) {
        await (_repository as TaskRepositoryImpl).syncFromRemote();
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Remote sync not available',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
  
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}


