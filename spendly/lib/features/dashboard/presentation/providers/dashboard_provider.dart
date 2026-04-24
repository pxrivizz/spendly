import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../../core/providers/firebase_providers.dart';

// Computed summary from monthly transactions
class DashboardSummary {
  final double totalIncome;
  final double totalExpense;
  final double savings;
  final Map<String, double> categoryBreakdown; // categoryId → amount

  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.savings,
    required this.categoryBreakdown,
  });
}

final dashboardSummaryProvider = Provider.autoDispose<AsyncValue<DashboardSummary>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) {
    return const AsyncData(DashboardSummary(
      totalIncome: 0,
      totalExpense: 0,
      savings: 0,
      categoryBreakdown: {},
    ));
  }

  final selectedMonth = ref.watch(selectedMonthProvider);
  final transactionsAsync = ref.watch(
    monthlyTransactionsProvider(selectedMonth),
  );

  return transactionsAsync.when(
    data: (transactions) {
      double income = 0;
      double expense = 0;
      final Map<String, double> breakdown = {};

      for (final tx in transactions) {
        if (tx.type == TransactionType.income) {
          income += tx.amount;
        } else {
          expense += tx.amount;
          breakdown[tx.categoryId] =
              (breakdown[tx.categoryId] ?? 0) + tx.amount;
        }
      }

      return AsyncData(DashboardSummary(
        totalIncome: income,
        totalExpense: expense,
        savings: income - expense,
        categoryBreakdown: breakdown,
      ));
    },
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
});
