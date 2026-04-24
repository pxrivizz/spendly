import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// removed

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/mesh_background.dart';
// removed
import '../../../../core/providers/firebase_providers.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../../../transactions/domain/models/category_model.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../transactions/data/category_repository.dart';

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

final analyticsDataProvider = Provider.autoDispose<AsyncValue<Map<String, dynamic>>>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final transactionsAsync = ref.watch(
    monthlyTransactionsProvider(selectedMonth),
  );

  return transactionsAsync.when(
    data: (transactions) {
      // Group by day for bar chart
      final Map<int, double> dailyTotals = {};
      for (final tx in transactions) {
        if (tx.type == TransactionType.expense) {
          final day = tx.date.day;
          dailyTotals[day] = (dailyTotals[day] ?? 0) + tx.amount;
        }
      }

      // Group by category for breakdown
      final Map<String, double> categoryTotals = {};
      for (final tx in transactions) {
        if (tx.type == TransactionType.expense) {
          categoryTotals[tx.categoryId] =
              (categoryTotals[tx.categoryId] ?? 0) + tx.amount;
        }
      }

      final totalExpense = categoryTotals.values
          .fold(0.0, (sum, v) => sum + v);

      return AsyncData({
        'dailyTotals': dailyTotals,
        'categoryTotals': categoryTotals,
        'totalExpense': totalExpense,
      });
    },
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
});

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _selectedPeriod = 1; // 0=Week, 1=Month, 2=Year (Keeping UI but data is monthly)

  @override
  Widget build(BuildContext context) {
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

    final analyticsAsync = ref.watch(analyticsDataProvider);
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
            child: analyticsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00D4AA))),
              error: (e, _) => Center(child: Text(e.toString(), style: const TextStyle(color: Colors.red))),
              data: (data) {
            final dailyTotals = data['dailyTotals'] as Map<int, double>;
            final categoryTotals = data['categoryTotals'] as Map<String, double>;
            final totalExpense = data['totalExpense'] as double;
            final categories = categoriesAsync.valueOrNull ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Analitik',
                      style: TextStyle(
                        fontFamily: 'ClashDisplay',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161D2A), // surface
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        _buildPeriodTab(0, 'Hafta'),
                        _buildPeriodTab(1, 'Ay'),
                        _buildPeriodTab(2, 'Yıl'),
                      ],
                    ),
                  ),

                  GlassCard(
                    margin: const EdgeInsets.only(top: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harcama Özeti',
                          style: TextStyle(
                            fontFamily: 'ClashDisplay',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: CustomPaint(
                            painter: BarChartPainter(dailyTotals),
                            size: Size.infinite,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GlassCard(
                    margin: const EdgeInsets.only(top: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kategoriye Göre',
                          style: TextStyle(
                            fontFamily: 'ClashDisplay',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...categoryTotals.entries.map((e) {
                          final category = categories.firstWhere(
                            (c) => c.id == e.key,
                            orElse: () => const CategoryModel(id: '', name: 'Unknown', icon: '❓', colorHex: '#94A3B8', type: CategoryType.both),
                          );
                          final amount = e.value;
                          final percent = totalExpense > 0 ? amount / totalExpense : 0.0;
                          return _buildCategoryRow(
                            name: category.name,
                            emoji: category.icon,
                            color: category.colorHex.toColor(),
                            amount: '₺${amount.toStringAsFixed(0)}',
                            percent: percent,
                          );
                        }),
                      ],
                    ),
                  ),

                  GlassCard(
                    margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Geçen Ayla Karşılaştırma',
                          style: TextStyle(
                            fontFamily: 'ClashDisplay',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Bu Ay',
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₺${totalExpense.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontFamily: 'ClashDisplay',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00D4AA),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Geçen Ay',
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '₺--',
                                    style: TextStyle(
                                      fontFamily: 'ClashDisplay',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
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
          },
        ),
      ),
    ],
      ),
    );
  }

  Widget _buildPeriodTab(int index, String title) {
    final isSelected = _selectedPeriod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00D4AA) : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF4A5568),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryRow({
    required String name,
    required String emoji,
    required Color color,
    required String amount,
    required double percent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2640), // elevated
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percent.clamp(0.0, 1.0),
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${(percent * 100).round()}% toplam',
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 11,
                    color: Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final Map<int, double> dailyTotals;
  const BarChartPainter(this.dailyTotals);

  @override
  void paint(Canvas canvas, Size size) {
    if (dailyTotals.isEmpty) return;

    final values = dailyTotals.values.toList();
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final maxBarHeight = 140.0;
    
    // Draw left axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final yLabels = [maxVal.toInt(), (maxVal / 2).toInt(), 0];
    final labelPositions = [0.0, maxBarHeight / 2, maxBarHeight];
    
    for (var i = 0; i < yLabels.length; i++) {
      textPainter.text = TextSpan(
        text: yLabels[i].toString(),
        style: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 10,
          color: Color(0xFF4A5568),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas, 
        Offset(0, labelPositions[i] - textPainter.height / 2),
      );
    }

    final barAreaLeft = 30.0;
    final barAreaWidth = size.width - barAreaLeft;
    
    final daysToDisplay = dailyTotals.keys.toList()..sort();
    final limit = daysToDisplay.length > 7 ? 7 : daysToDisplay.length;
    final displayDays = daysToDisplay.sublist(daysToDisplay.length - limit);

    final barSpacing = barAreaWidth / limit;
    final barWidth = barSpacing * 0.5;

    for (var i = 0; i < displayDays.length; i++) {
      final day = displayDays[i];
      final val = dailyTotals[day] ?? 0.0;
      final isHighest = val == maxVal;
      
      final heightRatio = maxVal == 0 ? 0.0 : val / maxVal;
      final barHeight = heightRatio * maxBarHeight;

      final x = barAreaLeft + (i * barSpacing) + (barSpacing - barWidth) / 2;
      final y = maxBarHeight - barHeight;

      final rrect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );

      final paint = Paint()
        ..color = isHighest ? const Color(0xFF00D4AA) : const Color(0xFF1C2640);

      if (isHighest) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.solid, 8);
      }

      canvas.drawRRect(rrect, paint);
      
      paint.maskFilter = null;
      if (isHighest) {
         final glowPaint = Paint()
           ..color = const Color(0x6600D4AA)
           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
         canvas.drawRRect(rrect, glowPaint);
         canvas.drawRRect(rrect, paint);
      }

      textPainter.text = TextSpan(
        text: day.toString(),
        style: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 10,
          color: Color(0xFF4A5568),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, maxBarHeight + 10),
      );

      if (isHighest) {
        final tooltipPaint = Paint()..color = const Color(0xFF161D2A); // surface
        final tooltipRRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x + barWidth / 2 - 20, y - 30, 40, 24),
          const Radius.circular(8),
        );
        canvas.drawRRect(tooltipRRect, tooltipPaint);
        
        textPainter.text = TextSpan(
          text: '₺${val.toStringAsFixed(0)}',
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 11,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w600,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + barWidth / 2 - textPainter.width / 2, y - 25),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
