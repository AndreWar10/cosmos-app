import 'package:flutter/material.dart';

class Planet {
  const Planet({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.modelPath,
    required this.texturePreviewPath,
    required this.accent,
    required this.distanceFromSunAu,
    required this.diameterKm,
    required this.dayLength,
    required this.yearLength,
    this.isStar = false,
    this.hasRings = false,
  });

  final String id;
  final String name;
  final String subtitle;
  final String description;
  final String modelPath;
  final String texturePreviewPath;
  final Color accent;
  final String distanceFromSunAu;
  final String diameterKm;
  final String dayLength;
  final String yearLength;
  final bool isStar;
  final bool hasRings;
}
