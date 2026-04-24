import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/mesh_gradient_background.dart';
import '../../../../core/widgets/spendly_app_bar.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../domain/models/transaction_model.dart';
import '../widgets/filter_chips.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/transaction_date_group.dart';

/// Transactions list screen with search, filter, and grouped transaction list.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final transactionsAsync = ref.watch(monthlyTransactionsProvider(selectedMonth));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const MeshGradientBackground(),
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _AppBarDelegate(child: const SpendlyAppBar()),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppSpacing.md),

                    // Search bar
                    const SpendlySearchBar(
                      hintText: 'İşlem ara...',
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Filter chips
                    SpendlyFilterChips(
                      labels: const ['Tümü', 'Gider', 'Gelir', 'Bu Ay'],
                      selectedIndex: _selectedFilter,
                      onChanged: (index) =>
                          setState(() => _selectedFilter = index),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Grouped transactions
                    transactionsAsync.when(
                      data: (txs) {
                        if (txs.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text('İşlem bulunamadı.'),
                            ),
                          );
                        }

                        // Apply filters
                        var filteredTxs = txs;
                        if (_selectedFilter == 1) {
                          filteredTxs = txs.where((t) => t.type.name == 'expense').toList();
                        } else if (_selectedFilter == 2) {
                          filteredTxs = txs.where((t) => t.type.name == 'income').toList();
                        } else if (_selectedFilter == 3) {
                          final now = DateTime.now();
                          filteredTxs = txs.where((t) => t.date.month == now.month && t.date.year == now.year).toList();
                        }

                        // Group by date
                        final groups = <DateTime, List<TransactionModel>>{};
                        for (final tx in filteredTxs) {
                          final date = DateTime(tx.date.year, tx.date.month, tx.date.day);
                          groups[date] = (groups[date] ?? [])..add(tx);
                        }

                        final sortedDates = groups.keys.toList()..sort((a, b) => b.compareTo(a));

                        return Column(
                          children: sortedDates.map((date) {
                            final dateTxs = groups[date]!;
                            final label = _getDateLabel(date);
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: TransactionDateGroup(
                                dateLabel: label,
                                transactions: dateTxs.map((tx) {
                                  return TransactionData(
                                    icon: Icons.receipt_long, // TODO: Map icons
                                    iconColor: tx.type.name == 'income' ? AppColors.secondary : AppColors.primary,
                                    title: tx.title,
                                    subtitle: '${tx.type.name == 'income' ? 'Gelir' : 'Gider'} • ${DateFormat('HH:mm').format(tx.date)}',
                                    amount: '${tx.type.name == 'income' ? '+' : '-'}₺${tx.amount.toStringAsFixed(2)}',
                                    isIncome: tx.type.name == 'income',
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Hata: $e')),
                    ),

                    const SizedBox(height: 140),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'BUGÜN';
    if (date == yesterday) return 'DÜN';
    
    return DateFormat('d MMMM', 'tr_TR').format(date).toUpperCase();
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _AppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 64 + 50;

  @override
  double get minExtent => 64 + 50;

  @override
  bool shouldRebuild(covariant _AppBarDelegate oldDelegate) => false;
}

