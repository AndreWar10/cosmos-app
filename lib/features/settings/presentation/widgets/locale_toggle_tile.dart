
import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';

class LocaleToggleTile extends StatelessWidget {
  const LocaleToggleTile({
    super.key,
    required this.isPortuguese,
    required this.onChanged,
  });

  final bool isPortuguese;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return ListTile(
      leading: Icon(
        Icons.language,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(t.settingsLanguageLabel),
      subtitle: Text(
        isPortuguese ? t.settingsLanguagePortuguese : t.settingsLanguageEnglish,
      ),
      trailing: SegmentedButton<String>(
        segments: [
          ButtonSegment(value: 'pt', label: Text('PT')),
          ButtonSegment(value: 'en', label: Text('EN')),
        ],
        selected: {isPortuguese ? 'pt' : 'en'},
        onSelectionChanged: (selected) {
          onChanged(Locale(selected.first));
        },
      ),
    );
  }
}
