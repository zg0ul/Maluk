import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// DialogStyles provides consistent styling for dialogs and form inputs
class DialogStyles {
  DialogStyles._();

  /// Standard input decoration for text fields in dialogs
  static InputDecoration getInputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(width: 1.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(width: 1.r, color: theme.colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(width: 2.r, color: theme.colorScheme.primary),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
      filled: true,
      fillColor: theme.colorScheme.surface,
    );
  }

  /// Style for dialog title text
  static TextStyle getTitleStyle(BuildContext context) => Theme.of(
    context,
  ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold);

  /// Standard dialog shape
  static ShapeBorder get dialogShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r));

  /// Standard dialog padding
  static EdgeInsetsGeometry get dialogPadding =>
      EdgeInsets.symmetric(horizontal: 24.r, vertical: 20.r);

  /// Standard dialog content padding
  static EdgeInsetsGeometry get contentPadding =>
      EdgeInsets.only(top: 12.r, bottom: 16.r);

  /// Standard choice chip options theme
  static ChipThemeData getChipThemeData(BuildContext context) {
    final theme = Theme.of(context);
    return ChipThemeData(
      backgroundColor: theme.colorScheme.surface,
      disabledColor: Colors.grey.shade200,
      selectedColor: theme.colorScheme.primary.withOpacity(0.15),
      secondarySelectedColor: theme.colorScheme.primary,
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      labelStyle: theme.textTheme.bodyMedium!,
      secondaryLabelStyle: theme.textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
    );
  }
}
