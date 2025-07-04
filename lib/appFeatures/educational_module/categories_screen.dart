import 'package:flutter/material.dart';
import 'education_data.dart';  // ✅ Import education data
import 'topic_screen.dart';


class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Education Topics")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: educationCategories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Icon(educationCategories[index].icon, color: Colors.deepPurple, size: 30), // ✅ Show icons
              title: Text(
                educationCategories[index].title,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicScreen(category: educationCategories[index]),
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
