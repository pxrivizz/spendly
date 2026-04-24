import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final String id;
  final String uid;
  final String categoryId;
  final double limit;
  final String monthYear; // e.g. "2025-04"
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BudgetModel({
    required this.id,
    required this.uid,
    required this.categoryId,
    required this.limit,
    required this.monthYear,
    this.createdAt,
    this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json, String id) {
    return BudgetModel(
      id: id,
      uid: json['uid'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      limit: (json['limit'] as num?)?.toDouble() ?? 0.0,
      monthYear: json['monthYear'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'categoryId': categoryId,
      'limit': limit,
      'monthYear': monthYear,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  BudgetModel copyWith({
    String? id,
    String? uid,
    String? categoryId,
    double? limit,
    String? monthYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      categoryId: categoryId ?? this.categoryId,
      limit: limit ?? this.limit,
      monthYear: monthYear ?? this.monthYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
