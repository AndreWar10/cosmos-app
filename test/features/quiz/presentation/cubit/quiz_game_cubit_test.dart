
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/quiz/domain/entities/quiz_question.dart';
import 'package:cosmos_app/features/quiz/domain/usecases/get_quiz_questions_usecase.dart';
import 'package:cosmos_app/features/quiz/domain/usecases/save_quiz_result_usecase.dart';
import 'package:cosmos_app/features/quiz/data/services/quiz_sound_service.dart';
import 'package:cosmos_app/features/quiz/presentation/cubit/quiz_game_cubit.dart';

class MockGetQuizQuestionsUseCase extends Mock
    implements GetQuizQuestionsUseCase {}

class MockSaveQuizResultUseCase extends Mock
    implements SaveQuizResultUseCase {}

class MockQuizSoundService extends Mock implements QuizSoundService {}

final _questions = [
  const QuizQuestion(
    id: '1',
    category: 'solar',
    question: 'Largest planet?',
    options: ['Mars', 'Jupiter', 'Saturn', 'Earth'],
    correctIndex: 1,
    explanation: 'Jupiter is the largest',
  ),
  const QuizQuestion(
    id: '2',
    category: 'solar',
    question: 'Closest to sun?',
    options: ['Venus', 'Mercury', 'Earth', 'Mars'],
    correctIndex: 1,
    explanation: 'Mercury is closest',
  ),
];

void main() {
  late MockGetQuizQuestionsUseCase mockGetQuestions;
  late MockSaveQuizResultUseCase mockSaveResult;
  late MockQuizSoundService soundService;

  setUp(() {
    mockGetQuestions = MockGetQuizQuestionsUseCase();
    mockSaveResult = MockSaveQuizResultUseCase();
    soundService = MockQuizSoundService();
    when(() => soundService.playCorrect()).thenAnswer((_) async {});
    when(() => soundService.playWrong()).thenAnswer((_) async {});
    when(() => soundService.playTick()).thenAnswer((_) async {});
    when(() => soundService.playComplete()).thenAnswer((_) async {});
  });

  group('QuizGameCubit', () {
    test('initial state should be QuizGameLoading', () {
      final cubit =
          QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      expect(cubit.state, isA<QuizGameLoading>());
      cubit.close();
    });

    blocTest<QuizGameCubit, QuizGameState>(
      'start should emit [Loading, Playing] with questions',
      build: () {
        when(() => mockGetQuestions(categoryId: 'solar'))
            .thenAnswer((_) async => _questions);
        return QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      },
      act: (cubit) => cubit.start(categoryId: 'solar'),
      expect: () => [
        isA<QuizGameLoading>(),
        isA<QuizGamePlaying>(),
      ],
      verify: (cubit) {
        final state = cubit.state as QuizGamePlaying;
        expect(state.totalQuestions, 2);
        expect(state.currentIndex, 0);
        expect(state.answered, false);
        expect(state.secondsLeft, 30);
        expect(state.categoryId, 'solar');
      },
    );

    blocTest<QuizGameCubit, QuizGameState>(
      'selectAnswer with correct index should increment correctCount',
      build: () {
        when(() => mockGetQuestions(categoryId: 'solar'))
            .thenAnswer((_) async => _questions);
        return QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      },
      act: (cubit) async {
        await cubit.start(categoryId: 'solar');
        final s = cubit.state as QuizGamePlaying;
        cubit.selectAnswer(s.currentQuestion.correctIndex);
      },
      verify: (cubit) {
        final state = cubit.state as QuizGamePlaying;
        expect(state.answered, true);
        expect(state.correctCount, 1);
        expect(state.selectedIndex, state.currentQuestion.correctIndex);
      },
    );

    blocTest<QuizGameCubit, QuizGameState>(
      'selectAnswer with wrong index should not increment correctCount',
      build: () {
        when(() => mockGetQuestions(categoryId: 'solar'))
            .thenAnswer((_) async => _questions);
        return QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      },
      act: (cubit) async {
        await cubit.start(categoryId: 'solar');
        cubit.selectAnswer(0);
      },
      verify: (cubit) {
        final state = cubit.state as QuizGamePlaying;
        expect(state.answered, true);
        expect(state.correctCount, 0);
      },
    );

    blocTest<QuizGameCubit, QuizGameState>(
      'selectAnswer should be ignored when already answered',
      build: () {
        when(() => mockGetQuestions(categoryId: 'solar'))
            .thenAnswer((_) async => _questions);
        return QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      },
      act: (cubit) async {
        await cubit.start(categoryId: 'solar');
        cubit.selectAnswer(0);
        cubit.selectAnswer(1);
      },
      verify: (cubit) {
        final state = cubit.state as QuizGamePlaying;
        expect(state.selectedIndex, 0);
      },
    );

    blocTest<QuizGameCubit, QuizGameState>(
      'timeUp should mark question as answered with no selection',
      build: () {
        when(() => mockGetQuestions(categoryId: 'solar'))
            .thenAnswer((_) async => _questions);
        return QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      },
      act: (cubit) async {
        await cubit.start(categoryId: 'solar');
        cubit.timeUp();
      },
      verify: (cubit) {
        final state = cubit.state as QuizGamePlaying;
        expect(state.answered, true);
        expect(state.selectedIndex, isNull);
        expect(state.secondsLeft, 0);
      },
    );

    blocTest<QuizGameCubit, QuizGameState>(
      'nextQuestion should advance to next question',
      build: () {
        when(() => mockGetQuestions(categoryId: 'solar'))
            .thenAnswer((_) async => _questions);
        return QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      },
      act: (cubit) async {
        await cubit.start(categoryId: 'solar');
        cubit.selectAnswer(0);
        cubit.nextQuestion();
      },
      verify: (cubit) {
        final state = cubit.state as QuizGamePlaying;
        expect(state.currentIndex, 1);
        expect(state.answered, false);
        expect(state.selectedIndex, isNull);
        expect(state.secondsLeft, 30);
      },
    );

    blocTest<QuizGameCubit, QuizGameState>(
      'nextQuestion on last question should finish quiz',
      build: () {
        when(() => mockGetQuestions(categoryId: 'solar'))
            .thenAnswer((_) async => _questions);
        when(() => mockSaveResult(
              categoryId: any(named: 'categoryId'),
              score: any(named: 'score'),
              totalQuestions: any(named: 'totalQuestions'),
            )).thenAnswer((_) async {});
        return QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      },
      act: (cubit) async {
        await cubit.start(categoryId: 'solar');
        cubit.selectAnswer(1);
        cubit.nextQuestion();
        cubit.selectAnswer(0);
        await Future.delayed(const Duration(milliseconds: 50));
        cubit.nextQuestion();
        await Future.delayed(const Duration(milliseconds: 50));
      },
      verify: (cubit) {
        expect(cubit.state, isA<QuizGameFinished>());
        final state = cubit.state as QuizGameFinished;
        expect(state.result.totalQuestions, 2);
      },
    );

    blocTest<QuizGameCubit, QuizGameState>(
      'quick play should limit to 10 questions',
      build: () {
        final manyQuestions = List.generate(
          20,
          (i) => QuizQuestion(
            id: '$i',
            category: 'solar',
            question: 'Question $i?',
            options: const ['A', 'B', 'C', 'D'],
            correctIndex: 0,
            explanation: 'Explanation $i',
          ),
        );
        when(() => mockGetQuestions(categoryId: null))
            .thenAnswer((_) async => manyQuestions);
        return QuizGameCubit(mockGetQuestions, mockSaveResult, soundService);
      },
      act: (cubit) => cubit.start(),
      verify: (cubit) {
        final state = cubit.state as QuizGamePlaying;
        expect(state.totalQuestions, 10);
        expect(state.categoryId, 'quick');
      },
    );
  });
}
