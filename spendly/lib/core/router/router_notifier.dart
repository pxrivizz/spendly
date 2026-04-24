import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Onboarding Completion State ──────────────────────────────────────────────

/// Reads the onboarding completion flag from SharedPreferences.
/// Used by the router redirect to decide whether to show onboarding.
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_completed') ?? false;
});

/// Writes the onboarding completion flag to SharedPreferences.
/// Call this when the user taps "Get Started" on the last onboarding slide.
Future<void> setOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboarding_completed', true);
}

/// Clears the onboarding flag — useful during development/testing.
/// TODO: Remove calls to this before releasing to production.
Future<void> resetOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('onboarding_completed');
}
