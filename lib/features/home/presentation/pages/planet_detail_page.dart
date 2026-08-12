import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../domain/entities/planet.dart';
import '../widgets/planet_cube.dart';

class PlanetDetailPage extends StatelessWidget {
  const PlanetDetailPage({super.key, required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Scaffold(
      backgroundColor: const Color(0xFF05070F),
      body: Stack(
        children: [
          const _StarField(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              planet.name,
                              style: TextStyle(
                                color: planet.accent,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                            Text(
                              planet.subtitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 14,
                              ),
                            ),
                            if (planet.hasRings) ...[
                              const SizedBox(height: 8),
                              _FeatureChip(
                                icon: Icons.album_outlined,
                                label: t.planetDetailWithRings,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PlanetCube(planet: planet),
                      IgnorePointer(
                        child: Container(
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFF05070F)
                                    .withValues(alpha: 0.85),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1020),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      border: Border.all(
                        color: planet.accent.withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: planet.accent.withValues(alpha: 0.12),
                          blurRadius: 28,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 42,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                          Text(
                            planet.description,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.88),
                              height: 1.45,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _StatChip(
                                label: t.planetDetailDistance,
                                value: '${planet.distanceFromSunAu} UA',
                                accent: planet.accent,
                              ),
                              _StatChip(
                                label: t.planetDetailDiameter,
                                value: '${planet.diameterKm} km',
                                accent: planet.accent,
                              ),
                              _StatChip(
                                label: t.planetDetailDay,
                                value: planet.dayLength,
                                accent: planet.accent,
                              ),
                              _StatChip(
                                label: t.planetDetailYear,
                                value: planet.yearLength,
                                accent: planet.accent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StarPainter(), size: Size.infinite);
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const seeds = [
      Offset(0.12, 0.08), Offset(0.28, 0.18), Offset(0.45, 0.06),
      Offset(0.67, 0.14), Offset(0.84, 0.09), Offset(0.18, 0.32),
      Offset(0.55, 0.28), Offset(0.92, 0.36), Offset(0.08, 0.55),
      Offset(0.36, 0.48), Offset(0.73, 0.52), Offset(0.95, 0.62),
      Offset(0.22, 0.72), Offset(0.48, 0.68), Offset(0.78, 0.78),
      Offset(0.62, 0.88),
    ];
    for (var i = 0; i < seeds.length; i++) {
      final p = seeds[i];
      paint.color = Colors.white.withValues(alpha: i.isEven ? 0.55 : 0.28);
      canvas.drawCircle(
        Offset(p.dx * size.width, p.dy * size.height),
        i % 3 == 0 ? 1.6 : 1.1,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
