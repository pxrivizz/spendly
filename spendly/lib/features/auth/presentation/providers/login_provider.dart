import 'package:firebase_auth/firebase_auth.dart';
// Removed flutter_riverpod import
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Do NOT navigate here — router handles it
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Do NOT navigate here — router handles it
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}
