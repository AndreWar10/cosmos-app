import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/observatory.dart';

class ObservatoriesSection extends StatelessWidget {
  const ObservatoriesSection({super.key, required this.observatories});

  final List<Observatory> observatories;

  @override
  Widget build(BuildContext context) {
    if (observatories.isEmpty) return const SizedBox.shrink();

    final t = context.translate;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                t.homeObservatories,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: observatories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final obs = observatories[index];
              return _ObservatoryCard(
                observatory: obs,
                index: index,
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.observatoryDetail,
                  arguments: obs,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

const _gradients = [
  [Color(0xFF1A237E), Color(0xFF283593)],
  [Color(0xFF0D47A1), Color(0xFF1565C0)],
  [Color(0xFF004D40), Color(0xFF00695C)],
  [Color(0xFF311B92), Color(0xFF4527A0)],
  [Color(0xFF1B5E20), Color(0xFF2E7D32)],
  [Color(0xFF880E4F), Color(0xFFAD1457)],
];

class _ObservatoryCard extends StatelessWidget {
  const _ObservatoryCard({
    required this.observatory,
    required this.index,
    required this.onTap,
  });

  final Observatory observatory;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _gradients[index % _gradients.length];

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 220,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            boxShadow: [
              BoxShadow(
                color: colors[0].withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background image with overlay
              Positioned.fill(
                child: Image.asset(
                  observatory.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors[0].withValues(alpha: 0.3),
                        colors[0].withValues(alpha: 0.85),
                        colors[1].withValues(alpha: 0.95),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Stars decoration
              Positioned(
                top: 12,
                right: 12,
                child: _MiniStars(seed: index),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // State badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 10,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              observatory.state,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Name
                      Text(
                        observatory.name,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Rating
                      Row(
                        children: [
                          ...List.generate(5, (i) {
                            final full = i < observatory.rating.floor();
                            final half = !full &&
                                i < observatory.rating &&
                                observatory.rating - i >= 0.3;
                            return Icon(
                              full
                                  ? Icons.star_rounded
                                  : half
                                      ? Icons.star_half_rounded
                                      : Icons.star_outline_rounded,
                              size: 14,
                              color: const Color(0xFFFFD54F),
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            observatory.rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStars extends StatelessWidget {
  const _MiniStars({required this.seed});

  final int seed;

  @override
  Widget build(BuildContext context) {
    final rng = math.Random(seed * 42);
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(painter: _StarDotsPainter(rng)),
    );
  }
}

class _StarDotsPainter extends CustomPainter {
  _StarDotsPainter(this._rng);

  final math.Random _rng;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var i = 0; i < 6; i++) {
      final x = _rng.nextDouble() * size.width;
      final y = _rng.nextDouble() * size.height;
      paint.color =
          Colors.white.withValues(alpha: 0.4 + _rng.nextDouble() * 0.5);
      canvas.drawCircle(Offset(x, y), 0.8 + _rng.nextDouble() * 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
