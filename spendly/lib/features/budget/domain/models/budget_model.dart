import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

/// Freezed budget model for immutability and serialization
@freezed
class BudgetModel with _$BudgetModel {
  const factory BudgetModel({
    /// Unique identifier for the budget
    required String id,

    /// User ID who owns this budget
    required String userId,

    /// Category ID this budget is for
    required String categoryId,

    /// Budget limit amount
    required double limit,

    /// Amount already spent in this budget period
    required double spent,

    /// Month (1-12) for this budget
    required int month,

    /// Year for this budget
    required int year,
  }) = _BudgetModel;

  const BudgetModel._();

  /// Create from JSON
  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  /// Create from Firestore document
  factory BudgetModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BudgetModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  /// Convert to Firestore document format
  Map<String, dynamic> toDocument() => toJson()..remove('id');

  /// Get remaining budget
  double get remaining => (limit - spent).clamp(0, double.infinity);

  /// Get spent percentage (0.0 - 1.0)
  double get spentPercentage => (spent / limit).clamp(0.0, 1.0);

  /// Check if budget is exceeded
  bool get isExceeded => spent > limit;
}
