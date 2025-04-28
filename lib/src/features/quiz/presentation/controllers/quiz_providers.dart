import 'package:flutter/material.dart';
import 'package:maluk/src/features/quiz/data/financial_resources.dart';
import 'package:maluk/src/features/quiz/domain/quiz_models.dart';
import 'package:maluk/src/features/quiz/data/quiz_questions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_providers.g.dart';

// Current quiz state provider
@Riverpod(keepAlive: true)
class QuizState extends _$QuizState {
  @override
  QuizStateModel build() {
    return QuizStateModel.initial();
  }

  // Get current question
  QuizQuestion get currentQuestion => quizQuestions[state.currentIndex];

  // Select answer
  void selectAnswer(int index) {
    state = state.copyWith(selectedAnswer: index, isAnswered: true);
  }

  // Go to next question
  void nextQuestion() {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex < quizQuestions.length) {
      state = QuizStateModel(
        currentIndex: nextIndex,
        selectedAnswer: -1,
        isAnswered: false,
        isQuizCompleted: false,
      );
    } else {
      state = state.copyWith(isQuizCompleted: true);
    }
  }

  // Reset quiz
  void resetQuiz() {
    state = QuizStateModel.initial();
  }

  // Get the list of achievements
  List<Achievement> getAchievements({bool checkedResources = false}) => [
    Achievement(
      title: 'Quiz Starter',
      description: 'Started the financial wellness quiz',
      icon: Icons.play_circle,
      isUnlocked: true,
    ),
    Achievement(
      title: 'Knowledge Seeker',
      description: 'Answered all three financial wellness questions',
      icon: Icons.school,
      isUnlocked: state.isQuizCompleted,
    ),
    Achievement(
      title: 'Resource Explorer',
      description: 'Checked out the learning resources section',
      icon: Icons.explore,
      isUnlocked: checkedResources,
    ),
    Achievement(
      title: 'Financial Planner',
      description: 'Used the cash flow tool to plan your finances',
      icon: Icons.trending_up,
      isUnlocked: false,
    ),
  ];

  // Get financial resources
  List<Map<String, dynamic>> getResources() => financialResources;
}
