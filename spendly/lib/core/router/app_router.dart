import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'go_router_refresh_stream.dart';
import '../providers/firebase_providers.dart';

// Screen imports
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import 'app_shell.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);

  final router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),

    // !! redirect must be synchronous - NO async !!
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final user = FirebaseAuth.instance.currentUser;
      final onboardingDone = prefs.getBool('onboarding_completed') ?? false;

      debugPrint(
        '[Router] loc=$loc  uid=${user?.uid}  onboarding=$onboardingDone',
      );

      // Always allow splash to render (it's just a loading screen)
      if (loc == '/splash') {
        if (!onboardingDone) return '/onboarding';
        if (user == null) return '/login';
        return '/';
      }

      // Onboarding not done → force onboarding
      if (!onboardingDone) {
        return loc == '/onboarding' ? null : '/onboarding';
      }

      // Auth screens
      const authRoutes = ['/login', '/sign-up', '/forgot-password'];
      final isAuthRoute = authRoutes.contains(loc);

      // Not logged in
      if (user == null) {
        return isAuthRoute ? null : '/login';
      }

      // Logged in → redirect away from auth/onboarding screens
      if (isAuthRoute || loc == '/onboarding') return '/';

      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/transactions',
            name: 'transactions',
            builder: (context, state) => const TransactionsScreen(),
          ),
          GoRoute(
            path: '/budget',
            name: 'budget',
            builder: (context, state) => const BudgetScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/add-transaction',
        builder: (context, state) => const AddTransactionScreen(),
      ),
      GoRoute(
        path: '/transaction/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Scaffold(body: Center(child: Text('Transaction Detail: $id')));
        },
      ),
    ],
  );

  return router;
});
