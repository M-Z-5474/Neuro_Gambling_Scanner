import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // ✅ Import this package
import 'education_model.dart';

class AnswerScreen extends StatelessWidget {
  final EducationTopic topic;

  const AnswerScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.question)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // ✅ Allows scrolling for long text
          child: MarkdownBody(
            data: topic.answer, // ✅ This will render bold text, lists, etc.
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 16), // ✅ Ensures readable text
            ),
          ),
        ),
      ),
    );
  }
}
