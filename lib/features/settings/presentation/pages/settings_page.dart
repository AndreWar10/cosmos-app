import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../quiz/data/services/quiz_sound_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel(label: t.settingsAppearance),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                final darkOn = themeMode == ThemeMode.dark;
                return _SettingsTile(
                  icon: darkOn ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  title: t.settingsDarkTheme,
                  subtitle: darkOn
                      ? t.settingsThemeEnabled
                      : t.settingsThemeDisabled,
                  trailing: Switch(
                    value: darkOn,
                    onChanged: (_) =>
                        context.read<ThemeCubit>().toggleTheme(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          _SectionLabel(label: t.settingsLanguage),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                final isPt = locale.languageCode == 'pt';
                return _SettingsTile(
                  icon: Icons.language_rounded,
                  title: t.settingsLanguageLabel,
                  subtitle: isPt
                      ? t.settingsLanguagePortuguese
                      : t.settingsLanguageEnglish,
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'pt', label: Text('PT')),
                      ButtonSegment(value: 'en', label: Text('EN')),
                    ],
                    selected: {isPt ? 'pt' : 'en'},
                    onSelectionChanged: (selected) {
                      context
                          .read<LocaleCubit>()
                          .setLocale(Locale(selected.first));
                    },
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
          _SectionLabel(label: t.settingsSoundEffects),
          const SizedBox(height: 8),
          _SoundToggleCard(surface: surface, isDark: isDark),

          const SizedBox(height: 24),
          _SectionLabel(label: 'App'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: t.settingsAppVersion,
                  subtitle: 'v1.0.0',
                ),
                Divider(height: 1, indent: 56, endIndent: 16, color: divider),
                _SettingsTile(
                  icon: Icons.code_rounded,
                  title: t.settingsDeveloper,
                  subtitle: 'WarCode',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SoundToggleCard extends StatefulWidget {
  const _SoundToggleCard({required this.surface, required this.isDark});

  final Color surface;
  final bool isDark;

  @override
  State<_SoundToggleCard> createState() => _SoundToggleCardState();
}

class _SoundToggleCardState extends State<_SoundToggleCard> {
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
      child: _SettingsTile(
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
