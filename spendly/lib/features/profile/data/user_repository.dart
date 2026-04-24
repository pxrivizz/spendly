import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/models/user_model.dart';
import '../../../../core/providers/firebase_providers.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  UserRepository(this._firestore);

  Stream<UserModel?> watchUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists
            ? UserModel.fromDocument(doc)
            : null);
  }

  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toDocument());
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(firestoreProvider)),
);

final currentUserProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const Stream.empty();

  return ref.watch(userRepositoryProvider).watchUser(userId);
});
