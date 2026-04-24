import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/mesh_gradient_background.dart';
import '../providers/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    debugPrint('[LoginScreen] Attempting sign in for: ${_emailController.text.trim()}');

    await ref.read(loginNotifierProvider.notifier).signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);

    ref.listen<AsyncValue<void>>(loginNotifierProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) {
          String msg = 'Login failed. Please try again.';
          if (error is FirebaseAuthException) {
            msg = switch (error.code) {
              'user-not-found'     => 'No account found with this email.',
              'wrong-password'     => 'Incorrect password.',
              'invalid-credential' => 'Invalid email or password.',
              'invalid-email'      => 'Please enter a valid email.',
              'too-many-requests'  => 'Too many attempts. Try again later.',
              'user-disabled'      => 'This account has been disabled.',
              _                    => 'Login failed. Please try again.',
            };
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: const Color(0xFFFF4C4C),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    });

    final isLoading = loginState.isLoading;

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
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Hoş Geldiniz',
                      style: AppTextStyles.h1,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Hesabınıza giriş yaparak harcamalarınızı yönetmeye devam edin.',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Email
                    _buildLabel('E-POSTA ADRESİ'),
                    const SizedBox(height: AppSpacing.xs),
                    _buildTextFormField(
                      controller: _emailController,
                      hintText: 'ornek@email.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
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
                      obscureText: !_isPasswordVisible,
                      prefixIcon: Icons.lock_outline,
                      textInputAction: TextInputAction.done,
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
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: Text(
                          'Şifremi Unuttum',
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSignIn,
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
                        child: loginState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Giriş Yap',
                                style: AppTextStyles.bodyLg.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                            child:
                                Divider(color: AppColors.outlineVariant)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'VEYA',
                            style: AppTextStyles.labelCaps.copyWith(
                              color: AppColors.outline,
                            ),
                          ),
                        ),
                        Expanded(
                            child:
                                Divider(color: AppColors.outlineVariant)),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Google Sign In removed as per simplified auth flow

                    const SizedBox(height: AppSpacing.xl),

                    // Register link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hesabınız yok mu?',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/sign-up'),
                            child: Text(
                              'Kayıt Ol',
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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
