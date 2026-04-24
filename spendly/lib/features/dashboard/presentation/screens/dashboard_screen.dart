import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../../../transactions/domain/models/category_model.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../transactions/data/category_repository.dart';
import '../../../profile/data/user_repository.dart';
import '../providers/dashboard_provider.dart';

// Extension
extension ColorExtension on String {
  Color toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return const Color(0xFF94A3B8); // Default
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    
    if (userId == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E1A),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00D4AA),
          ),
        ),
      );
    }

    final selectedMonth = ref.watch(selectedMonthProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final recentTxAsync = ref.watch(recentTransactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: MeshBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: summaryAsync.when(
              loading: () => const DashboardSkeleton(),
              error: (e, _) => Center(child: Text(e.toString(), style: const TextStyle(color: Colors.red))),
              data: (summary) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(ref),
                    _buildMonthSelector(context, ref, selectedMonth),
                    _buildBalanceCard(summary),
                    categoriesAsync.when(
                      data: (categories) => _buildDonutChart(summary.categoryBreakdown, categories, summary.totalExpense),
                      loading: () => const ChartSkeleton(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    recentTxAsync.when(
                      data: (transactions) => _buildRecentTransactions(transactions, categoriesAsync.valueOrNull ?? []),
                      loading: () => const ListSkeleton(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final name = userAsync.valueOrNull?.displayName ?? 'User';
    
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Günaydın 👋',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12,
                  color: Color(0xFF94A3B8), // textSecondary
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'ClashDisplay',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFF1C2640), // elevated
            child: Icon(Icons.person_rounded, color: Color(0xFF00D4AA)),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context, WidgetRef ref, DateTime selectedMonth) {
    final monthStr = DateFormat('MMMM yyyy').format(selectedMonth);
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF94A3B8)),
            onPressed: () {
              ref.read(selectedMonthProvider.notifier).state = DateTime(
                selectedMonth.year,
                selectedMonth.month - 1,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              monthStr,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
            onPressed: () {
              ref.read(selectedMonthProvider.notifier).state = DateTime(
                selectedMonth.year,
                selectedMonth.month + 1,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(DashboardSummary summary) {
    return GlassCard(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'Bu Ay Toplam Harcama',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 13,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₺${summary.totalExpense.toStringAsFixed(2)}',
            style: const TextStyle(
              fontFamily: 'ClashDisplay',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatChip(
                icon: Icons.arrow_upward_rounded,
                iconColor: const Color(0xFF4CAF50),
                bgColor: const Color(0x1A4CAF50),
                label: 'Gelir',
                amount: '₺${summary.totalIncome.toStringAsFixed(0)}',
                amountColor: const Color(0xFF4CAF50),
              )),
              const SizedBox(width: 8),
              Expanded(child: _buildStatChip(
                icon: Icons.arrow_downward_rounded,
                iconColor: const Color(0xFFFF4C4C),
                bgColor: const Color(0x1AFF4C4C),
                label: 'Gider',
                amount: '₺${summary.totalExpense.toStringAsFixed(0)}',
                amountColor: const Color(0xFFFF4C4C),
              )),
              const SizedBox(width: 8),
              Expanded(child: _buildStatChip(
                icon: Icons.savings_rounded,
                iconColor: const Color(0xFF00D4AA),
                bgColor: const Color(0x1A00D4AA),
                label: 'Tasarruf',
                amount: '₺${summary.savings.toStringAsFixed(0)}',
                amountColor: const Color(0xFF00D4AA),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String amount,
    required Color amountColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: iconColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 11,
                    color: iconColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart(Map<String, double> categoryBreakdown, List<CategoryModel> categories, double totalExpense) {
    if (categoryBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Process breakdown into data list
    final data = <Map<String, dynamic>>[];
    final legends = <Widget>[];

    categoryBreakdown.forEach((categoryId, amount) {
      final category = categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => const CategoryModel(id: '', name: 'Unknown', icon: '❓', colorHex: '#94A3B8', type: CategoryType.both),
      );
      final sweep = amount / (totalExpense == 0 ? 1 : totalExpense);
      final color = category.colorHex.toColor();
      data.add({
        'color': color,
        'sweep': sweep,
      });
      legends.add(_buildLegendItem(category.name, color));
      legends.add(const SizedBox(width: 16));
    });

    return GlassCard(
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Harcama Dağılımı',
                style: TextStyle(
                  fontFamily: 'ClashDisplay',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              Text(
                'Bu Ay',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12,
                  color: Color(0xFF4A5568),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: DonutChartPainter(data),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Toplam',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      Text(
                        '₺${totalExpense.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'ClashDisplay',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: legends,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 12,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(List<TransactionModel> transactions, List<CategoryModel> categories) {
    if (transactions.isEmpty) return const SizedBox.shrink();

    final txWidgets = <Widget>[];
    for (int i = 0; i < transactions.length; i++) {
      final tx = transactions[i];
      final category = categories.firstWhere(
        (c) => c.id == tx.categoryId,
        orElse: () => const CategoryModel(id: '', name: 'Unknown', icon: '❓', colorHex: '#94A3B8', type: CategoryType.both),
      );
      
      final color = category.colorHex.toColor();
      final bgColor = color.withValues(alpha: 0.1);
      final subtitle = '${category.name} · ${DateFormat('MMM dd, HH:mm').format(tx.date)}';
      
      txWidgets.add(
        _buildTransactionItem(
          emoji: category.icon,
          bgColor: bgColor,
          title: tx.title,
          subtitle: subtitle,
          amount: tx.type == TransactionType.expense ? -tx.amount : tx.amount,
        )
      );
      if (i < transactions.length - 1) {
        txWidgets.add(_buildDivider());
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 24.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Son İşlemler',
                style: TextStyle(
                  fontFamily: 'ClashDisplay',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF00D4AA),
                ),
                child: const Text('Tümünü Gör'),
              ),
            ],
          ),
          ...txWidgets,
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String emoji,
    required Color bgColor,
    required String title,
    required String subtitle,
    required double amount,
  }) {
    final isPositive = amount > 0;
    final amountText = isPositive ? '+₺${amount.toStringAsFixed(0)}' : '-₺${amount.abs().toStringAsFixed(0)}';
    final amountColor = isPositive ? const Color(0xFF4CAF50) : const Color(0xFFFF4C4C);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 12,
                    color: Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5,
      color: const Color(0xFF1E2D45),
      margin: const EdgeInsets.only(left: 64),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  const DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 80.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2; // start at top
    // 4px gap as radians approx (4 / radius)
    final gapAngle = 4 / radius;

    for (final item in data) {
      final color = item['color'] as Color;
      final sweepRatio = item['sweep'] as double;
      final sweepAngle = (sweepRatio * 2 * pi);
      
      paint.color = color;
      
      // We subtract gapAngle from sweepAngle so it actually leaves a gap
      final actualSweep = sweepAngle > gapAngle ? sweepAngle - gapAngle : sweepAngle;

      canvas.drawArc(rect, startAngle, actualSweep, false, paint);
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
