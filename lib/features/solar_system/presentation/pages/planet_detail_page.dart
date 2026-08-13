import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../home/domain/entities/planet.dart';
import '../cubit/planet_detail_cubit.dart';
import '../widgets/planet_cube.dart';
import '../widgets/planet_detail_widgets.dart';

class PlanetDetailPage extends StatelessWidget {
  const PlanetDetailPage({super.key, required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PlanetDetailCubit>()..load(planet.id),
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
    final name = planetName(t, planet.id);
    final subtitle = planetSubtitle(t, planet.id);

    const spaceBg = Color(0xFF05070F);

    return Scaffold(
      backgroundColor: spaceBg,
      body: Stack(
        children: [
          const StarField(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PlanetDetailHeader(
                  planet: planet,
                  name: name,
                  subtitle: subtitle,
                ),
                Expanded(
                  flex: 5,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (planet.modelPath.isNotEmpty)
                        PlanetCube(planet: planet)
                      else
                        PlanetAnimatedIcon(planet: planet),
                      IgnorePointer(
                        child: Container(
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                spaceBg.withValues(alpha: 0.85),
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
                  child: PlanetInfoPanel(
                    planet: planet,
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
                          PlanetDetailError() =>
                            PlanetFallbackInfo(planet: planet),
                          PlanetDetailLoaded(:final info) =>
                            PlanetApiInfo(planet: planet, info: info),
                        };
                      },
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
