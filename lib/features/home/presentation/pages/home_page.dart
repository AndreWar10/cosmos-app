import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate.homeTitle),
      ),
      body: Center(
        child: Text(
          context.translate.navHome,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
