/// Spendly spacing constants – Extracted from Stitch AI design tokens
class AppSpacing {
  AppSpacing._();

  // ── Core spacing scale (matches Stitch Tailwind tokens) ────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 48.0;

  /// Base unit for micro adjustments
  static const double unit = 4.0;

  /// Gutter between columns
  static const double gutter = 16.0;

  /// Horizontal padding for screen content
  static const double containerMargin = 24.0;

  // ── Border radii ───────────────────────────────────────────────────
  /// Default corner radius
  static const double radiusDefault = 4.0;

  /// Small radius (chips, tags)
  static const double radiusSm = 8.0;

  /// Medium radius (inputs, buttons)
  static const double radiusMd = 12.0;

  /// Large radius (cards, sheets)
  static const double radiusLg = 24.0;

  /// Extra large radius (bottom sheet top corners)
  static const double radiusXl = 32.0;

  /// Full round (pills, avatars, dots)
  static const double radiusFull = 9999.0;

  // ── Component-specific ─────────────────────────────────────────────

  /// Bottom navigation bar height (including safe area)
  static const double bottomNavHeight = 80.0;

  /// Bottom nav top corner radius
  static const double bottomNavRadius = 24.0;

  /// FAB size
  static const double fabSize = 56.0;

  /// Avatar sizes
  static const double avatarSm = 40.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 80.0;

  /// Icon container sizes
  static const double iconContainerSm = 32.0;
  static const double iconContainerMd = 40.0;
  static const double iconContainerLg = 48.0;

  /// Button height
  static const double buttonHeight = 56.0;
}
