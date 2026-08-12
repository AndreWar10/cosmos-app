import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';

class ThemeToggleTile extends StatelessWidget {
  const ThemeToggleTile({
    super.key,
    required this.isDark,
    required this.onChanged,
  });

  final bool isDark;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return SwitchListTile(
      title: Text(t.settingsDarkTheme),
      subtitle: Text(isDark ? t.settingsThemeEnabled : t.settingsThemeDisabled),
      secondary: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
        color: Theme.of(context).colorScheme.primary,
      ),
      value: isDark,
      onChanged: onChanged,
    );
  }
}
