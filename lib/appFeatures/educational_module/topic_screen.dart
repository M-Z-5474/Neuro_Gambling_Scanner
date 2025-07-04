import 'package:flutter/material.dart';
import 'education_model.dart';
import 'answers_screen.dart';

class TopicScreen extends StatelessWidget {
  final EducationCategory category;

  const TopicScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: category.topics.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(category.topics[index].question),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswerScreen(topic: category.topics[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
