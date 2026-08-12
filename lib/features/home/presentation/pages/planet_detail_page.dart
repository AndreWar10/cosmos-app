import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../i18n/generated/app_localizations.dart';
import '../../domain/entities/planet.dart';
import '../../domain/entities/planet_info.dart';
import '../cubit/planet_detail_cubit.dart';
import '../widgets/planet_cube.dart';

String _planetName(AppLocalizations t, String id) => switch (id) {
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

String _planetSubtitle(AppLocalizations t, String id) => switch (id) {
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

class PlanetDetailPage extends StatelessWidget {
  const PlanetDetailPage({super.key, required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PlanetDetailCubit>()..load(planet.name),
      child: _PlanetDetailView(planet: planet),
    );
  }
}

class _PlanetDetailView extends StatelessWidget {
  const _PlanetDetailView({required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final name = _planetName(t, planet.id);
    final subtitle = _planetSubtitle(t, planet.id);

    return Scaffold(
      backgroundColor: const Color(0xFF05070F),
      body: Stack(
        children: [
          const _StarField(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  planet: planet,
                  name: name,
                  subtitle: subtitle,
                ),
                Expanded(
                  flex: 5,
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
                  flex: 5,
                  child: _InfoPanel(planet: planet),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
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
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.planet});

  final Planet planet;

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
      child: BlocBuilder<PlanetDetailCubit, PlanetDetailState>(
        builder: (context, state) {
          return switch (state) {
            PlanetDetailInitial() => const SizedBox.shrink(),
            PlanetDetailLoading() => Center(
                child: CircularProgressIndicator(
                  color: planet.accent,
                  strokeWidth: 2.5,
                ),
              ),
            PlanetDetailError() => _FallbackInfo(planet: planet),
            PlanetDetailLoaded(:final info) =>
              _ApiInfo(planet: planet, info: info),
          };
        },
      ),
    );
  }
}

class _ApiInfo extends StatelessWidget {
  const _ApiInfo({required this.planet, required this.info});

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
          _DragHandle(),
          _TypeBadge(type: info.type, accent: planet.accent),
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
                _StatChip(
                  icon: Icons.thermostat_rounded,
                  label: t.planetInfoTemperature,
                  value: f.temperature,
                  accent: planet.accent,
                ),
              if (f.gravity.isNotEmpty)
                _StatChip(
                  icon: Icons.fitness_center_rounded,
                  label: t.planetInfoGravity,
                  value: f.gravity,
                  accent: planet.accent,
                ),
              if (f.radius.isNotEmpty)
                _StatChip(
                  icon: Icons.straighten_rounded,
                  label: t.planetInfoRadius,
                  value: f.radius,
                  accent: planet.accent,
                ),
              if (f.sunDistance.isNotEmpty)
                _StatChip(
                  icon: Icons.wb_sunny_outlined,
                  label: t.planetInfoSunDistance,
                  value: f.sunDistance,
                  accent: planet.accent,
                ),
              if (f.orbitalSpeed.isNotEmpty)
                _StatChip(
                  icon: Icons.speed_rounded,
                  label: t.planetInfoOrbitalSpeed,
                  value: f.orbitalSpeed,
                  accent: planet.accent,
                ),
              if (f.rotationDuration.isNotEmpty)
                _StatChip(
                  icon: Icons.rotate_right_rounded,
                  label: t.planetInfoRotation,
                  value: f.rotationDuration,
                  accent: planet.accent,
                ),
              if (f.orbitalPeriod.isNotEmpty)
                _StatChip(
                  icon: Icons.public_rounded,
                  label: t.planetInfoOrbitalPeriod,
                  value: f.orbitalPeriod.join(' / '),
                  accent: planet.accent,
                ),
              if (f.oneWayLightToTheSun.isNotEmpty)
                _StatChip(
                  icon: Icons.bolt_rounded,
                  label: t.planetInfoLightToSun,
                  value: f.oneWayLightToTheSun,
                  accent: planet.accent,
                ),
            ],
          ),
          if (info.satellites.number > 0) ...[
            const SizedBox(height: 16),
            _SatellitesSection(
              satellites: info.satellites,
              accent: planet.accent,
            ),
          ],
        ],
      ),
    );
  }
}

class _FallbackInfo extends StatelessWidget {
  const _FallbackInfo({required this.planet});

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
          _DragHandle(),
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
              _StatChip(
                icon: Icons.straighten_rounded,
                label: t.planetDetailDistance,
                value: '${planet.distanceFromSunAu} UA',
                accent: planet.accent,
              ),
              _StatChip(
                icon: Icons.circle_outlined,
                label: t.planetDetailDiameter,
                value: '${planet.diameterKm} km',
                accent: planet.accent,
              ),
              _StatChip(
                icon: Icons.rotate_right_rounded,
                label: t.planetDetailDay,
                value: planet.dayLength,
                accent: planet.accent,
              ),
              _StatChip(
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

class _DragHandle extends StatelessWidget {
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

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.accent});

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

class _SatellitesSection extends StatelessWidget {
  const _SatellitesSection({
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
