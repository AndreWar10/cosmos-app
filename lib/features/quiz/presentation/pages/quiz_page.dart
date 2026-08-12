import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Scaffold(
      appBar: AppBar(title: Text(t.navQuiz)),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.quiz_rounded, size: 64, color: Colors.white38),
            SizedBox(height: 16),
            Text(
              'Em breve',
              style: TextStyle(fontSize: 18, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
