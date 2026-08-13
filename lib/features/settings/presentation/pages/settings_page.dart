import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../widgets/settings_section_label.dart';
import '../widgets/settings_tile.dart';
import '../widgets/sound_toggle_card.dart';

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
          SettingsSectionLabel(label: t.settingsAppearance),
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
                return SettingsTile(
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
          SettingsSectionLabel(label: t.settingsLanguage),
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
                return SettingsTile(
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
          SettingsSectionLabel(label: t.settingsSoundEffects),
          const SizedBox(height: 8),
          SoundToggleCard(surface: surface, isDark: isDark),

          const SizedBox(height: 24),
          SettingsSectionLabel(label: 'App'),
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
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: t.settingsAppVersion,
                  subtitle: 'v1.0.0',
                ),
                Divider(height: 1, indent: 56, endIndent: 16, color: divider),
                SettingsTile(
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
