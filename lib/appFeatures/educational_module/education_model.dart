import 'package:flutter/material.dart';

class EducationCategory {
  final String title;
  final IconData icon; // Added icon field
  final List<EducationTopic> topics;

  EducationCategory({
    required this.title,
    required this.icon,  // Now includes an icon
    required this.topics,
  });
}

class EducationTopic {
  final String question;
  final String answer;

  EducationTopic({
    required this.question,
    required this.answer,
  });
}
