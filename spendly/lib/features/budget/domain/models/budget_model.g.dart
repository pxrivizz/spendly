// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetModelImpl _$$BudgetModelImplFromJson(Map<String, dynamic> json) =>
    _$BudgetModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      categoryId: json['categoryId'] as String,
      limit: (json['limit'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$$BudgetModelImplToJson(_$BudgetModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'categoryId': instance.categoryId,
      'limit': instance.limit,
      'spent': instance.spent,
      'month': instance.month,
      'year': instance.year,
    };
