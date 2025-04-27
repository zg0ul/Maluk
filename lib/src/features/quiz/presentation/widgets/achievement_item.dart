import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/features/quiz/domain/quiz_models.dart';
import 'package:maluk/src/common/widgets/styled_ink_well.dart';

/// A widget that displays an achievement item
class AchievementItem extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;

  const AchievementItem({required this.achievement, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color:
          achievement.isUnlocked
              ? null
              : Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      clipBehavior: Clip.antiAlias,
      child: StyledInkWell(
        onTap: achievement.isUnlocked ? onTap : null,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.r),
          leading: CircleAvatar(
            backgroundColor:
                achievement.isUnlocked
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              achievement.icon,
              color:
                  achievement.isUnlocked
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
          title: Text(
            achievement.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color:
                  achievement.isUnlocked
                      ? null
                      : Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              achievement.description,
              style: TextStyle(
                color:
                    achievement.isUnlocked
                        ? null
                        : Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ),
          trailing: Icon(
            achievement.isUnlocked ? Icons.emoji_events : Icons.lock,
            color: achievement.isUnlocked ? Colors.amber : null,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
