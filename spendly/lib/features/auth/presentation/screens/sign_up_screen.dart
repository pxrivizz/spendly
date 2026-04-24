import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/firebase_auth_exception_handler.dart';
import '../../../../core/utils/snackbar_helpers.dart';
import '../../../../core/widgets/mesh_gradient_background.dart';
import '../providers/auth_provider.dart';

/// Sign Up screen with full form validation and Firebase integration.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validates the form and triggers sign up via Riverpod provider.
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(signUpWithEmailPasswordProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpWithEmailPasswordProvider);

    // Listen for errors and success
    ref.listen(signUpWithEmailPasswordProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          if (error is FirebaseAuthException) {
            showErrorSnackBar(
              context,
              FirebaseAuthExceptionHandler.getMessage(error),
            );
          } else {
            showErrorSnackBar(context, 'Bir hata oluştu. Tekrar deneyin.');
          }
        },
        data: (_) {
          // If previous was loading, sign up succeeded → router will redirect
          if (prev?.isLoading == true) {
            showSuccessSnackBar(context, 'Hesabınız başarıyla oluşturuldu!');
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const MeshGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerMargin,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),

                    // Back button
                    _buildBackButton(context),

                    const SizedBox(height: AppSpacing.lg),

                    // Header
                    Text('Hesap Oluştur', style: AppTextStyles.h1),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Harcamalarınızı takip etmeye hemen başlayın.',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Full Name
                    _buildLabel('AD SOYAD'),
                    const SizedBox(height: AppSpacing.xs),
                    _buildTextFormField(
                      controller: _nameController,
                      hintText: 'Adınız Soyadınız',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ad Soyad boş bırakılamaz.';
                        }
                        if (value.trim().length < 2) {
                          return 'Ad Soyad en az 2 karakter olmalıdır.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Email
                    _buildLabel('E-POSTA ADRESİ'),
                    const SizedBox(height: AppSpacing.xs),
                    _buildTextFormField(
                      controller: _emailController,
                      hintText: 'ornek@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'E-posta adresi boş bırakılamaz.';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Geçerli bir e-posta adresi girin.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Password
                    _buildLabel('ŞİFRE'),
                    const SizedBox(height: AppSpacing.xs),
                    _buildTextFormField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_isPasswordVisible,
                      textInputAction: TextInputAction.next,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifre boş bırakılamaz.';
                        }
                        if (value.length < 8) {
                          return 'Şifre en az 8 karakter olmalıdır.';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Şifre en az bir büyük harf içermelidir.';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Şifre en az bir rakam içermelidir.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Confirm Password
                    _buildLabel('ŞİFRE TEKRAR'),
                    const SizedBox(height: AppSpacing.xs),
                    _buildTextFormField(
                      controller: _confirmPasswordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_isConfirmPasswordVisible,
                      textInputAction: TextInputAction.done,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: () => setState(() =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifre tekrarı boş bırakılamaz.';
                        }
                        if (value != _passwordController.text) {
                          return 'Şifreler eşleşmiyor.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: ElevatedButton(
                        onPressed: signUpState.isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                        child: signUpState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Kayıt Ol',
                                style: AppTextStyles.bodyLg.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Zaten hesabınız var mı?',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/login'),
                            child: Text(
                              'Giriş Yap',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Reusable builders ──────────────────────────────────────────────

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceContainerHigh,
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: AppColors.onSurface,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelCaps.copyWith(
        fontSize: 11,
        letterSpacing: 1.5,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: AppTextStyles.bodyMd,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
        prefixIcon: Icon(prefixIcon, color: AppColors.onSurfaceVariant),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: AppTextStyles.bodySm.copyWith(
          color: AppColors.error,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
