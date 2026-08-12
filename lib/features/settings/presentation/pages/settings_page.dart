
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../widgets/locale_toggle_tile.dart';
import '../widgets/settings_section.dart';
import '../widgets/theme_toggle_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          SettingsSection(
            title: t.settingsAppearance,
            children: [
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return ThemeToggleTile(
                    isDark: themeMode == ThemeMode.dark,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SettingsSection(
            title: t.settingsLanguage,
            children: [
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return LocaleToggleTile(
                    isPortuguese: locale.languageCode == 'pt',
                    onChanged: (newLocale) {
                      context.read<LocaleCubit>().setLocale(newLocale);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
