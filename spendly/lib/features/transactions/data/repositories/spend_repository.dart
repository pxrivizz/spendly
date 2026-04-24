import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/transaction.dart';

class SpendRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userTransactions(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions');
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      final docRef = _userTransactions(transaction.uid).doc();
      final newTransaction = transaction.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
      );
      await docRef.set(newTransaction.toJson());
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _userTransactions(transaction.uid)
          .doc(transaction.id)
          .update(transaction.toJson());
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String uid, String transactionId) async {
    try {
      await _userTransactions(uid).doc(transactionId).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  Stream<List<TransactionModel>> watchRecentTransactions(String uid, {int limit = 10}) {
    return _userTransactions(uid)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  Stream<List<TransactionModel>> watchMonthlyTransactions(String uid, DateTime startOfMonth, DateTime endOfMonth) {
    return _userTransactions(uid)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromJson(doc.data(), doc.id))
            .toList());
  }
}
