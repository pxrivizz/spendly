import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/transactions/data/repositories/spend_repository.dart';
import '../../features/budget/data/repositories/budget_repository.dart';
import '../models/app_user.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

// ── Repositories ──────────────────────────────────────────────────────────

final spendRepositoryProvider = Provider<SpendRepository>((ref) {
  return SpendRepository();
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository();
});

// ── Auth & User State ─────────────────────────────────────────────────────

/// Stream of the custom AppUser document from Firestore
final appUserProvider = StreamProvider<AppUser?>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) {
    return Stream.value(null);
  }
  
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getUserDocumentStream(authUser.uid).map((doc) {
    if (doc.exists && doc.data() != null) {
      return AppUser.fromJson(doc.data()!);
    }
    return null;
  });
});

// ── Data Streams ──────────────────────────────────────────────────────────

/// Stream of recent transactions for the logged-in user
final recentTransactionsProvider = StreamProvider<List<TransactionModel>>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream.value([]);
  
  final spendRepository = ref.watch(spendRepositoryProvider);
  return spendRepository.watchRecentTransactions(authUser.uid);
});

/// Stream of monthly budgets for the logged-in user
final currentMonthBudgetsProvider = StreamProvider.family<List<BudgetModel>, String>((ref, monthYear) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream.value([]);

  final budgetRepository = ref.watch(budgetRepositoryProvider);
  return budgetRepository.watchMonthlyBudgets(authUser.uid, monthYear);
});
