import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences — overridden in main.dart ProviderScope
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override in ProviderScope'),
);

// Firebase instances
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

// Auth state stream — single source of truth
// AsyncLoading = still initializing
// AsyncData(null) = logged out
// AsyncData(User) = logged in
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

// Current user ID — null-safe, never throws
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.uid;
});

// Onboarding completion flag
final onboardingCompletedProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('onboarding_completed') ?? false;
});

// Selected month for filtering (shared across screens)
final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime(DateTime.now().year, DateTime.now().month),
);
