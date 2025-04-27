import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/features/cash_flow/cash_flow_page.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// View shown when the quiz is completed
class QuizCompletedView extends StatelessWidget {
  final VoidCallback onViewResources;

  const QuizCompletedView({required this.onViewResources, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.celebration,
              size: 80.r,
              color: Theme.of(context).colorScheme.primary,
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

            AppSpacer.height24,

            Text(
              'Quiz Completed!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),

            AppSpacer.height16,

            Text(
              'Great job learning about financial wellness! Ready to apply what you\'ve learned?',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms),

            AppSpacer.height40,

            ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CashFlowPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('Go to Cash Flow Tool'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms)
                .slideY(delay: 600.ms, begin: 0.2, end: 0),

            AppSpacer.height16,

            OutlinedButton.icon(
              onPressed: onViewResources, // Go to resources tab
              icon: const Icon(Icons.book),
              label: const Text('Explore Learning Resources'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
            ).animate().fadeIn(delay: 700.ms),
          ],
        ),
      ),
    );
  }
}
