import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maluk/src/providers/quiz_providers.dart';
import 'package:maluk/src/utilities/app_spacer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maluk/src/pages/cash_flow_page.dart';
import 'package:maluk/src/widgets/custom_app_bar.dart';
import 'package:maluk/src/widgets/custom_tab_bar.dart';
import 'package:maluk/src/widgets/styled_ink_well.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _tabs = ['Quiz', 'Resources', 'Your Progress'];

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Rebuild when tab changes
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizStateProvider);
    final quizCompleted = quizState['quizCompleted'] as bool;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Financial Wellness Quiz',
        actions: [
          // Quiz reset button
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(quizStateProvider.notifier).resetQuiz();
              _tabController.animateTo(0); // Return to quiz tab
            },
            iconSize: 24.r,
            tooltip: 'Restart Quiz',
          ),
        ],
        bottom: CustomTabBar(controller: _tabController, tabs: _tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Quiz Content
          quizCompleted
              ? _buildQuizCompletedView(context)
              : _buildQuizView(context, ref),

          // Tab 2: Financial Resources
          _buildResourcesTab(context),

          // Tab 3: Quiz Progress
          _buildProgressTab(context, ref),
        ],
      ),
    );
  }

  Widget _buildQuizView(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizStateProvider);
    final quizController = ref.read(quizStateProvider.notifier);
    final isAnswered = quizState['isAnswered'] as bool;
    final selectedAnswerIndex = quizState['selectedAnswer'] as int;
    final currentIndex = quizState['currentIndex'] as int;

    final currentQuestion = quizController.currentQuestion;
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

                  return StyledInkWell(
                    onTap:
                        isAnswered
                            ? null
                            : () => quizController.selectAnswer(index),
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
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                            : Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            AppSpacer.width16,
                            Expanded(
                              child: Text(
                                options[index],
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      isSelected ? FontWeight.bold : null,
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
                },
              ),
            ),

            // Answer explanation when answered
            if (isAnswered) ...[
              Card(
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          AppSpacer.height8,
                          Text(currentQuestion.explanation),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slide(
                    delay: 300.ms,
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ),

              AppSpacer.height16,

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed:
                        () =>
                            _tabController.animateTo(1), // Go to resources tab
                    icon: const Icon(Icons.book),
                    label: const Text('Learn More'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => quizController.nextQuestion(),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCompletedView(BuildContext context) {
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
              onPressed:
                  () => _tabController.animateTo(1), // Go to resources tab
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

  // Resources tab - Financial wellness resources and information
  Widget _buildResourcesTab(BuildContext context) {
    final resourceCards = [
      {
        'title': 'Budgeting Basics',
        'description':
            'Learn how to create and maintain a budget that works for your lifestyle.',
        'icon': Icons.account_balance_wallet,
      },
      {
        'title': 'Emergency Funds',
        'description': 'Why you need an emergency fund and how to build one.',
        'icon': Icons.health_and_safety,
      },
      {
        'title': 'Debt Management',
        'description': 'Strategies to handle and reduce debt effectively.',
        'icon': Icons.trending_down,
      },
      {
        'title': 'Investment Basics',
        'description': 'Introduction to investing and growing your wealth.',
        'icon': Icons.trending_up,
      },
      {
        'title': 'Retirement Planning',
        'description': 'How to prepare for a financially secure retirement.',
        'icon': Icons.beach_access,
      },
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Wellness Resources',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            AppSpacer.height8,

            Text(
              'Explore these resources to enhance your financial knowledge',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            AppSpacer.height24,

            Expanded(
              child: ListView.builder(
                itemCount: resourceCards.length,
                itemBuilder: (context, index) {
                  final resource = resourceCards[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: StyledInkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${resource['title']} resources coming soon!',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.r),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            resource['icon'] as IconData,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          resource['title'] as String,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(resource['description'] as String),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16.r),
                      ),
                    ),
                  ).animate().fadeIn(
                    duration: 400.ms,
                    delay: Duration(milliseconds: 100 * index),
                  );
                },
              ),
            ),

            // Additional information link
            Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    AppSpacer.width16,
                    Expanded(
                      child: Text(
                        'Want to learn more about financial wellness? Take our full assessment to get personalized advice.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Progress tab - Track quiz progress and achievements
  Widget _buildProgressTab(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizStateProvider);
    final currentIndex = quizState['currentIndex'] as int;
    final quizCompleted = quizState['quizCompleted'] as bool;

    // Calculate progress percentage
    final progressPercentage = quizCompleted ? 100.0 : (currentIndex / 3) * 100;

    return SafeArea(
      child: Padding(
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
            Expanded(
              child: ListView(
                children: [
                  _buildAchievementCard(
                    context: context,
                    title: 'Quiz Starter',
                    description: 'Started the financial wellness quiz',
                    icon: Icons.play_circle,
                    isUnlocked: true,
                  ),

                  _buildAchievementCard(
                    context: context,
                    title: 'Knowledge Seeker',
                    description:
                        'Answered all three financial wellness questions',
                    icon: Icons.school,
                    isUnlocked: quizCompleted,
                  ),

                  _buildAchievementCard(
                    context: context,
                    title: 'Resource Explorer',
                    description: 'Checked out the learning resources section',
                    icon: Icons.explore,
                    isUnlocked: _tabController.previousIndex == 1,
                  ),

                  _buildAchievementCard(
                    context: context,
                    title: 'Financial Planner',
                    description:
                        'Used the cash flow tool to plan your finances',
                    icon: Icons.trending_up,
                    isUnlocked: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required bool isUnlocked,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color:
          isUnlocked
              ? null
              : Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      clipBehavior: Clip.antiAlias,
      child: StyledInkWell(
        onTap:
            isUnlocked
                ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Achievement unlocked: $title'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
                : null,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.r),
          leading: CircleAvatar(
            backgroundColor:
                isUnlocked
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              icon,
              color:
                  isUnlocked
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color:
                  isUnlocked
                      ? null
                      : Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              description,
              style: TextStyle(
                color:
                    isUnlocked
                        ? null
                        : Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ),
          trailing: Icon(
            isUnlocked ? Icons.emoji_events : Icons.lock,
            color: isUnlocked ? Colors.amber : null,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
