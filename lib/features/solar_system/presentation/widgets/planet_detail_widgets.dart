import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../i18n/generated/app_localizations.dart';
import '../../../home/domain/entities/planet.dart';
import '../../../home/domain/entities/planet_info.dart';

String planetName(AppLocalizations t, String id) => switch (id) {
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

String planetSubtitle(AppLocalizations t, String id) => switch (id) {
      'sun' => t.planetSunSubtitle,
      'mercury' => t.planetMercurySubtitle,
      'venus' => t.planetVenusSubtitle,
      'earth' => t.planetEarthSubtitle,
      'mars' => t.planetMarsSubtitle,
      'jupiter' => t.planetJupiterSubtitle,
      'saturn' => t.planetSaturnSubtitle,
      'uranus' => t.planetUranusSubtitle,
      'neptune' => t.planetNeptuneSubtitle,
      _ => '',
    };

const planetIcons = <String, String>{
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

class PlanetDetailHeader extends StatelessWidget {
  const PlanetDetailHeader({
    super.key,
    required this.planet,
    required this.name,
    required this.subtitle,
  });

  final Planet planet;
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Padding(
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
                  name,
                  style: TextStyle(
                    color: planet.accent,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 14,
                  ),
                ),
                if (planet.hasRings) ...[
                  const SizedBox(height: 8),
                  FeatureChip(
                    icon: Icons.album_outlined,
                    label: t.planetDetailWithRings,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanetInfoPanel extends StatelessWidget {
  const PlanetInfoPanel({super.key, required this.planet, required this.child});

  final Planet planet;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class PlanetApiInfo extends StatelessWidget {
  const PlanetApiInfo({super.key, required this.planet, required this.info});

  final Planet planet;
  final PlanetInfo info;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final f = info.features;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandle(),
          TypeBadge(type: info.type, accent: planet.accent),
          const SizedBox(height: 12),
          Text(
            info.resume,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              height: 1.45,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (f.temperature.isNotEmpty)
                StatChip(
                  icon: Icons.thermostat_rounded,
                  label: t.planetInfoTemperature,
                  value: f.temperature,
                  accent: planet.accent,
                ),
              if (f.gravity.isNotEmpty)
                StatChip(
                  icon: Icons.fitness_center_rounded,
                  label: t.planetInfoGravity,
                  value: f.gravity,
                  accent: planet.accent,
                ),
              if (f.radius.isNotEmpty)
                StatChip(
                  icon: Icons.straighten_rounded,
                  label: t.planetInfoRadius,
                  value: f.radius,
                  accent: planet.accent,
                ),
              if (f.sunDistance.isNotEmpty)
                StatChip(
                  icon: Icons.wb_sunny_outlined,
                  label: t.planetInfoSunDistance,
                  value: f.sunDistance,
                  accent: planet.accent,
                ),
              if (f.orbitalSpeed.isNotEmpty)
                StatChip(
                  icon: Icons.speed_rounded,
                  label: t.planetInfoOrbitalSpeed,
                  value: f.orbitalSpeed,
                  accent: planet.accent,
                ),
              if (f.rotationDuration.isNotEmpty)
                StatChip(
                  icon: Icons.rotate_right_rounded,
                  label: t.planetInfoRotation,
                  value: f.rotationDuration,
                  accent: planet.accent,
                ),
              if (f.orbitalPeriod.isNotEmpty)
                StatChip(
                  icon: Icons.public_rounded,
                  label: t.planetInfoOrbitalPeriod,
                  value: f.orbitalPeriod.join(' / '),
                  accent: planet.accent,
                ),
              if (f.oneWayLightToTheSun.isNotEmpty)
                StatChip(
                  icon: Icons.bolt_rounded,
                  label: t.planetInfoLightToSun,
                  value: f.oneWayLightToTheSun,
                  accent: planet.accent,
                ),
            ],
          ),
          if (info.satellites.number > 0) ...[
            const SizedBox(height: 16),
            SatellitesSection(
              satellites: info.satellites,
              accent: planet.accent,
            ),
          ],
        ],
      ),
    );
  }
}

class PlanetFallbackInfo extends StatelessWidget {
  const PlanetFallbackInfo({super.key, required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final id = planet.id;

    final description = switch (id) {
      'sun' => t.planetSunDescription,
      'mercury' => t.planetMercuryDescription,
      'venus' => t.planetVenusDescription,
      'earth' => t.planetEarthDescription,
      'mars' => t.planetMarsDescription,
      'jupiter' => t.planetJupiterDescription,
      'saturn' => t.planetSaturnDescription,
      'uranus' => t.planetUranusDescription,
      'neptune' => t.planetNeptuneDescription,
      _ => '',
    };

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandle(),
          Text(
            description,
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
              StatChip(
                icon: Icons.straighten_rounded,
                label: t.planetDetailDistance,
                value: '${planet.distanceFromSunAu} UA',
                accent: planet.accent,
              ),
              StatChip(
                icon: Icons.circle_outlined,
                label: t.planetDetailDiameter,
                value: '${planet.diameterKm} km',
                accent: planet.accent,
              ),
              StatChip(
                icon: Icons.rotate_right_rounded,
                label: t.planetDetailDay,
                value: planet.dayLength,
                accent: planet.accent,
              ),
              StatChip(
                icon: Icons.public_rounded,
                label: t.planetDetailYear,
                value: planet.yearLength,
                accent: planet.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}

class TypeBadge extends StatelessWidget {
  const TypeBadge({super.key, required this.type, required this.accent});

  final String type;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: accent,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SatellitesSection extends StatelessWidget {
  const SatellitesSection({
    super.key,
    required this.satellites,
    required this.accent,
  });

  final PlanetSatellites satellites;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.nightlight_round, size: 16, color: accent),
            const SizedBox(width: 6),
            Text(
              '${t.planetInfoSatellites} (${satellites.number})',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (satellites.names.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: satellites.names.map((name) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withValues(alpha: 0.2)),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class FeatureChip extends StatelessWidget {
  const FeatureChip({super.key, required this.icon, required this.label});

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

class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
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
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.white.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class PlanetAnimatedIcon extends StatelessWidget {
  const PlanetAnimatedIcon({super.key, required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    final iconPath = planetIcons[planet.id];
    return Center(
      child: iconPath != null
          ? Image.asset(iconPath, width: 180, height: 180, fit: BoxFit.contain)
          : Icon(Icons.public, color: planet.accent, size: 120),
    );
  }
}

class StarField extends StatelessWidget {
  const StarField({super.key});

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
