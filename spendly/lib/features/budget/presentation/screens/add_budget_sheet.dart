import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/firebase_providers.dart';

import '../../data/budget_repository.dart';
import '../../domain/models/budget_model.dart';

class AddBudgetSheet extends ConsumerStatefulWidget {
  const AddBudgetSheet({super.key});

  @override
  ConsumerState<AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends ConsumerState<AddBudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  String _selectedCategoryId = 'yemek';
  bool _isSaving = false;

  static const _categories = [
    {'id': 'yemek',      'name': 'Yemek',       'icon': '🍔'},
    {'id': 'ulaşım',     'name': 'Ulaşım',       'icon': '🚗'},
    {'id': 'market',     'name': 'Market',       'icon': '🛍️'},
    {'id': 'fatura',     'name': 'Fatura',       'icon': '💡'},
    {'id': 'giyim',      'name': 'Giyim',        'icon': '👕'},
    {'id': 'eğlence',    'name': 'Eğlence',      'icon': '🎬'},
    {'id': 'sağlık',     'name': 'Sağlık',       'icon': '💊'},
    {'id': 'eğitim',     'name': 'Eğitim',       'icon': '📚'},
    {'id': 'seyahat',    'name': 'Seyahat',      'icon': '✈️'},
    {'id': 'diğer',      'name': 'Diğer',        'icon': '📦'},
  ];

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final limit = double.tryParse(
      _limitController.text.replaceAll(',', '.'),
    ) ?? 0.0;

    if (limit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir bütçe miktarı giriniz.'),
          backgroundColor: Color(0xFFFF4C4C),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final now = ref.read(selectedMonthProvider);
      final budget = BudgetModel(
        id: const Uuid().v4(),
        userId: userId,
        categoryId: _selectedCategoryId,
        limit: limit,
        spent: 0,
        month: now.month,
        year: now.year,
      );

      final repo = ref.read(budgetRepositoryProvider);
      await repo.setBudget(userId, budget);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bütçe başarıyla eklendi ✓'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: const Color(0xFFFF4C4C),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFF161D2A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A5568),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Başlık
                const Text(
                  'Bütçe Ekle',
                  style: TextStyle(
                    fontFamily: 'ClashDisplay',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Kategori seçici
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final cat = _categories[i];
                      final isSelected = _selectedCategoryId == cat['id'];
                      return GestureDetector(
                        onTap: () => setState(
                          () => _selectedCategoryId = cat['id']!,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0x2000D4AA)
                                : const Color(0xFF1C2640),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF00D4AA)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '${cat['icon']} ${cat['name']}',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFF00D4AA)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Tutar girişi
                const Text(
                  'Bütçe Miktarı (₺)',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _limitController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: '0,00',
                    hintStyle: const TextStyle(
                      color: Color(0xFF4A5568),
                    ),
                    prefixText: '₺ ',
                    prefixStyle: const TextStyle(
                      color: Color(0xFF00D4AA),
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1C2640),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF00D4AA),
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Miktar giriniz';
                    }
                    final val = double.tryParse(v.replaceAll(',', '.'));
                    if (val == null || val <= 0) {
                      return 'Geçerli bir miktar giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Kaydet butonu
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D4AA),
                      foregroundColor: const Color(0xFF00382B),
                      disabledBackgroundColor: const Color(0xFF1C2640),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Kaydet',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
