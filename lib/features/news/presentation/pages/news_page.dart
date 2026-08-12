import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate.newsTitle),
      ),
      body: Center(
        child: Text(
          context.translate.navNews,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
