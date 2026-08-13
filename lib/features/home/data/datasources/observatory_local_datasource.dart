import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../domain/entities/observatory.dart';

abstract class ObservatoryLocalDataSource {
  Future<List<Observatory>> getAll();
}

class ObservatoryLocalDataSourceImpl implements ObservatoryLocalDataSource {
  ObservatoryLocalDataSourceImpl(this._localeProvider);

  final LocaleProvider _localeProvider;
  Map<String, List<Observatory>>? _cache;

  @override
  Future<List<Observatory>> getAll() async {
    _cache ??= await _loadFromAsset();
    final locale = _localeProvider.isPortuguese ? 'pt' : 'en';
    return _cache![locale] ?? _cache!['pt']!;
  }

  Future<Map<String, List<Observatory>>> _loadFromAsset() async {
    final raw = await rootBundle.loadString('assets/data/observatories.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final result = <String, List<Observatory>>{};

    for (final locale in ['pt', 'en']) {
      final list = json[locale] as List<dynamic>;
      result[locale] = list
          .map((e) => _fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return result;
  }

  Observatory _fromJson(Map<String, dynamic> json) {
    return Observatory(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String? ?? '',
      rating: (json['rating'] as num).toDouble(),
      state: json['state'] as String,
      website: json['website'] as String? ?? '',
      mapsUrl: json['mapsUrl'] as String? ?? '',
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }
}
