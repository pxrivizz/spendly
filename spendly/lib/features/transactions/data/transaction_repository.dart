import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/transaction_model.dart';
import '../../../../core/providers/firebase_providers.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore;
  TransactionRepository(this._firestore);

  // Watch all transactions for a user in a given month
  Stream<List<TransactionModel>> watchMonthlyTransactions({
    required String userId,
    required int month,
    required int year,
  }) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => TransactionModel.fromDocument(doc))
            .toList());
  }

  // Watch last N transactions
  Stream<List<TransactionModel>> watchRecentTransactions({
    required String userId,
    int limit = 5,
  }) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => TransactionModel.fromDocument(doc))
            .toList());
  }

  // Add transaction
  Future<void> addTransaction(String userId, TransactionModel tx) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(tx.id)
        .set(tx.toDocument());
  }

  // Delete transaction
  Future<void> deleteTransaction(String userId, String txId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(txId)
        .delete();
  }

  // Update transaction
  Future<void> updateTransaction(String userId, TransactionModel tx) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(tx.id)
        .update(tx.toDocument());
  }
}

// Repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepository(ref.watch(firestoreProvider)),
);

// Monthly transactions stream
final monthlyTransactionsProvider = StreamProvider.autoDispose
    .family<List<TransactionModel>, DateTime>((ref, month) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();

  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchMonthlyTransactions(
    userId: userId,
    month: month.month,
    year: month.year,
  );
});

// Recent transactions stream (dashboard)
final recentTransactionsProvider = StreamProvider.autoDispose
    <List<TransactionModel>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();

  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchRecentTransactions(userId: userId, limit: 5);
});
