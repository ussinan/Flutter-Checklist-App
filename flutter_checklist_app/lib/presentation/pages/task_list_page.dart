import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../data/services/mock_data_service.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../cubit/task_cubit.dart';
import 'task_form_page.dart';

/// Main page displaying the list of tasks.
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskCubit(repository: serviceLocator<TaskRepository>())..initialize(),
      child: const _TaskListView(),
    );
  }
}

class _TaskListView extends StatelessWidget {
  const _TaskListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              return IconButton(
                icon: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                onPressed: state.isLoading
                    ? null
                    : () => context.read<TaskCubit>().syncFromRemote(),
                tooltip: 'Sync from remote API',
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              final mockDataService = MockDataService(
                repository: serviceLocator<TaskRepository>(),
              );
              
              switch (value) {
                case 'load_mock':
                  await mockDataService.loadMockData();
                  if (context.mounted) {
                    context.read<TaskCubit>().initialize();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mock data loaded!')),
                    );
                  }
                  break;
                case 'reset_mock':
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Reset to Mock Data'),
                      content: const Text(
                        'This will delete all existing tasks and load mock data. Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await mockDataService.resetToMockData();
                    if (context.mounted) {
                      context.read<TaskCubit>().initialize();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reset to mock data!')),
                      );
                    }
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'load_mock',
                child: Row(
                  children: [
                    Icon(Icons.file_download, size: 20),
                    SizedBox(width: 8),
                    Text('Load Mock Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset_mock',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text('Reset to Mock Data'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _ControlsBar(),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<TaskCubit>().syncFromRemote(),
                  child: _TaskList(),
                ),
              ),
              const SizedBox(height: 8),
              _PaginationBar(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TaskCubit>(),
                child: const TaskFormPage(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}

class _ControlsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: context.read<TaskCubit>().setSearch,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<TaskFilter>(
                value: state.filter,
                onChanged: (v) => context.read<TaskCubit>().setFilter(v ?? TaskFilter.all),
                items: const [
                  DropdownMenuItem(value: TaskFilter.all, child: Text('All')),
                  DropdownMenuItem(value: TaskFilter.completed, child: Text('Completed')),
                  DropdownMenuItem(value: TaskFilter.incomplete, child: Text('Incomplete')),
                ],
              ),
              const SizedBox(width: 8),
              DropdownButton<TaskSort>(
                value: state.sort,
                onChanged: (v) => context.read<TaskCubit>().setSort(v ?? TaskSort.createdAtDesc),
                items: const [
                  DropdownMenuItem(value: TaskSort.createdAtDesc, child: Text('Newest')),
                  DropdownMenuItem(value: TaskSort.createdAtAsc, child: Text('Oldest')),
                  DropdownMenuItem(value: TaskSort.alphabetical, child: Text('A-Z')),
                  DropdownMenuItem(value: TaskSort.status, child: Text('Status')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Showing ${state.currentPageItems.length} of ${state.totalCount}'),
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
        ],
      );
    });
  }
}

class _TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      if (state.isLoading && state.allTasks.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      final items = state.currentPageItems;
      if (items.isEmpty) {
        return const _EmptyState();
      }
      return ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final task = items[index];
          return ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => context.read<TaskCubit>().toggleComplete(task),
            ),
            title: Text(task.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: task.description.isEmpty
                ? null
                : Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<TaskCubit>(),
                          child: TaskFormPage(existing: task),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Task'),
                        content: const Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await context.read<TaskCubit>().deleteTask(task.id);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class _PaginationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
      final totalPages = (state.totalCount / state.pageSize).ceil().clamp(1, 1 << 31);
      return Row(
        children: [
          IconButton(
            onPressed: state.currentPage > 1 ? () => context.read<TaskCubit>().setPage(state.currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text('Page ${state.currentPage} / $totalPages'),
          IconButton(
            onPressed: state.currentPage < totalPages
                ? () => context.read<TaskCubit>().setPage(state.currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
          const Spacer(),
          DropdownButton<int>(
            value: state.pageSize,
            onChanged: (v) => context.read<TaskCubit>().emit(state.copyWith(pageSize: v ?? 20, currentPage: 1)),
            items: const [10, 20, 50].map((e) => DropdownMenuItem(value: e, child: Text('Per page: $e'))).toList(),
          )
        ],
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64),
          const SizedBox(height: 8),
          const Text('No tasks found'),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<TaskCubit>(),
                  child: const TaskFormPage(),
                ),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Create your first task'),
          )
        ],
      ),
    );
  }
}


