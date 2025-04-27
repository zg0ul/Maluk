import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/common/widgets/styled_ink_well.dart';

/// A widget that displays a financial resource item
class ResourceItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final int index;

  const ResourceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.index,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      clipBehavior: Clip.antiAlias,
      child: StyledInkWell(
        onTap: onTap,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.r),
          leading: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          title: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(description),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16.r),
        ),
      ),
    ).animate().fadeIn(
      duration: 400.ms,
      delay: Duration(milliseconds: 100 * index),
    );
  }
}
