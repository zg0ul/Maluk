import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maluk/src/features/quiz/presentation/controllers/quiz_providers.dart';
import 'package:maluk/src/features/quiz/presentation/views/progress_view.dart';
import 'package:maluk/src/features/quiz/presentation/views/quiz_completed_view.dart';
import 'package:maluk/src/features/quiz/presentation/views/quiz_view.dart';
import 'package:maluk/src/features/quiz/presentation/views/resources_view.dart';
import 'package:maluk/src/common/widgets/custom_app_bar.dart';
import 'package:maluk/src/common/widgets/custom_tab_bar.dart';

/// The main Quiz page that shows the financial wellness quiz
class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _tabs = ['Quiz', 'Resources', 'Your Progress'];
  bool _hasViewedResources = false;

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Rebuild when tab changes

        // Mark resources as viewed when resources tab is selected
        if (_tabController.index == 1) {
          setState(() {
            _hasViewedResources = true;
          });
        }
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
    final quizCompleted = quizState.isQuizCompleted;

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
              ? QuizCompletedView(
                onViewResources: () => _tabController.animateTo(1),
              )
              : QuizView(onViewResources: () => _tabController.animateTo(1)),

          // Tab 2: Financial Resources
          ResourcesView(
            onResourcesViewed:
                () => setState(() {
                  _hasViewedResources = true;
                }),
          ),

          // Tab 3: Quiz Progress
          ProgressView(hasViewedResources: _hasViewedResources),
        ],
      ),
    );
  }
}
