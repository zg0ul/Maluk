import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/common/theme/style_constants.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<String> tabs;
  final double tabHeight;
  final EdgeInsetsGeometry? padding;

  const CustomTabBar({
    required this.controller,
    required this.tabs,
    this.tabHeight = 50.0,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabBar(
      controller: controller,
      tabs: tabs.map((tab) => Tab(text: tab, height: tabHeight.h)).toList(),
      indicatorColor: theme.colorScheme.primary,
      labelColor: theme.colorScheme.primary,
      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: theme.textTheme.bodyMedium,
      labelPadding: EdgeInsets.symmetric(horizontal: 4.r),
      dividerHeight: 1,
      dividerColor: theme.colorScheme.outline.withValues(alpha: 0.2),
      overlayColor: StyleConstants.inkOverlayColor,
      splashFactory: StyleConstants.splashFactory,
      indicatorSize: TabBarIndicatorSize.tab,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.r),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(tabHeight.h);
}
