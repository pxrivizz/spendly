// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) {
  return _BudgetModel.fromJson(json);
}

/// @nodoc
mixin _$BudgetModel {
  /// Unique identifier for the budget
  String get id => throw _privateConstructorUsedError;

  /// User ID who owns this budget
  String get userId => throw _privateConstructorUsedError;

  /// Category ID this budget is for
  String get categoryId => throw _privateConstructorUsedError;

  /// Budget limit amount
  double get limit => throw _privateConstructorUsedError;

  /// Amount already spent in this budget period
  double get spent => throw _privateConstructorUsedError;

  /// Month (1-12) for this budget
  int get month => throw _privateConstructorUsedError;

  /// Year for this budget
  int get year => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetModelCopyWith<BudgetModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetModelCopyWith<$Res> {
  factory $BudgetModelCopyWith(
          BudgetModel value, $Res Function(BudgetModel) then) =
      _$BudgetModelCopyWithImpl<$Res, BudgetModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String categoryId,
      double limit,
      double spent,
      int month,
      int year});
}

/// @nodoc
class _$BudgetModelCopyWithImpl<$Res, $Val extends BudgetModel>
    implements $BudgetModelCopyWith<$Res> {
  _$BudgetModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? categoryId = null,
    Object? limit = null,
    Object? spent = null,
    Object? month = null,
    Object? year = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      spent: null == spent
          ? _value.spent
          : spent // ignore: cast_nullable_to_non_nullable
              as double,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetModelImplCopyWith<$Res>
    implements $BudgetModelCopyWith<$Res> {
  factory _$$BudgetModelImplCopyWith(
          _$BudgetModelImpl value, $Res Function(_$BudgetModelImpl) then) =
      __$$BudgetModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String categoryId,
      double limit,
      double spent,
      int month,
      int year});
}

/// @nodoc
class __$$BudgetModelImplCopyWithImpl<$Res>
    extends _$BudgetModelCopyWithImpl<$Res, _$BudgetModelImpl>
    implements _$$BudgetModelImplCopyWith<$Res> {
  __$$BudgetModelImplCopyWithImpl(
      _$BudgetModelImpl _value, $Res Function(_$BudgetModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? categoryId = null,
    Object? limit = null,
    Object? spent = null,
    Object? month = null,
    Object? year = null,
  }) {
    return _then(_$BudgetModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      spent: null == spent
          ? _value.spent
          : spent // ignore: cast_nullable_to_non_nullable
              as double,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetModelImpl extends _BudgetModel {
  const _$BudgetModelImpl(
      {required this.id,
      required this.userId,
      required this.categoryId,
      required this.limit,
      required this.spent,
      required this.month,
      required this.year})
      : super._();

  factory _$BudgetModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetModelImplFromJson(json);

  /// Unique identifier for the budget
  @override
  final String id;

  /// User ID who owns this budget
  @override
  final String userId;

  /// Category ID this budget is for
  @override
  final String categoryId;

  /// Budget limit amount
  @override
  final double limit;

  /// Amount already spent in this budget period
  @override
  final double spent;

  /// Month (1-12) for this budget
  @override
  final int month;

  /// Year for this budget
  @override
  final int year;

  @override
  String toString() {
    return 'BudgetModel(id: $id, userId: $userId, categoryId: $categoryId, limit: $limit, spent: $spent, month: $month, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.spent, spent) || other.spent == spent) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, categoryId, limit, spent, month, year);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetModelImplCopyWith<_$BudgetModelImpl> get copyWith =>
      __$$BudgetModelImplCopyWithImpl<_$BudgetModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetModelImplToJson(
      this,
    );
  }
}

abstract class _BudgetModel extends BudgetModel {
  const factory _BudgetModel(
      {required final String id,
      required final String userId,
      required final String categoryId,
      required final double limit,
      required final double spent,
      required final int month,
      required final int year}) = _$BudgetModelImpl;
  const _BudgetModel._() : super._();

  factory _BudgetModel.fromJson(Map<String, dynamic> json) =
      _$BudgetModelImpl.fromJson;

  @override

  /// Unique identifier for the budget
  String get id;
  @override

  /// User ID who owns this budget
  String get userId;
  @override

  /// Category ID this budget is for
  String get categoryId;
  @override

  /// Budget limit amount
  double get limit;
  @override

  /// Amount already spent in this budget period
  double get spent;
  @override

  /// Month (1-12) for this budget
  int get month;
  @override

  /// Year for this budget
  int get year;
  @override
  @JsonKey(ignore: true)
  _$$BudgetModelImplCopyWith<_$BudgetModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
