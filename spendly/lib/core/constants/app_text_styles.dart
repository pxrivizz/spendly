import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography styles for Spendly – Space Grotesk (headings) + Manrope (body)
///
/// Extracted pixel-perfect from Stitch AI Tailwind config.
class AppTextStyles {
  AppTextStyles._();

  // ── Font families ──────────────────────────────────────────────────
  static String get _headingFamily => GoogleFonts.spaceGrotesk().fontFamily!;
  static String get _bodyFamily => GoogleFonts.manrope().fontFamily!;

  // ── Display / Headings – Space Grotesk ─────────────────────────────

  /// h1: 48px / bold / tight tracking
  static TextStyle get h1 => TextStyle(
        fontFamily: _headingFamily,
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.96, // -0.02em
        color: AppColors.onSurface,
      );

  /// h2: 32px / semibold
  static TextStyle get h2 => TextStyle(
        fontFamily: _headingFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.32, // -0.01em
        color: AppColors.onSurface,
      );

  /// h3: 24px / semibold
  static TextStyle get h3 => TextStyle(
        fontFamily: _headingFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.onSurface,
      );

  // ── Body – Manrope ─────────────────────────────────────────────────

  /// bodyLg: 18px / regular
  static TextStyle get bodyLg => TextStyle(
        fontFamily: _bodyFamily,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurface,
      );

  /// bodyMd: 16px / regular (default body)
  static TextStyle get bodyMd => TextStyle(
        fontFamily: _bodyFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurface,
      );

  /// bodySm: 14px / medium
  static TextStyle get bodySm => TextStyle(
        fontFamily: _bodyFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.onSurface,
      );

  /// labelCaps: 12px / bold / uppercase tracking
  static TextStyle get labelCaps => TextStyle(
        fontFamily: _bodyFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0.96, // 0.08em
        color: AppColors.onSurfaceVariant,
      );

  // ── Convenience aliases matching Material naming ───────────────────

  static TextStyle get displayLarge => h1;
  static TextStyle get displayMedium => h2;
  static TextStyle get displaySmall => h3;
  static TextStyle get bodyLarge => bodyLg;
  static TextStyle get bodyMedium => bodyMd;
  static TextStyle get bodySmall => bodySm;
  static TextStyle get labelLarge => bodySm.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get labelMedium => labelCaps;
  static TextStyle get labelSmall => labelCaps.copyWith(fontSize: 10);
}
