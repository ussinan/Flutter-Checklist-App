import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// Task entity representing a single checklist item.
@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String name,
    @Default('') String description,
    @Default(false) bool isCompleted,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}


