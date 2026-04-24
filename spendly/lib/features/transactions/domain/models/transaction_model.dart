import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Transaction type enum
enum TransactionType {
  @JsonValue('income')
  income,
  @JsonValue('expense')
  expense,
}

/// Freezed transaction model for immutability and serialization
@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    /// Unique identifier for the transaction
    required String id,

    /// User ID who owns this transaction
    required String userId,

    /// Transaction amount
    required double amount,

    /// Category ID this transaction belongs to
    required String categoryId,

    /// Transaction title/description
    required String title,

    /// Date of the transaction
    required DateTime date,

    /// Type of transaction (income or expense)
    required TransactionType type,

    /// Whether this is a recurring transaction
    required bool isRecurring,

    /// Optional note for the transaction
    String? note,

    /// Timestamp when the transaction was created
    required DateTime createdAt,
  }) = _TransactionModel;

  const TransactionModel._();

  /// Create from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Create from Firestore document
  factory TransactionModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  /// Convert to Firestore document format
  Map<String, dynamic> toDocument() => toJson()..remove('id');
}
