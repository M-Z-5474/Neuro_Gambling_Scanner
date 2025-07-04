import 'package:flutter/material.dart';

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Help & Guidelines"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection("📱 App Introduction",
              "Neuro Gambling Scanner helps you detect risky gambling behaviors using AI. "
                  "It provides insights, risk predictions, and personalized interventions."),

          _buildSection("🧠 How to Use the App",
              "1. Upload brain scan or relevant data from the File Upload section.\n"
                  "2. Wait for the AI to analyze and predict your risk level.\n"
                  "3. View your Risk History and track changes over time.\n"
                  "4. Follow cognitive-behavioral tips from the Recommendations screen."),

          _buildSection("📊 Understanding Risk Levels",
              "• Low Risk: No significant gambling behavior detected.\n"
                  "• Medium Risk: Moderate signs of gambling reactivity.\n"
                  "• High Risk: Strong signs of problem gambling. Immediate action recommended."),

          _buildSection("❓ Frequently Asked Questions",
                 "Q: Is my data private?\n"
                  "A: Yes, your data is processed securely and only stored in your account.\n\n"

                  "Q: Can I download results?\n"
                  "A: Yes, you can export reports  from the Recommendation screen.\n\n"

                  "Q: How accurate are the AI predictions?\n"
                  "A: The AI is trained on behavioral and brain reactivity data. While it’s quite accurate, it's not a substitute for professional advice.\n\n"

                  "Q: Can I use the app offline?\n"
                  "A: Some features like viewing saved reports work offline, but uploading data and getting AI predictions requires an internet connection.\n\n"

                  "Q: Is there any cost to use the app?\n"
                  "A: Currently, the app is free to use for educational and awareness purposes."),

        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
