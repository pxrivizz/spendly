// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      colorHex: json['colorHex'] as String,
      type: $enumDecode(_$CategoryTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'colorHex': instance.colorHex,
      'type': _$CategoryTypeEnumMap[instance.type]!,
    };

const _$CategoryTypeEnumMap = {
  CategoryType.expense: 'expense',
  CategoryType.income: 'income',
  CategoryType.both: 'both',
};
