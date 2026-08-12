import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class SolarSystemSection extends StatelessWidget {
  const SolarSystemSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);

    final planets = [
      _PlanetData(t.planetMercury, '☿', const Color(0xFFB0A090)),
      _PlanetData(t.planetVenus, '♀', const Color(0xFFE8C06A)),
      _PlanetData(t.planetEarth, '🌍', const Color(0xFF4A90D9)),
      _PlanetData(t.planetMars, '♂', const Color(0xFFD46A4A)),
      _PlanetData(t.planetJupiter, '♃', const Color(0xFFC4A46A)),
      _PlanetData(t.planetSaturn, '♄', const Color(0xFFD4B878)),
      _PlanetData(t.planetUranus, '♅', const Color(0xFF7EC8E3)),
      _PlanetData(t.planetNeptune, '♆', const Color(0xFF4169E1)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            t.homeSolarSystem,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: planets.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) =>
                _PlanetItem(planet: planets[index]),
          ),
        ),
      ],
    );
  }
}

class _PlanetData {
  const _PlanetData(this.name, this.symbol, this.color);
  final String name;
  final String symbol;
  final Color color;
}

class _PlanetItem extends StatelessWidget {
  const _PlanetItem({required this.planet});

  final _PlanetData planet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: planet.color.withValues(alpha: 0.15),
              border: Border.all(
                color: planet.color.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                planet.symbol,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            planet.name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: secondaryColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
