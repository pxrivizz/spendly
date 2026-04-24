import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/budget.dart';

class BudgetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userBudgets(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('budgets');
  }

  Future<void> setBudget(BudgetModel budget) async {
    try {
      // Use categoryId and monthYear as a composite document ID for uniqueness
      final docId = '${budget.categoryId}_${budget.monthYear}';
      final docRef = _userBudgets(budget.uid).doc(docId);
      
      final newBudget = budget.copyWith(
        id: docId,
        updatedAt: DateTime.now(),
        createdAt: budget.createdAt ?? DateTime.now(),
      );
      
      await docRef.set(newBudget.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to set budget: $e');
    }
  }

  Future<void> deleteBudget(String uid, String budgetId) async {
    try {
      await _userBudgets(uid).doc(budgetId).delete();
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }

  Stream<List<BudgetModel>> watchMonthlyBudgets(String uid, String monthYear) {
    return _userBudgets(uid)
        .where('monthYear', isEqualTo: monthYear)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetModel.fromJson(doc.data(), doc.id))
            .toList());
  }
}
