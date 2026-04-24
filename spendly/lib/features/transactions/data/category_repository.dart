import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/category_model.dart';
import '../../../../core/providers/firebase_providers.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;
  CategoryRepository(this._firestore);

  Future<List<CategoryModel>> getCategories() async {
    final snap = await _firestore.collection('categories').get();
    return snap.docs
        .map((doc) => CategoryModel.fromDocument(doc))
        .toList();
  }

  Future<void> seedDefaultCategories() async {
    final existing = await _firestore.collection('categories').limit(1).get();
    if (existing.docs.isNotEmpty) return; // already seeded

    final defaults = [
      {'id': 'food', 'name': 'Food', 'icon': '🍔',
       'colorHex': '#FF6B6B', 'type': 'expense'},
      {'id': 'transport', 'name': 'Transport', 'icon': '🚗',
       'colorHex': '#4ECDC4', 'type': 'expense'},
      {'id': 'shopping', 'name': 'Shopping', 'icon': '🛍️',
       'colorHex': '#A855F7', 'type': 'expense'},
      {'id': 'health', 'name': 'Health', 'icon': '💊',
       'colorHex': '#10B981', 'type': 'expense'},
      {'id': 'entertainment', 'name': 'Entertainment', 'icon': '🎬',
       'colorHex': '#F59E0B', 'type': 'expense'},
      {'id': 'bills', 'name': 'Bills', 'icon': '💡',
       'colorHex': '#3B82F6', 'type': 'expense'},
      {'id': 'education', 'name': 'Education', 'icon': '📚',
       'colorHex': '#6366F1', 'type': 'expense'},
      {'id': 'travel', 'name': 'Travel', 'icon': '✈️',
       'colorHex': '#EC4899', 'type': 'expense'},
      {'id': 'salary', 'name': 'Salary', 'icon': '💰',
       'colorHex': '#4CAF50', 'type': 'income'},
      {'id': 'other', 'name': 'Other', 'icon': '📦',
       'colorHex': '#94A3B8', 'type': 'both'},
    ];

    final batch = _firestore.batch();
    for (final cat in defaults) {
      final ref = _firestore.collection('categories').doc(cat['id']);
      batch.set(ref, cat);
    }
    await batch.commit();
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(firestoreProvider)),
);

final categoriesProvider = FutureProvider.autoDispose<List<CategoryModel>>(
  (ref) => ref.watch(categoryRepositoryProvider).getCategories(),
);
