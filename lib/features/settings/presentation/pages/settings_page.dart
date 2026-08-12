import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../widgets/settings_section.dart';
import '../widgets/theme_toggle_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          SettingsSection(
            title: 'Aparência',
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
        ],
      ),
    );
  }
}
