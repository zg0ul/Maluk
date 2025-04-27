import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maluk/src/features/quiz/presentation/controllers/quiz_providers.dart';
import 'package:maluk/src/utilities/app_spacer.dart';
import 'package:maluk/src/common/widgets/styled_ink_well.dart';

/// Quiz view that displays the current question and answers
class QuizView extends ConsumerWidget {
  final VoidCallback onViewResources;

  const QuizView({required this.onViewResources, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizStateProvider);
    final quizController = ref.read(quizStateProvider.notifier);
    final currentQuestion = quizController.currentQuestion;

    final isAnswered = quizState.isAnswered;
    final selectedAnswerIndex = quizState.selectedAnswer;
    final currentIndex = quizState.currentIndex;
    final options = currentQuestion.options;
    final correctAnswerIndex = currentQuestion.correctAnswerIndex;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentIndex + 1) / 3,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            AppSpacer.height24,

            // Question text
            Text(
              'Question ${currentIndex + 1}/3',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(duration: 300.ms),

            AppSpacer.height12,

            // Question
            Text(
                  currentQuestion.question,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .slide(begin: const Offset(0.1, 0), end: Offset.zero),

            AppSpacer.height32,

            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final optionLetter = String.fromCharCode(
                    65 + index,
                  ); // A, B, C...
                  final isSelected = selectedAnswerIndex == index;
                  final isCorrect = index == correctAnswerIndex;

                  // Determine the card color based on selection and correctness
                  Color? cardColor;
                  if (isAnswered) {
                    if (isSelected) {
                      cardColor =
                          isCorrect
                              ? Colors.green.withOpacity(0.2)
                              : Theme.of(
                                context,
                              ).colorScheme.error.withOpacity(0.2);
                    } else if (isCorrect) {
                      cardColor = Colors.green.withOpacity(0.1);
                    }
                  } else if (isSelected) {
                    cardColor = Theme.of(context).colorScheme.primaryContainer;
                  }

                  return _buildAnswerOption(
                    context,
                    index: index,
                    optionLetter: optionLetter,
                    optionText: options[index],
                    isSelected: isSelected,
                    isAnswered: isAnswered,
                    isCorrect: isCorrect,
                    cardColor: cardColor,
                    onTap:
                        isAnswered
                            ? null
                            : () => quizController.selectAnswer(index),
                  );
                },
              ),
            ),

            // Answer explanation when answered
            if (isAnswered) ...[
              _buildExplanationCard(
                context,
                explanation: currentQuestion.explanation,
              ),
              AppSpacer.height16,
              _buildNavigationButtons(context, ref),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOption(
    BuildContext context, {
    required int index,
    required String optionLetter,
    required String optionText,
    required bool isSelected,
    required bool isAnswered,
    required bool isCorrect,
    required Color? cardColor,
    required VoidCallback? onTap,
  }) {
    return StyledInkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Card(
        color: cardColor,
        elevation: isSelected ? 3 : 1,
        margin: EdgeInsets.only(bottom: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                ),
                child: Center(
                  child: Text(
                    optionLetter,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AppSpacer.width16,
              Expanded(
                child: Text(
                  optionText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
              if (isAnswered) ...[
                AppSpacer.width8,
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : null,
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: 400.ms,
      delay: Duration(milliseconds: 100 * index),
    );
  }

  Widget _buildExplanationCard(
    BuildContext context, {
    required String explanation,
  }) {
    return Card(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explanation:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacer.height8,
                Text(explanation),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms)
        .slide(delay: 300.ms, begin: const Offset(0, 0.2), end: Offset.zero);
  }

  Widget _buildNavigationButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: onViewResources, // Go to resources tab
          icon: const Icon(Icons.book),
          label: const Text('Learn More'),
        ),
        ElevatedButton.icon(
          onPressed: () => ref.read(quizStateProvider.notifier).nextQuestion(),
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Next'),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }
}
