import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maluk/src/common/theme/app_theme.dart';
import 'package:maluk/src/features/cash_flow/cash_flow_page.dart';
import 'package:maluk/src/features/quiz/quiz_page.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 4.r),
        title: Text(
          'Financial Wellness',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  isDarkMode ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.r, vertical: 24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              AppSpacer.height20,
              // Welcome section
              Text(
                'Welcome to Your Financial Wellness Journey',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

              AppSpacer.height20,

              Text(
                'Track your finances and learn about financial wellness with our tools',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

              AppSpacer.height40,

              // Navigation cards
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cash Flow Card
                    _buildNavigationCard(
                          context,
                          title: 'Monthly Cash Flow',
                          description:
                              'Track your income and expenses over time',
                          icon: Icons.account_balance_wallet,
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CashFlowPage(),
                                ),
                              ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .scale(delay: 400.ms),

                    AppSpacer.height16, // Add spacing between cards
                    // Quiz Card
                    _buildNavigationCard(
                          context,
                          title: 'Financial Wellness Quiz',
                          description:
                              'Test your knowledge about financial wellness',
                          icon: Icons.quiz_outlined,
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const QuizPage(),
                                ),
                              ),
                        )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 600.ms)
                        .scale(delay: 500.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        // radius: 16.r,
        highlightColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        splashColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60.r,
                color: Theme.of(context).colorScheme.primary,
              ),
              AppSpacer.height16,
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              AppSpacer.height8,
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
