// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  /// Unique identifier for the transaction
  String get id => throw _privateConstructorUsedError;

  /// User ID who owns this transaction
  String get userId => throw _privateConstructorUsedError;

  /// Transaction amount
  double get amount => throw _privateConstructorUsedError;

  /// Category ID this transaction belongs to
  String get categoryId => throw _privateConstructorUsedError;

  /// Transaction title/description
  String get title => throw _privateConstructorUsedError;

  /// Date of the transaction
  DateTime get date => throw _privateConstructorUsedError;

  /// Type of transaction (income or expense)
  TransactionType get type => throw _privateConstructorUsedError;

  /// Whether this is a recurring transaction
  bool get isRecurring => throw _privateConstructorUsedError;

  /// Optional note for the transaction
  String? get note => throw _privateConstructorUsedError;

  /// Timestamp when the transaction was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) then) =
      _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      double amount,
      String categoryId,
      String title,
      DateTime date,
      TransactionType type,
      bool isRecurring,
      String? note,
      DateTime createdAt});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amount = null,
    Object? categoryId = null,
    Object? title = null,
    Object? date = null,
    Object? type = null,
    Object? isRecurring = null,
    Object? note = freezed,
    Object? createdAt = null,
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
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(_$TransactionModelImpl value,
          $Res Function(_$TransactionModelImpl) then) =
      __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      double amount,
      String categoryId,
      String title,
      DateTime date,
      TransactionType type,
      bool isRecurring,
      String? note,
      DateTime createdAt});
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(_$TransactionModelImpl _value,
      $Res Function(_$TransactionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amount = null,
    Object? categoryId = null,
    Object? title = null,
    Object? date = null,
    Object? type = null,
    Object? isRecurring = null,
    Object? note = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$TransactionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl extends _TransactionModel {
  const _$TransactionModelImpl(
      {required this.id,
      required this.userId,
      required this.amount,
      required this.categoryId,
      required this.title,
      required this.date,
      required this.type,
      required this.isRecurring,
      this.note,
      required this.createdAt})
      : super._();

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  /// Unique identifier for the transaction
  @override
  final String id;

  /// User ID who owns this transaction
  @override
  final String userId;

  /// Transaction amount
  @override
  final double amount;

  /// Category ID this transaction belongs to
  @override
  final String categoryId;

  /// Transaction title/description
  @override
  final String title;

  /// Date of the transaction
  @override
  final DateTime date;

  /// Type of transaction (income or expense)
  @override
  final TransactionType type;

  /// Whether this is a recurring transaction
  @override
  final bool isRecurring;

  /// Optional note for the transaction
  @override
  final String? note;

  /// Timestamp when the transaction was created
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TransactionModel(id: $id, userId: $userId, amount: $amount, categoryId: $categoryId, title: $title, date: $date, type: $type, isRecurring: $isRecurring, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, amount, categoryId,
      title, date, type, isRecurring, note, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(
      this,
    );
  }
}

abstract class _TransactionModel extends TransactionModel {
  const factory _TransactionModel(
      {required final String id,
      required final String userId,
      required final double amount,
      required final String categoryId,
      required final String title,
      required final DateTime date,
      required final TransactionType type,
      required final bool isRecurring,
      final String? note,
      required final DateTime createdAt}) = _$TransactionModelImpl;
  const _TransactionModel._() : super._();

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  @override

  /// Unique identifier for the transaction
  String get id;
  @override

  /// User ID who owns this transaction
  String get userId;
  @override

  /// Transaction amount
  double get amount;
  @override

  /// Category ID this transaction belongs to
  String get categoryId;
  @override

  /// Transaction title/description
  String get title;
  @override

  /// Date of the transaction
  DateTime get date;
  @override

  /// Type of transaction (income or expense)
  TransactionType get type;
  @override

  /// Whether this is a recurring transaction
  bool get isRecurring;
  @override

  /// Optional note for the transaction
  String? get note;
  @override

  /// Timestamp when the transaction was created
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
