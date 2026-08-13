import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../quiz/data/services/quiz_sound_service.dart';
import 'settings_tile.dart';

class SoundToggleCard extends StatefulWidget {
  const SoundToggleCard({
    super.key,
    required this.surface,
    required this.isDark,
  });

  final Color surface;
  final bool isDark;

  @override
  State<SoundToggleCard> createState() => _SoundToggleCardState();
}

class _SoundToggleCardState extends State<SoundToggleCard> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = sl<QuizSoundService>().isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Container(
      decoration: BoxDecoration(
        color: widget.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: widget.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: SettingsTile(
        icon: _enabled
            ? Icons.volume_up_rounded
            : Icons.volume_off_rounded,
        title: t.settingsSoundEffects,
        subtitle: _enabled
            ? t.settingsSoundEnabled
            : t.settingsSoundDisabled,
        trailing: Switch(
          value: _enabled,
          onChanged: (value) {
            sl<QuizSoundService>().setEnabled(value);
            setState(() => _enabled = value);
          },
        ),
      ),
    );
  }
}
