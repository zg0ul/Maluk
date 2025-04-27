import 'package:flutter/material.dart';

/// StyleConstants class providing reusable style elements across the app
class StyleConstants {
  /// Standard splash factory for consistent tap effects across the app
  static final InteractiveInkFeatureFactory splashFactory =
      InkRipple.splashFactory;

  /// Standard highlight color for tap effects (transparent for cleaner look)
  static const Color highlightColor = Colors.transparent;

  /// Standard splash color with opacity for tap effects
  static Color getSplashColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

  /// Standard card border radius
  static final BorderRadius cardBorderRadius = BorderRadius.circular(12);

  /// Apply consistent ink effect properties to any Material widget
  static WidgetStateProperty<Color?> get inkOverlayColor =>
      WidgetStateProperty.all(Colors.transparent);

  /// Button padding (vertical)
  static EdgeInsetsGeometry get buttonPadding =>
      const EdgeInsets.symmetric(vertical: 16);
}
