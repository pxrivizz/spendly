import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Category type enum
enum CategoryType {
  @JsonValue('expense')
  expense,
  @JsonValue('income')
  income,
  @JsonValue('both')
  both,
}

/// Freezed category model for immutability and serialization
@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    /// Unique identifier for the category
    required String id,

    /// Category name
    required String name,

    /// Category icon as emoji string
    required String icon,

    /// Category color in hex format
    required String colorHex,

    /// Type of category (expense, income, or both)
    required CategoryType type,
  }) = _CategoryModel;

  const CategoryModel._();

  /// Create from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Create from Firestore document
  factory CategoryModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  /// Convert to Firestore document format
  Map<String, dynamic> toDocument() => toJson()..remove('id');
}
