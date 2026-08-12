import 'package:flutter/material.dart';

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
    return SwitchListTile(
      title: const Text('Tema escuro'),
      subtitle: Text(isDark ? 'Ativado' : 'Desativado'),
      secondary: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
        color: Theme.of(context).colorScheme.primary,
      ),
      value: isDark,
      onChanged: onChanged,
    );
  }
}
