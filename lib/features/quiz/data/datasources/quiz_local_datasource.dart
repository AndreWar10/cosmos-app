import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/cache/app_cache.dart';
import '../../../../core/locale/locale_provider.dart';
import '../../domain/entities/quiz_category.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/quiz_stats.dart';

abstract class QuizLocalDataSource {
  Future<List<QuizCategory>> getCategories();
  Future<List<QuizQuestion>> getQuestions({String? categoryId});
  Future<QuizStats> getStats();
  Future<void> saveResult({
    required String categoryId,
    required int score,
    required int totalQuestions,
  });
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  QuizLocalDataSourceImpl(this._localeProvider, this._cache);

  final LocaleProvider _localeProvider;
  final AppCache _cache;

  Map<String, dynamic>? _data;

  static const _prefix = 'quiz_';
  static const _totalAnsweredKey = '${_prefix}total_answered';
  static const _totalCorrectKey = '${_prefix}total_correct';

  String get _locale => _localeProvider.isPortuguese ? 'pt' : 'en';

  Future<Map<String, dynamic>> _loadData() async {
    if (_data != null) return _data!;
    final raw = await rootBundle.loadString('assets/data/quiz.json');
    _data = jsonDecode(raw) as Map<String, dynamic>;
    return _data!;
  }

  @override
  Future<List<QuizCategory>> getCategories() async {
    final data = await _loadData();
    final categories = data['categories'] as List<dynamic>;
    final questions = data['questions'] as List<dynamic>;
    final locale = _locale;

    return categories.map((c) {
      final map = c as Map<String, dynamic>;
      final id = map['id'] as String;
      final localized = map[locale] as Map<String, dynamic>;
      final count =
          questions.where((q) => (q as Map)['category'] == id).length;
      return QuizCategory(
        id: id,
        name: localized['name'] as String,
        icon: map['icon'] as String,
        questionCount: count,
      );
    }).toList();
  }

  @override
  Future<List<QuizQuestion>> getQuestions({String? categoryId}) async {
    final data = await _loadData();
    final questions = data['questions'] as List<dynamic>;
    final locale = _locale;

    var filtered = questions;
    if (categoryId != null) {
      filtered = questions
          .where((q) => (q as Map)['category'] == categoryId)
          .toList();
    }

    return filtered.map((q) {
      final map = q as Map<String, dynamic>;
      final localized = map[locale] as Map<String, dynamic>;
      return QuizQuestion(
        id: map['id'] as String,
        category: map['category'] as String,
        question: localized['question'] as String,
        options:
            (localized['options'] as List<dynamic>).cast<String>(),
        correctIndex: localized['correct'] as int,
        explanation: localized['explanation'] as String,
      );
    }).toList();
  }

  @override
  Future<QuizStats> getStats() async {
    final data = await _loadData();
    final categories = data['categories'] as List<dynamic>;

    final highScores = <String, int>{};
    for (final c in categories) {
      final id = (c as Map)['id'] as String;
      final score = _cache.getString('${_prefix}high_$id');
      if (score != null) {
        highScores[id] = int.tryParse(score) ?? 0;
      }
    }

    final totalAnswered =
        int.tryParse(_cache.getString(_totalAnsweredKey) ?? '') ?? 0;
    final totalCorrect =
        int.tryParse(_cache.getString(_totalCorrectKey) ?? '') ?? 0;

    return QuizStats(
      highScores: highScores,
      totalAnswered: totalAnswered,
      totalCorrect: totalCorrect,
    );
  }

  @override
  Future<void> saveResult({
    required String categoryId,
    required int score,
    required int totalQuestions,
  }) async {
    final currentHigh =
        int.tryParse(_cache.getString('${_prefix}high_$categoryId') ?? '') ??
            0;
    if (score > currentHigh) {
      await _cache.setString('${_prefix}high_$categoryId', score.toString());
    }

    final totalAnswered =
        int.tryParse(_cache.getString(_totalAnsweredKey) ?? '') ?? 0;
    final totalCorrect =
        int.tryParse(_cache.getString(_totalCorrectKey) ?? '') ?? 0;

    await _cache.setString(
        _totalAnsweredKey, (totalAnswered + totalQuestions).toString());
    await _cache.setString(
        _totalCorrectKey, (totalCorrect + score).toString());
  }
}
