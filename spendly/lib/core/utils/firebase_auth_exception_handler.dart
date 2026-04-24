import 'package:firebase_auth/firebase_auth.dart';

/// Maps [FirebaseAuthException] error codes to user-friendly Turkish messages.
class FirebaseAuthExceptionHandler {
  FirebaseAuthExceptionHandler._();

  /// Returns a user-friendly error message for the given [FirebaseAuthException].
  static String getMessage(FirebaseAuthException e) {
    switch (e.code) {
      // ── Sign Up ──────────────────────────────────────────────────
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanılıyor. Giriş yapmayı deneyin.';
      case 'weak-password':
        return 'Şifre çok zayıf. En az 8 karakter kullanın.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi. Lütfen kontrol edin.';
      case 'operation-not-allowed':
        return 'Bu giriş yöntemi şu anda devre dışı.';

      // ── Sign In ──────────────────────────────────────────────────
      case 'user-not-found':
        return 'Bu e-posta ile kayıtlı bir hesap bulunamadı.';
      case 'wrong-password':
        return 'Şifre hatalı. Lütfen tekrar deneyin.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmıştır.';
      case 'too-many-requests':
        return 'Çok fazla deneme yaptınız. Lütfen daha sonra tekrar deneyin.';

      // ── Password Reset ───────────────────────────────────────────
      case 'expired-action-code':
        return 'Şifre sıfırlama bağlantısının süresi dolmuş.';
      case 'invalid-action-code':
        return 'Şifre sıfırlama bağlantısı geçersiz.';

      // ── Network / Generic ────────────────────────────────────────
      case 'network-request-failed':
        return 'Ağ bağlantı hatası. İnternet bağlantınızı kontrol edin.';
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';

      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin. (${e.code})';
    }
  }
}
