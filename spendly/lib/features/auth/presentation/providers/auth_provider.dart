import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository.dart';
import '../../../transactions/data/category_repository.dart';

part 'auth_provider.g.dart';

/// Auth repository provider — kept alive because [authStateProvider]
/// (which is also keepAlive) depends on it.
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

/// Auth state stream provider — MUST be kept alive so the router redirect
/// can always read the current auth state synchronously. If this were
/// autoDispose, it would be disposed when no widget is watching it (e.g.,
/// during a GoRouter redirect), causing `ref.read()` to return AsyncLoading
/// and the redirect to silently skip.
@Riverpod(keepAlive: true)
Stream<User?> authState(AuthStateRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
}

/// Current user notifier provider
@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  Future<User?> build() async {
    return ref.watch(authStateProvider).maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
  }
}

/// Sign in with Google notifier
@riverpod
class SignInWithGoogle extends _$SignInWithGoogle {
  @override
  FutureOr<void> build() {
    // Empty initial state
  }

  /// Trigger Google sign in
  Future<void> signIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithGoogle();
      await ref.read(categoryRepositoryProvider).seedDefaultCategories();
    });
  }
}

/// Sign in with email and password notifier
@riverpod
class SignInWithEmailPassword extends _$SignInWithEmailPassword {
  @override
  FutureOr<void> build() {
    // Empty initial state
  }

  /// Trigger email/password sign in
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    debugPrint('[SignInNotifier] Starting sign in for $email');
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithEmailPassword(email, password);
    });
    
    if (state.hasError) {
      debugPrint('[SignInNotifier] Sign in error: ${state.error}');
    } else {
      debugPrint('[SignInNotifier] Sign in success');
    }
  }
}

/// Sign up with email and password notifier
@riverpod
class SignUpWithEmailPassword extends _$SignUpWithEmailPassword {
  @override
  FutureOr<void> build() {
    // Empty initial state
  }

  /// Trigger email/password sign up with optional display name
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.createUserWithEmailPassword(
        email,
        password,
        displayName: displayName,
      );
      await ref.read(categoryRepositoryProvider).seedDefaultCategories();
    });
  }
}


/// Sign out notifier
@riverpod
class SignOut extends _$SignOut {
  @override
  FutureOr<void> build() {
    // Empty initial state
  }

  /// Trigger sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signOut();
    });
  }
}

/// Reset password notifier
@riverpod
class ResetPassword extends _$ResetPassword {
  @override
  FutureOr<void> build() {
    // Empty initial state
  }

  /// Trigger password reset
  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.resetPassword(email);
    });
  }
}
