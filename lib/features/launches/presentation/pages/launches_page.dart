import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';

class LaunchesPage extends StatelessWidget {
  const LaunchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate.launchesTitle),
      ),
      body: Center(
        child: Text(
          context.translate.navLaunches,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
