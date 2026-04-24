// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Spendly';

  @override
  String get dashboard => 'Ana Sayfa';

  @override
  String get analytics => 'Analitik';

  @override
  String get budget => 'Bütçe';

  @override
  String get transactions => 'İşlemler';

  @override
  String get profile => 'Profil';

  @override
  String get addTransaction => 'İşlem Ekle';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get email => 'E-posta Adresi';

  @override
  String get password => 'Şifre';

  @override
  String get confirmPassword => 'Şifre Tekrar';

  @override
  String get fullName => 'Ad Soyad';

  @override
  String get forgotPassword => 'Şifremi Unuttum';

  @override
  String get sendResetLink => 'Sıfırlama Bağlantısı Gönder';

  @override
  String get emailSent => 'E-posta Gönderildi!';

  @override
  String get resend => 'Tekrar Gönder';

  @override
  String get backToLogin => 'Giriş Ekranına Dön';

  @override
  String get income => 'Gelir';

  @override
  String get expense => 'Gider';

  @override
  String get balance => 'Bakiye';

  @override
  String get totalIncome => 'Toplam Gelir';

  @override
  String get totalExpense => 'Toplam Gider';

  @override
  String get errorGeneric => 'Beklenmedik bir hata oluştu. Tekrar deneyin.';

  @override
  String get errorNoAccount => 'Hesabınız yok mu?';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı?';
}
