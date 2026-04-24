import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String uid;
  final String title;
  final String categoryId;
  final double amount; // negative for expense, positive for income
  final DateTime date;
  final DateTime? createdAt;
  final String? note;

  const TransactionModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.categoryId,
    required this.amount,
    required this.date,
    this.createdAt,
    this.note,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json, String id) {
    return TransactionModel(
      id: id,
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'categoryId': categoryId,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (note != null) 'note': note,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? categoryId,
    double? amount,
    DateTime? date,
    DateTime? createdAt,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }
}
