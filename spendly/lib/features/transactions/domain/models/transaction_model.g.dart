// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      isRecurring: json['isRecurring'] as bool,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'isRecurring': instance.isRecurring,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
