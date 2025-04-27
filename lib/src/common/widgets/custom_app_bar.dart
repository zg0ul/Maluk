import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/common/theme/style_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomAppBar({
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottom,
    this.toolbarHeight,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 8.r),
      leading:
          showBackButton
              ? leading ??
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                    iconSize: 24.r,
                    style: IconButton.styleFrom(
                      foregroundColor:
                          foregroundColor ?? theme.colorScheme.onSurface,
                      highlightColor: StyleConstants.highlightColor,
                      splashFactory: StyleConstants.splashFactory,
                    ),
                  )
              : null,
      actions: actions,
      bottom: bottom,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
  );
}
