import 'package:flutter/material.dart';

class LaunchesPage extends StatelessWidget {
  const LaunchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launches'),
      ),
      body: Center(
        child: Text(
          'Launches',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
