import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../data/budget_repository.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../transactions/data/category_repository.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../../../transactions/domain/models/category_model.dart';
import 'add_budget_sheet.dart';

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

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

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
    final budgetsAsync = ref.watch(monthlyBudgetsProvider(selectedMonth));
    final transactionsAsync = ref.watch(
      monthlyTransactionsProvider(selectedMonth),
    );
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
            child: budgetsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
          ),
          error: (e, _) => Center(child: Text(e.toString(), style: const TextStyle(color: Colors.red))),
          data: (budgets) {
            // Calculate spent per category from transactions
            final spentMap = <String, double>{};
            transactionsAsync.valueOrNull?.forEach((tx) {
              if (tx.type == TransactionType.expense) {
                spentMap[tx.categoryId] =
                    (spentMap[tx.categoryId] ?? 0) + tx.amount;
              }
            });

            // Update budget spent values from real transactions
            final budgetsWithSpent = budgets.map((b) =>
              b.copyWith(spent: spentMap[b.categoryId] ?? 0)
            ).toList();

            final totalLimit = budgetsWithSpent
                .fold(0.0, (sum, b) => sum + b.limit);
            final totalSpent = budgetsWithSpent
                .fold(0.0, (sum, b) => sum + b.spent);
            
            final categories = categoriesAsync.valueOrNull ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildHeader(context, ref),
                  _buildTotalRing(totalSpent, totalLimit),
                  const Padding(
                    padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kategori Bütçeleri',
                        style: TextStyle(
                          fontFamily: 'ClashDisplay',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  ...budgetsWithSpent.map((b) {
                    final cat = categories.firstWhere(
                      (c) => c.id == b.categoryId,
                      orElse: () => const CategoryModel(id: '', name: 'Unknown', icon: '❓', colorHex: '#94A3B8', type: CategoryType.both),
                    );
                    final percent = b.limit > 0 ? b.spent / b.limit : 0.0;
                    return _buildBudgetCard(
                      name: cat.name,
                      emoji: cat.icon,
                      color: cat.colorHex.toColor(),
                      spent: b.spent,
                      limit: b.limit,
                      percent: percent,
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Bütçe',
            style: TextStyle(
              fontFamily: 'ClashDisplay',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Color(0xFF00D4AA)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AddBudgetSheet(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRing(double totalSpent, double totalLimit) {
    final remaining = totalLimit - totalSpent;
    final percent = totalLimit > 0 ? totalSpent / totalLimit : 0.0;

    return GlassCard(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: RingChartPainter(percent),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aylık Bütçe',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 13,
                      color: Color(0xFF4A5568), // textMuted
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₺${totalLimit.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'ClashDisplay',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDot(const Color(0xFF4CAF50)), // success
                      Text(
                        ' Harcanan: ₺${totalSpent.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 13,
                          color: Color(0xFF94A3B8), // textSecondary
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildDot(const Color(0xFF1E2D45)), // border
                      Text(
                        ' Kalan: ₺${remaining.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 13,
                          color: Color(0xFF94A3B8), // textSecondary
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161D2A), // surface
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'Bu ay',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 12,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBudgetCard({
    required String name,
    required String emoji,
    required Color color,
    required double spent,
    required double limit,
    required double percent,
  }) {
    final remaining = limit - spent;
    final isOverBudget = percent >= 1.0;
    final isAlmostLimit = percent >= 0.85 && percent < 1.0;
    
    final barColor = isOverBudget 
        ? const Color(0xFFFF4C4C) // error
        : isAlmostLimit 
            ? const Color(0xFFFFB347) // secondary
            : color;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    Text(
                      '₺${spent.toStringAsFixed(0)} / ₺${limit.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 13,
                        color: Color(0xFF94A3B8), // textSecondary
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2D45), // border
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percent.clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isOverBudget)
                      Text(
                        '⚠️ Bütçe aşımı: ₺${remaining.abs().toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 11,
                          color: Color(0xFFFF4C4C), // error
                        ),
                      )
                    else if (isAlmostLimit)
                      const Text(
                        '⚡ Limite yaklaşıldı',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 11,
                          color: Color(0xFFFFB347), // secondary
                        ),
                      )
                    else
                      Text(
                        '₺${remaining.toStringAsFixed(0)} kaldı',
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 11,
                          color: Color(0xFF4A5568), // textMuted
                        ),
                      ),
                    Text(
                      '${(percent * 100).round()}%',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: barColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RingChartPainter extends CustomPainter {
  final double percent;
  const RingChartPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = const Color(0xFF1E2D45) // border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    canvas.drawArc(rect, 0, 2 * pi, false, bgPaint);

    final progressPaint = Paint()
      ..color = percent >= 1.0 ? const Color(0xFFFF4C4C) : const Color(0xFF00D4AA) // primary teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = percent.clamp(0.0, 1.0) * 2 * pi;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    // Draw center text
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: '${(percent * 100).round()}%\n',
      style: const TextStyle(
        fontFamily: 'ClashDisplay',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFFFFF),
      ),
      children: const [
        TextSpan(
          text: 'kullanıldı',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: Color(0xFF4A5568),
          ),
        ),
      ],
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
