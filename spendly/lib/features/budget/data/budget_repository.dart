import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/budget_model.dart';
import '../../../../core/providers/firebase_providers.dart';

class BudgetRepository {
  final FirebaseFirestore _firestore;
  BudgetRepository(this._firestore);

  Stream<List<BudgetModel>> watchBudgets({
    required String userId,
    required int month,
    required int year,
  }) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => BudgetModel.fromDocument(doc))
            .toList());
  }

  Future<void> setBudget(String userId, BudgetModel budget) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budget.id)
        .set(budget.toDocument());
  }

  Future<void> deleteBudget(String userId, String budgetId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .delete();
  }
}

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => BudgetRepository(ref.watch(firestoreProvider)),
);

final monthlyBudgetsProvider = StreamProvider.autoDispose
    .family<List<BudgetModel>, DateTime>((ref, month) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();

  final repo = ref.watch(budgetRepositoryProvider);
  return repo.watchBudgets(
    userId: userId,
    month: month.month,
    year: month.year,
  );
});
