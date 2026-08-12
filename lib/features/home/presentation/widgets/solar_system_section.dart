import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/generated/app_localizations.dart';
import '../../data/planets_data.dart';
import '../../domain/entities/planet.dart';

String _localizedPlanetName(AppLocalizations t, String id) {
  return switch (id) {
    'sun' => t.planetSun,
    'mercury' => t.planetMercury,
    'venus' => t.planetVenus,
    'earth' => t.planetEarth,
    'mars' => t.planetMars,
    'jupiter' => t.planetJupiter,
    'saturn' => t.planetSaturn,
    'uranus' => t.planetUranus,
    'neptune' => t.planetNeptune,
    _ => id,
  };
}

class SolarSystemSection extends StatelessWidget {
  const SolarSystemSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);

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
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: planets.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) => _PlanetItem(
              planet: planets[index],
              onTap: () => Navigator.of(context).pushNamed(
                AppRoutes.planetDetail,
                arguments: planets[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanetItem extends StatelessWidget {
  const _PlanetItem({required this.planet, required this.onTap});

  final Planet planet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: planet.accent.withValues(alpha: 0.10),
                border: Border.all(
                  color: planet.accent.withValues(alpha: 0.30),
                  width: 1.5,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: ClipOval(
                child: Image.asset(
                  planet.texturePreviewPath,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(
                    planet.isStar ? Icons.wb_sunny : Icons.public,
                    color: planet.accent,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _localizedPlanetName(context.translate, planet.id),
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
      ),
    );
  }
}
