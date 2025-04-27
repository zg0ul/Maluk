import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maluk/src/features/quiz/presentation/controllers/quiz_providers.dart';
import 'package:maluk/src/features/quiz/presentation/widgets/achievement_item.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// View for tracking quiz progress and achievements
class ProgressView extends ConsumerWidget {
  final bool hasViewedResources;

  const ProgressView({required this.hasViewedResources, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizStateProvider);
    final quizController = ref.read(quizStateProvider.notifier);

    final currentIndex = quizState.currentIndex;
    final quizCompleted = quizState.isQuizCompleted;

    // Calculate progress percentage
    final progressPercentage = quizCompleted ? 100.0 : (currentIndex / 3) * 100;

    // Get achievements
    final achievements = quizController.getAchievements(
      checkedResources: hasViewedResources,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Learning Progress',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            AppSpacer.height24,

            // Progress card
            Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quiz Progress',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${progressPercentage.toInt()}%',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),

                        AppSpacer.height16,

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: LinearProgressIndicator(
                            value: progressPercentage / 100,
                            minHeight: 12.h,
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                        AppSpacer.height24,

                        // Status
                        Row(
                          children: [
                            Icon(
                              quizCompleted
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color:
                                  quizCompleted ? Colors.green : Colors.orange,
                            ),
                            AppSpacer.width8,
                            Text(
                              quizCompleted
                                  ? 'Quiz Completed'
                                  : 'Quiz in Progress',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color:
                                    quizCompleted
                                        ? Colors.green
                                        : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(
                  delay: 300.ms,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                ),

            AppSpacer.height24,

            // Achievements section
            Text(
              'Achievements',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            AppSpacer.height16,

            // Achievement cards
            ...achievements.map(
              (achievement) => AchievementItem(
                achievement: achievement,
                onTap:
                    achievement.isUnlocked
                        ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Achievement unlocked: ${achievement.title}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                        : null,
              ),
            ),

            // Spacer at the bottom to ensure good padding
            AppSpacer.height16,
          ],
        ),
      ),
    );
  }
}
