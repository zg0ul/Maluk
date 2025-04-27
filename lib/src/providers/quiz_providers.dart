import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:maluk/src/common/models/finance_models.dart';

part 'quiz_providers.g.dart';

// Quiz questions with predefined questions and answers
final List<QuizQuestion> _quizQuestions = [
  const QuizQuestion(
    question: 'What does financial wellness mean?',
    options: [
      'Having a lot of money in my bank account',
      'Feeling financially secure today and having freedom of choice for the future',
      'Not thinking about money at all, ever!',
    ],
    correctAnswerIndex: 1,
    explanation:
        'Financial wellness means feeling in control of your money, covering your monthly and seasonal expenses today, and planning for the future with confidence!',
  ),
  const QuizQuestion(
    question:
        'Do you need to be a financial expert to advance your financial wellness?',
    options: ['Yes', 'No'],
    correctAnswerIndex: 1,
    explanation:
        'No, you don\'t need to be a financial expert! Just like staying healthy doesn\'t require being a doctor, financial wellness is about awareness, taking small steps, making smart decisions, and staying consistent with your money habits.',
  ),
  const QuizQuestion(
    question: 'Which of these best describes the journey to financial freedom?',
    options: [
      'You just need to make more money and everything will work out',
      'There are stages—Dependency → Solvency → Stability → Security → Independence → Freedom',
      'If you\'re smart with money, you never have to worry about it',
    ],
    correctAnswerIndex: 1,
    explanation:
        'Financial wellness is a journey with clear stages. The goal is to move from one stage to the next through small actionable steps.',
  ),
];

// Current quiz index provider
@riverpod
class QuizState extends _$QuizState {
  @override
  Map<String, dynamic> build() {
    return {
      'currentIndex': 0,
      'selectedAnswer': -1,
      'isAnswered': false,
      'quizCompleted': false,
    };
  }

  // Get current question
  QuizQuestion get currentQuestion => _quizQuestions[state['currentIndex']];

  // Select answer
  void selectAnswer(int index) {
    state = {...state, 'selectedAnswer': index, 'isAnswered': true};
  }

  // Go to next question
  void nextQuestion() {
    final nextIndex = state['currentIndex'] + 1;

    if (nextIndex < _quizQuestions.length) {
      state = {
        'currentIndex': nextIndex,
        'selectedAnswer': -1,
        'isAnswered': false,
        'quizCompleted': false,
      };
    } else {
      state = {...state, 'quizCompleted': true};
    }
  }

  // Reset quiz
  void resetQuiz() {
    state = {
      'currentIndex': 0,
      'selectedAnswer': -1,
      'isAnswered': false,
      'quizCompleted': false,
    };
  }
}
