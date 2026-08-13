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

const _planetIcons = {
  'sun': 'assets/planets-animated/Sol.png',
  'mercury': 'assets/planets-animated/Mercúrio.png',
  'venus': 'assets/planets-animated/Vênus.png',
  'earth': 'assets/planets-animated/Terra.png',
  'mars': 'assets/planets-animated/Marte.png',
  'jupiter': 'assets/planets-animated/Júpiter.png',
  'saturn': 'assets/planets-animated/Saturno.png',
  'uranus': 'assets/planets-animated/Urano.png',
  'neptune': 'assets/planets-animated/Netuno.png',
};

class _PlanetItem extends StatelessWidget {
  const _PlanetItem({required this.planet, required this.onTap});

  final Planet planet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final name = _localizedPlanetName(context.translate, planet.id);
    final iconPath = _planetIcons[planet.id];

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: iconPath != null
                  ? Image.asset(iconPath, fit: BoxFit.contain)
                  : Icon(Icons.public, color: planet.accent, size: 36),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: theme.textTheme.labelSmall?.copyWith(
                color: secondaryColor,
                fontSize: 11,
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
