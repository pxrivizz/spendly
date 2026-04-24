// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Spendly';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get analytics => 'Analytics';

  @override
  String get budget => 'Budget';

  @override
  String get transactions => 'Transactions';

  @override
  String get profile => 'Profile';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get emailSent => 'Email Sent!';

  @override
  String get resend => 'Resend';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get balance => 'Balance';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get errorGeneric => 'An unexpected error occurred. Please try again.';

  @override
  String get errorNoAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';
}
