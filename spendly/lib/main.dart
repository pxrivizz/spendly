// removed
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/firebase/firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/providers/firebase_providers.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SpendlyApp(),
    ),
  );
}

class SpendlyApp extends ConsumerWidget {
  const SpendlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // READ not WATCH — router is built once, never rebuilt
    final router = ref.read(routerProvider);

    return MaterialApp.router(
      title: 'Spendly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
