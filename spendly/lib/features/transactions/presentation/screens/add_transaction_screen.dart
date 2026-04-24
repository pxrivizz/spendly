import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../domain/models/transaction_model.dart';
import '../widgets/amount_display.dart';
import '../widgets/category_picker.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/transaction_type_toggle.dart';

/// Full-screen add transaction sheet.
///
/// Layout: Header + Type Toggle → Amount Display → Category Picker →
/// Description field → Numeric Keypad → Save Button
class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  bool _isExpense = true;
  int _selectedCategoryIndex = 0;
  String _amountText = '0,00';
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSaving = false;

  static const _categories = [
    _CategoryData(Icons.restaurant, 'YEMEK', AppColors.secondary),
    _CategoryData(Icons.directions_car, 'ULAŞIM', AppColors.primary),
    _CategoryData(Icons.shopping_cart, 'MARKET', AppColors.tertiary),
    _CategoryData(Icons.receipt_long, 'FATURA', AppColors.tertiaryFixedDim),
    _CategoryData(Icons.checkroom, 'GİYİM', AppColors.error),
    _CategoryData(Icons.movie, 'EĞLENCE', AppColors.primaryFixedDim),
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onKeyPressed(String key) {
    if (_isSaving) return;
    setState(() {
      if (key == '⌫') {
        if (_amountText.length > 1) {
          final rawDigits = _amountText.replaceAll(RegExp(r'[^\d]'), '');
          if (rawDigits.length > 1) {
            final newDigits = rawDigits.substring(0, rawDigits.length - 1);
            final newValue = int.parse(newDigits);
            _amountText = (newValue / 100).toStringAsFixed(2).replaceAll('.', ',');
          } else {
            _amountText = '0,00';
          }
        }
      } else if (key == ',') {
        // Decimal logic
      } else {
        final rawDigits = _amountText.replaceAll(RegExp(r'[^\d]'), '');
        if (rawDigits == '000' || rawDigits == '0') {
          _amountText = (int.parse(key) / 100).toStringAsFixed(2).replaceAll('.', ',');
        } else {
          final newDigits = rawDigits + key;
          final newValue = int.parse(newDigits);
          _amountText = (newValue / 100).toStringAsFixed(2).replaceAll('.', ',');
        }
      }
    });
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(_amountText.replaceAll(',', '.')) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir tutar giriniz.')),
      );
      return;
    }

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Oturum açmanız gerekiyor.'),
          backgroundColor: Color(0xFFFF4C4C),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(transactionRepositoryProvider);
      final tx = TransactionModel(
        id: const Uuid().v4(),
        userId: userId,
        amount: amount,
        categoryId: _categories[_selectedCategoryIndex].label.toLowerCase(),
        title: _descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : _categories[_selectedCategoryIndex].label,
        date: DateTime.now(),
        type: _isExpense ? TransactionType.expense : TransactionType.income,
        isRecurring: false,
        createdAt: DateTime.now(),
      );

      await repository.addTransaction(userId, tx);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('İşlem Ekle', style: AppTextStyles.h3),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerHighest,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.onSurfaceVariant,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Type Toggle
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin,
              ),
              child: TransactionTypeToggle(
                isExpense: _isExpense,
                onChanged: (value) => setState(() => _isExpense = value),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Amount
            AmountDisplay(amount: '₺ $_amountText'),

            const SizedBox(height: AppSpacing.lg),

            // Category Picker
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin,
              ),
              child: CategoryPicker(
                categories: _categories.map((c) {
                  return CategoryPickerItem(
                    icon: c.icon,
                    label: c.label,
                    color: c.color,
                  );
                }).toList(),
                selectedIndex: _selectedCategoryIndex,
                onChanged: (index) =>
                    setState(() => _selectedCategoryIndex = index),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Description field
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sticky_note_2_outlined,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AÇIKLAMA',
                          style: AppTextStyles.labelCaps.copyWith(
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _descriptionController,
                            style: AppTextStyles.bodyMd,
                            enabled: !_isSaving,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Ne için harcadınız?',
                              hintStyle: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.outline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Numeric Keypad
            NumericKeypad(onKeyPressed: _onKeyPressed),

            const SizedBox(height: AppSpacing.md),

            // Save button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  child: _isSaving 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(
                        'Kaydet',
                        style: AppTextStyles.bodyLg.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimary,
                        ),
                      ),
                ),
              ),
            ),

            SizedBox(
              height: MediaQuery.paddingOf(context).bottom + AppSpacing.md,
            ),
          ],
        ),
      ),
    );
  }
}


class _CategoryData {
  final IconData icon;
  final String label;
  final Color color;

  const _CategoryData(this.icon, this.label, this.color);
}
