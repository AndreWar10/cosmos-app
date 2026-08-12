import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';

class NewsEmptyWidget extends StatelessWidget {
  const NewsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.article_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
              context.translate.newsEmpty,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
