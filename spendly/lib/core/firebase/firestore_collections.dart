/// Firestore collection names and paths
class FirestoreCollections {
  FirestoreCollections._();

  /// Users collection - stores user profiles and settings
  static const String users = 'users';

  /// Transactions collection - stores all financial transactions
  static const String transactions = 'transactions';

  /// Budgets collection - stores budget configurations
  static const String budgets = 'budgets';

  /// Categories collection - stores transaction categories
  static const String categories = 'categories';

  /// Helper method to get user transactions subcollection path
  static String userTransactions(String userId) => 'users/$userId/transactions';

  /// Helper method to get user budgets subcollection path
  static String userBudgets(String userId) => 'users/$userId/budgets';

  /// Helper method to get user categories subcollection path
  static String userCategories(String userId) => 'users/$userId/categories';
}
