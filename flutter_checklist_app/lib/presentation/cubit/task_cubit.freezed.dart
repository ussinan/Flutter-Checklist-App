// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TaskState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<Task> get allTasks => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  TaskFilter get filter => throw _privateConstructorUsedError;
  TaskSort get sort => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskStateCopyWith<TaskState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStateCopyWith<$Res> {
  factory $TaskStateCopyWith(TaskState value, $Res Function(TaskState) then) =
      _$TaskStateCopyWithImpl<$Res, TaskState>;
  @useResult
  $Res call({
    bool isLoading,
    List<Task> allTasks,
    String searchQuery,
    TaskFilter filter,
    TaskSort sort,
    int currentPage,
    int pageSize,
    String? errorMessage,
  });
}

/// @nodoc
class _$TaskStateCopyWithImpl<$Res, $Val extends TaskState>
    implements $TaskStateCopyWith<$Res> {
  _$TaskStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? allTasks = null,
    Object? searchQuery = null,
    Object? filter = null,
    Object? sort = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            allTasks: null == allTasks
                ? _value.allTasks
                : allTasks // ignore: cast_nullable_to_non_nullable
                      as List<Task>,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            filter: null == filter
                ? _value.filter
                : filter // ignore: cast_nullable_to_non_nullable
                      as TaskFilter,
            sort: null == sort
                ? _value.sort
                : sort // ignore: cast_nullable_to_non_nullable
                      as TaskSort,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskStateImplCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$$TaskStateImplCopyWith(
    _$TaskStateImpl value,
    $Res Function(_$TaskStateImpl) then,
  ) = __$$TaskStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    List<Task> allTasks,
    String searchQuery,
    TaskFilter filter,
    TaskSort sort,
    int currentPage,
    int pageSize,
    String? errorMessage,
  });
}

/// @nodoc
class __$$TaskStateImplCopyWithImpl<$Res>
    extends _$TaskStateCopyWithImpl<$Res, _$TaskStateImpl>
    implements _$$TaskStateImplCopyWith<$Res> {
  __$$TaskStateImplCopyWithImpl(
    _$TaskStateImpl _value,
    $Res Function(_$TaskStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? allTasks = null,
    Object? searchQuery = null,
    Object? filter = null,
    Object? sort = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$TaskStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        allTasks: null == allTasks
            ? _value._allTasks
            : allTasks // ignore: cast_nullable_to_non_nullable
                  as List<Task>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        filter: null == filter
            ? _value.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as TaskFilter,
        sort: null == sort
            ? _value.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as TaskSort,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TaskStateImpl extends _TaskState {
  const _$TaskStateImpl({
    this.isLoading = false,
    final List<Task> allTasks = const <Task>[],
    this.searchQuery = '',
    this.filter = TaskFilter.all,
    this.sort = TaskSort.createdAtDesc,
    this.currentPage = 1,
    this.pageSize = 20,
    this.errorMessage,
  }) : _allTasks = allTasks,
       super._();

  @override
  @JsonKey()
  final bool isLoading;
  final List<Task> _allTasks;
  @override
  @JsonKey()
  List<Task> get allTasks {
    if (_allTasks is EqualUnmodifiableListView) return _allTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allTasks);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final TaskFilter filter;
  @override
  @JsonKey()
  final TaskSort sort;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int pageSize;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TaskState(isLoading: $isLoading, allTasks: $allTasks, searchQuery: $searchQuery, filter: $filter, sort: $sort, currentPage: $currentPage, pageSize: $pageSize, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._allTasks, _allTasks) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_allTasks),
    searchQuery,
    filter,
    sort,
    currentPage,
    pageSize,
    errorMessage,
  );

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskStateImplCopyWith<_$TaskStateImpl> get copyWith =>
      __$$TaskStateImplCopyWithImpl<_$TaskStateImpl>(this, _$identity);
}

abstract class _TaskState extends TaskState {
  const factory _TaskState({
    final bool isLoading,
    final List<Task> allTasks,
    final String searchQuery,
    final TaskFilter filter,
    final TaskSort sort,
    final int currentPage,
    final int pageSize,
    final String? errorMessage,
  }) = _$TaskStateImpl;
  const _TaskState._() : super._();

  @override
  bool get isLoading;
  @override
  List<Task> get allTasks;
  @override
  String get searchQuery;
  @override
  TaskFilter get filter;
  @override
  TaskSort get sort;
  @override
  int get currentPage;
  @override
  int get pageSize;
  @override
  String? get errorMessage;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskStateImplCopyWith<_$TaskStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
