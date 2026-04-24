import 'package:flutter/material.dart';

/// Spendly M3 Color Palette – Extracted from Stitch AI design system
///
/// Dark theme with electric teal primary, warm amber secondary,
/// and a deep forest-dark neutral palette.
class AppColors {
  AppColors._();

  // ── Background & Surface ───────────────────────────────────────────
  /// Deep dark base canvas
  static const Color background = Color(0xFF0A0E1A);

  /// Main surface color
  static const Color surface = Color(0xFF161D2A);

  /// Dim surface variant
  static const Color surfaceDim = Color(0xFF0A0E1A);

  /// Bright surface variant
  static const Color surfaceBright = Color(0xFF333B37);

  /// Surface variant for borders, alt backgrounds
  static const Color surfaceVariant = Color(0xFF2F3633);

  // ── Surface Containers (elevation hierarchy) ───────────────────────
  static const Color surfaceContainerLowest = Color(0xFF08100D);
  static const Color surfaceContainerLow = Color(0xFF161D1A);
  static const Color surfaceContainer = Color(0xFF19211E);
  static const Color surfaceContainerHigh = Color(0xFF242C28);
  static const Color surfaceContainerHighest = Color(0xFF2F3633);

  // ── Primary ────────────────────────────────────────────────────────
  /// Electric teal – primary accent
  static const Color primary = Color(0xFF46F1C5);

  /// Primary container – slightly deeper teal
  static const Color primaryContainer = Color(0xFF00D4AA);

  /// Primary fixed dim – surface tint
  static const Color primaryFixedDim = Color(0xFF28DFB5);

  /// Primary fixed – brightest primary variant
  static const Color primaryFixed = Color(0xFF55FCD0);

  /// Text on primary surfaces
  static const Color onPrimary = Color(0xFF00382B);

  /// Text on primary container
  static const Color onPrimaryContainer = Color(0xFF005643);

  // ── Secondary (Warm Amber) ─────────────────────────────────────────
  /// Warm amber accent
  static const Color secondary = Color(0xFFFFB95A);

  /// Secondary container
  static const Color secondaryContainer = Color(0xFFC68315);

  /// Text on secondary
  static const Color onSecondary = Color(0xFF462A00);

  // ── Tertiary (Peach/Orange) ────────────────────────────────────────
  /// Peach tertiary
  static const Color tertiary = Color(0xFFFFCEA6);

  /// Tertiary container
  static const Color tertiaryContainer = Color(0xFFFFA858);

  /// Tertiary fixed dim
  static const Color tertiaryFixedDim = Color(0xFFFFB77A);

  /// Text on tertiary
  static const Color onTertiary = Color(0xFF4C2700);

  // ── Error ──────────────────────────────────────────────────────────
  /// Soft error red
  static const Color error = Color(0xFFFFB4AB);

  /// Error container
  static const Color errorContainer = Color(0xFF93000A);

  /// Text on error
  static const Color onError = Color(0xFF690005);

  /// Text on error container
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // ── Text / On-surface ──────────────────────────────────────────────
  /// Primary text on dark surfaces
  static const Color onSurface = Color(0xFFDCE4DF);

  /// Secondary text on dark surfaces
  static const Color onSurfaceVariant = Color(0xFFBACAC2);

  /// On background text
  static const Color onBackground = Color(0xFFDCE4DF);

  // ── Outline & Borders ──────────────────────────────────────────────
  /// Mid-tone outline (hints, placeholders)
  static const Color outline = Color(0xFF85948D);

  /// Subtle borders, dividers
  static const Color outlineVariant = Color(0xFF3B4A44);

  // ── Inverse ────────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFFDCE4DF);
  static const Color inverseOnSurface = Color(0xFF2A322F);
  static const Color inversePrimary = Color(0xFF006B55);

  // ── Glassmorphism helpers ──────────────────────────────────────────
  /// Glass card fill
  static const Color glassFill = Color(0x0AFFFFFF); // white @ 4%

  /// Glass highlight fill on hover
  static const Color glassHoverFill = Color(0x0FFFFFFF); // white @ 6%

  /// Primary border glow (top)
  static Color primaryBorderGlow = const Color(
    0xFF00D4AA,
  ).withValues(alpha: 0.3);

  /// Subtle white border (sides)
  static Color glassBorderSide = Colors.white.withValues(alpha: 0.1);

  /// Very subtle bottom border
  static Color glassBorderBottom = Colors.white.withValues(alpha: 0.05);

  // ── Nav bar specific ───────────────────────────────────────────────
  /// Bottom nav / top bar frosted dark
  static const Color navBarBackground = Color(0xCC161D2A); // surface @ 80%

  /// Inactive nav item
  static const Color navInactive = Color(0xFF64748B); // slate-500
}
