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

/// Forgot Password screen – sends a password reset email.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(resetPasswordProvider.notifier)
        .resetPassword(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetPasswordProvider);

    // Listen for error / success
    ref.listen(resetPasswordProvider, (prev, next) {
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
          if (prev?.isLoading == true) {
            setState(() => _emailSent = true);
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

                    const SizedBox(height: AppSpacing.xl),

                    // Icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(
                        _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Header
                    Text(
                      _emailSent ? 'E-posta Gönderildi!' : 'Şifremi Unuttum',
                      style: AppTextStyles.h2,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _emailSent
                          ? '${_emailController.text.trim()} adresine şifre sıfırlama bağlantısı gönderdik. Gelen kutunuzu kontrol edin.'
                          : 'Endişelenmeyin! E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    if (!_emailSent) ...[
                      // Email
                      _buildLabel('E-POSTA ADRESİ'),
                      const SizedBox(height: AppSpacing.xs),
                      _buildTextFormField(
                        controller: _emailController,
                        hintText: 'ornek@email.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
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

                      const SizedBox(height: AppSpacing.xl),

                      // Send button
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.buttonHeight,
                        child: ElevatedButton(
                          onPressed: resetState.isLoading
                              ? null
                              : _handleResetPassword,
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
                          child: resetState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Sıfırlama Bağlantısı Gönder',
                                  style: AppTextStyles.bodyLg.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                        ),
                      ),
                    ] else ...[
                      // Success state – show resend and back buttons
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.buttonHeight,
                        child: ElevatedButton(
                          onPressed: resetState.isLoading
                              ? null
                              : () {
                                  setState(() => _emailSent = false);
                                  _handleResetPassword();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                          ),
                          child: resetState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Tekrar Gönder',
                                  style: AppTextStyles.bodyLg.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.buttonHeight,
                        child: OutlinedButton(
                          onPressed: () => context.go('/login'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.outlineVariant),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                          ),
                          child: Text(
                            'Giriş Ekranına Dön',
                            style: AppTextStyles.bodyLg.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.xl),

                    // Back to login link
                    if (!_emailSent)
                      Center(
                        child: TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            '← Giriş ekranına dön',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
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
