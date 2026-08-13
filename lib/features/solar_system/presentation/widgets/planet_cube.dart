import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

import '../../../home/domain/entities/planet.dart';

class PlanetCube extends StatefulWidget {
  const PlanetCube({super.key, required this.planet});

  final Planet planet;

  @override
  State<PlanetCube> createState() => _PlanetCubeState();
}

class _PlanetCubeState extends State<PlanetCube>
    with TickerProviderStateMixin {
  Scene? _scene;
  Object? _planet;
  late final AnimationController _spin;
  late final AnimationController _glow;

  bool _loading = true;
  int _expectedLoads = 1;
  int _loadedCount = 0;

  static const double _baseScale = 7.6;
  static const double _sunScale = 8.4;
  static const double _saturnScale = 5.2;
  static const String _ringsModel = 'assets/planets/saturn_rings/planet.obj';

  double get _planetScale {
    if (widget.planet.isStar) return _sunScale;
    if (widget.planet.hasRings) return _saturnScale;
    return _baseScale;
  }

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 48),
    )..addListener(_onAutoSpin);
    _spin.repeat();

    _glow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.planet.isStar) {
      _glow.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PlanetCube oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.planet.id != widget.planet.id) {
      if (widget.planet.isStar) {
        if (!_glow.isAnimating) _glow.repeat(reverse: true);
      } else {
        _glow.stop();
        _glow.value = 0;
      }
      _reloadPlanet();
    }
  }

  void _onAutoSpin() {
    final scene = _scene;
    final planet = _planet;
    if (scene == null || planet == null || _loading) return;

    planet.rotation.y += widget.planet.isStar ? 0.25 : 0.4;
    planet.updateTransform();
    scene.update();
  }

  void _reloadPlanet() {
    final scene = _scene;
    if (scene == null) return;
    if (_planet != null) {
      scene.world.remove(_planet!);
      _planet = null;
    }
    _addPlanet(scene);
  }

  void _beginLoading({required int expected}) {
    _expectedLoads = expected;
    _loadedCount = 0;
    if (!_loading) {
      setState(() => _loading = true);
    } else {
      _loading = true;
    }
  }

  void _onObjectCreated(Object object) {
    _loadedCount++;
    if (_loadedCount < _expectedLoads) return;
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _loading = false);
      _scene?.update();
    });
  }

  void _addPlanet(Scene scene) {
    final hasRings = widget.planet.hasRings;
    _beginLoading(expected: hasRings ? 2 : 1);

    final tiltX = hasRings ? 26.0 : (widget.planet.isStar ? 8.0 : 15.0);
    final scale = _planetScale;

    final planet = Object(
      fileName: widget.planet.modelPath,
      lighting: true,
      backfaceCulling: true,
      scale: Vector3(scale, scale, scale),
      rotation: Vector3(tiltX, 25, 0),
    );
    _planet = planet;
    scene.world.add(planet);

    if (hasRings) {
      final rings = Object(
        fileName: _ringsModel,
        lighting: true,
        backfaceCulling: false,
        scale: Vector3(2.35, 2.35, 2.35),
      );
      planet.add(rings);
    }

    _configureLight(scene);
  }

  void _configureLight(Scene scene) {
    if (widget.planet.isStar) {
      scene.light.position.setFrom(Vector3(0, 2, 22));
      scene.light.setColor(const Color(0xFFFFE6A8), 1.35, 1.0, 0.05);
      scene.camera.position.setFrom(Vector3(0, 0.2, -10));
    } else if (widget.planet.hasRings) {
      scene.light.position.setFrom(Vector3(14, 10, 16));
      scene.light.setColor(Colors.white, 1.0, 0.7, 0.22);
      scene.camera.position.setFrom(Vector3(0, 1.4, -10.5));
    } else {
      scene.light.position.setFrom(Vector3(12, 8, 18));
      scene.light.setColor(Colors.white, 1.0, 0.65, 0.25);
      scene.camera.position.setFrom(Vector3(0, 0.6, -10));
    }
    scene.camera.zoom = 1.0;
    scene.camera.target.setFrom(Vector3(0, 0, 0));
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    _addPlanet(scene);
  }

  @override
  void dispose() {
    _spin.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.planet.isStar) _SunGlow(animation: _glow),
        Cube(
          interactive: false,
          onSceneCreated: _onSceneCreated,
          onObjectCreated: _onObjectCreated,
        ),
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: _loading ? 1 : 0,
            duration: const Duration(milliseconds: 350),
            child: _PlanetLoading(accent: widget.planet.accent),
          ),
        ),
      ],
    );
  }
}

class _SunGlow extends StatelessWidget {
  const _SunGlow({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.05),
                  radius: 0.72 + (t * 0.06),
                  colors: [
                    Color.lerp(
                      const Color(0xFFFFF1B0),
                      const Color(0xFFFFE08A),
                      t,
                    )!
                        .withValues(alpha: 0.55 + t * 0.12),
                    const Color(0xFFFF9F43).withValues(alpha: 0.28 + t * 0.08),
                    const Color(0xFFFF6B1A).withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.28, 0.5, 0.78],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.05),
                  radius: 0.38 + (t * 0.04),
                  colors: [
                    Colors.white.withValues(alpha: 0.35 + t * 0.1),
                    const Color(0xFFFFD27A).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlanetLoading extends StatelessWidget {
  const _PlanetLoading({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF05070F).withValues(alpha: 0.72),
      child: Center(
        child: SizedBox(
          width: 42,
          height: 42,
          child: CircularProgressIndicator(
            strokeWidth: 2.6,
            color: accent,
            backgroundColor: accent.withValues(alpha: 0.15),
          ),
        ),
      ),
    );
  }
}
