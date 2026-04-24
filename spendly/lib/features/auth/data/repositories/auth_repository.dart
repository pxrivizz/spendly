import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication repository
/// Handles Firebase authentication operations
class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) {
      return;
    }
    await _googleSignIn.initialize();
    _googleSignInInitialized = true;
  }

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Stream of the user document from Firestore
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDocumentStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  /// Sign in with Google
  /// Returns the User if successful, throws exception on failure
  Future<User?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final GoogleSignInClientAuthorization? googleAuthorization =
          await googleUser.authorizationClient
              .authorizationForScopes(<String>['email', 'profile']);

      if (googleAuth.idToken == null && googleAuthorization?.accessToken == null) {
        throw Exception('Google sign in token fetch failed');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuthorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Create Firestore user document for first-time Google sign-ins
      final user = userCredential.user;
      if (user != null && userCredential.additionalUserInfo?.isNewUser == true) {
        await _createUserDocument(user);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  /// Returns the User if successful, throws exception on failure
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      debugPrint('[AuthRepository] Calling signInWithEmailAndPassword for $email');
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('[AuthRepository] Sign in successful for ${userCredential.user?.uid}');
      return userCredential.user;
    } catch (e) {
      debugPrint('[AuthRepository] Sign in failed: $e');
      rethrow;
    }
  }

  /// Create account with email and password
  /// Returns the User if successful, throws exception on failure.
  /// Also creates a user document in Firestore.
  Future<User?> createUserWithEmailPassword(
    String email,
    String password, {
    String? displayName,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Set display name on the Firebase Auth profile
        if (displayName != null && displayName.isNotEmpty) {
          await user.updateDisplayName(displayName);
        }

        // Create the Firestore user document
        await _createUserDocument(user, displayName: displayName);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a user document in the 'users' collection.
  Future<void> _createUserDocument(User user, {String? displayName}) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': displayName ?? user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }


  /// Sign out from all providers
  Future<void> signOut() async {
    try {
      await _ensureGoogleSignInInitialized();
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password for email
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
      }
    } catch (e) {
      rethrow;
    }
  }
}
