import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../cubit/task_cubit.dart';

/// Page for creating or editing a task.
class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key, this.existing});

  final Task? existing;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _descController = TextEditingController(text: widget.existing?.description ?? '');
    _isCompleted = widget.existing?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Create Task' : 'Edit Task'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 12),
                _ExpandableTextArea(controller: _descController),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _isCompleted,
                  onChanged: (v) => setState(() => _isCompleted = v),
                  title: const Text('Completed'),
                ),
                const SizedBox(height: 12),
                BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
                  return FilledButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() != true) return;
                            await context.read<TaskCubit>().addOrUpdateTask(
                                  id: widget.existing?.id,
                                  name: _nameController.text,
                                  description: _descController.text,
                                  isCompleted: _isCompleted,
                                );
                            if (mounted) Navigator.pop(context);
                          },
                    icon: state.isLoading ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                    label: Text(widget.existing == null ? 'Create' : 'Save'),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandableTextArea extends StatefulWidget {
  const _ExpandableTextArea({required this.controller});
  final TextEditingController controller;

  @override
  State<_ExpandableTextArea> createState() => _ExpandableTextAreaState();
}

class _ExpandableTextAreaState extends State<_ExpandableTextArea> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Description'),
            const Spacer(),
            TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              label: Text(_expanded ? 'Collapse' : 'Expand'),
            )
          ],
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: TextFormField(
            controller: widget.controller,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: 'Optional longer description',
              border: OutlineInputBorder(),
            ),
          ),
          secondChild: TextFormField(
            controller: widget.controller,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Optional longer description',
              border: OutlineInputBorder(),
            ),
          ),
        )
      ],
    );
  }
}


