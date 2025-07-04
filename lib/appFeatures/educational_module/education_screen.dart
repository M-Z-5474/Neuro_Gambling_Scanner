import 'package:flutter/material.dart';
import 'education_data.dart';  // ✅ Import education data


class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Education Topics"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: educationCategories.length,
          itemBuilder: (context, index) {
            final category = educationCategories[index];
            return GestureDetector(
              onTap: () {
                // Navigate to details
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(category.icon, color: Colors.deepPurple, size: 30),
                  title: Text(
                    category.title,
                    style: TextStyle(fontSize: 14, ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

