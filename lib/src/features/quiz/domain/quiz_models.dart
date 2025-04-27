import 'package:flutter/material.dart';

/// Class representing a financial quiz question
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

// Quiz state model
class QuizStateModel {
  final int currentIndex;
  final int selectedAnswer;
  final bool isAnswered;
  final bool isQuizCompleted;

  const QuizStateModel({
    required this.currentIndex,
    required this.selectedAnswer,
    required this.isAnswered,
    required this.isQuizCompleted,
  });

  // Initial state factory
  factory QuizStateModel.initial() => const QuizStateModel(
    currentIndex: 0,
    selectedAnswer: -1,
    isAnswered: false,
    isQuizCompleted: false,
  );

  // Copy with method for immutability
  QuizStateModel copyWith({
    int? currentIndex,
    int? selectedAnswer,
    bool? isAnswered,
    bool? quizCompleted,
  }) {
    return QuizStateModel(
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isAnswered: isAnswered ?? this.isAnswered,
      isQuizCompleted: quizCompleted ?? this.isQuizCompleted,
    );
  }
}

/// Class representing an achievement in the quiz
class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;

  const Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}
