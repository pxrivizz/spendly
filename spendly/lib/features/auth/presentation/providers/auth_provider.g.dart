// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'd3ae5e3a1038da1ebf66dc733301302def31bce0';

/// Auth repository provider — kept alive because [authStateProvider]
/// (which is also keepAlive) depends on it.
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$authStateHash() => r'ad94348a12cd626b991e5b559cdb7f53d8c0fd4e';

/// Auth state stream provider — MUST be kept alive so the router redirect
/// can always read the current auth state synchronously. If this were
/// autoDispose, it would be disposed when no widget is watching it (e.g.,
/// during a GoRouter redirect), causing `ref.read()` to return AsyncLoading
/// and the redirect to silently skip.
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateRef = StreamProviderRef<User?>;
String _$currentUserHash() => r'17474ebb3399ec8c7a54682f8c496ea60dd71d6c';

/// Current user notifier provider
///
/// Copied from [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider =
    AutoDisposeAsyncNotifierProvider<CurrentUser, User?>.internal(
  CurrentUser.new,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUser = AutoDisposeAsyncNotifier<User?>;
String _$signInWithGoogleHash() => r'920a9ce7dab03e43064df64298ccf11a48f2e156';

/// Sign in with Google notifier
///
/// Copied from [SignInWithGoogle].
@ProviderFor(SignInWithGoogle)
final signInWithGoogleProvider =
    AutoDisposeAsyncNotifierProvider<SignInWithGoogle, void>.internal(
  SignInWithGoogle.new,
  name: r'signInWithGoogleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInWithGoogleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignInWithGoogle = AutoDisposeAsyncNotifier<void>;
String _$signInWithEmailPasswordHash() =>
    r'38abacdc09b210e4522804c9c26ed3db7e44f31f';

/// Sign in with email and password notifier
///
/// Copied from [SignInWithEmailPassword].
@ProviderFor(SignInWithEmailPassword)
final signInWithEmailPasswordProvider =
    AutoDisposeAsyncNotifierProvider<SignInWithEmailPassword, void>.internal(
  SignInWithEmailPassword.new,
  name: r'signInWithEmailPasswordProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInWithEmailPasswordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignInWithEmailPassword = AutoDisposeAsyncNotifier<void>;
String _$signUpWithEmailPasswordHash() =>
    r'2944f751769652a24fa3e2415a0855cbab912110';

/// Sign up with email and password notifier
///
/// Copied from [SignUpWithEmailPassword].
@ProviderFor(SignUpWithEmailPassword)
final signUpWithEmailPasswordProvider =
    AutoDisposeAsyncNotifierProvider<SignUpWithEmailPassword, void>.internal(
  SignUpWithEmailPassword.new,
  name: r'signUpWithEmailPasswordProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpWithEmailPasswordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignUpWithEmailPassword = AutoDisposeAsyncNotifier<void>;
String _$signOutHash() => r'56e5e0a248313b33d2f94473caafa6151efec93d';

/// Sign out notifier
///
/// Copied from [SignOut].
@ProviderFor(SignOut)
final signOutProvider =
    AutoDisposeAsyncNotifierProvider<SignOut, void>.internal(
  SignOut.new,
  name: r'signOutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signOutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignOut = AutoDisposeAsyncNotifier<void>;
String _$resetPasswordHash() => r'7bbbba12a8f713c41f6843478f443a57629356e9';

/// Reset password notifier
///
/// Copied from [ResetPassword].
@ProviderFor(ResetPassword)
final resetPasswordProvider =
    AutoDisposeAsyncNotifierProvider<ResetPassword, void>.internal(
  ResetPassword.new,
  name: r'resetPasswordProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resetPasswordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ResetPassword = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
