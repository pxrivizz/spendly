import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Material 3 dark theme for Spendly – Luminous Ledger design system
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A0E1A),
      primaryColor: AppColors.primary,

      // ── Color scheme ─────────────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
      ),

      // ── Typography ───────────────────────────────────────────────
      textTheme: textTheme,

      // ── System UI overlay ────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      // ── Card ─────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.glassFill,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
      ),

      // ── Elevated Button ──────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.bodyLg.copyWith(
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),

      // ── Outlined Button ──────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.bodyMd,
        ),
      ),

      // ── Text Button ──────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // ── Input Decoration ─────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
        hintStyle: AppTextStyles.bodyMd.copyWith(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        labelStyle: AppTextStyles.labelCaps,
      ),

      // ── Divider ──────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.05),
        thickness: 1,
        space: 0,
      ),

      // ── Bottom Sheet ─────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
    );
  }

  /// Build the text theme using Google Fonts
  static TextTheme _buildTextTheme() {
    return GoogleFonts.manropeTextTheme(
      const TextTheme(
        displayLarge: TextStyle(color: AppColors.onSurface),
        displayMedium: TextStyle(color: AppColors.onSurface),
        displaySmall: TextStyle(color: AppColors.onSurface),
        headlineLarge: TextStyle(color: AppColors.onSurface),
        headlineMedium: TextStyle(color: AppColors.onSurface),
        headlineSmall: TextStyle(color: AppColors.onSurface),
        titleLarge: TextStyle(color: AppColors.onSurface),
        titleMedium: TextStyle(color: AppColors.onSurface),
        titleSmall: TextStyle(color: AppColors.onSurface),
        bodyLarge: TextStyle(color: AppColors.onSurface),
        bodyMedium: TextStyle(color: AppColors.onSurface),
        bodySmall: TextStyle(color: AppColors.onSurfaceVariant),
        labelLarge: TextStyle(color: AppColors.onSurface),
        labelMedium: TextStyle(color: AppColors.onSurfaceVariant),
        labelSmall: TextStyle(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}
