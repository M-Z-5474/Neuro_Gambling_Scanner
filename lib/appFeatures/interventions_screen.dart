import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:html' as html;

class InterventionScreen extends StatelessWidget {
  final int riskLevel;

  InterventionScreen({required this.riskLevel});

  late final String title;
  late final String content;

  void _initializeContent() {
    switch (riskLevel) {
      case 0:
        title = "🟢 Low Risk";
        content = '''🎯 **Purpose**: Maintain healthy habits and prevent relapse.

📘 **Educational Resources**
• Understanding Gambling Addiction  
• Early Warning Signs  
• Brain Activity & Urges  
• [Responsible Gambling Guide](#)

💡 **Preventive Tips**
• Avoid high-risk environments  
• Limit cash on hand  
• Share goals with trusted contacts  

📊 **Track & Monitor**
• Daily check-in slider (urge levels: 0–10)  
• Weekly log & reflection  
• Daily motivational quote  

🌟 **Encouragement**
“You’re doing great. Stay consistent, stay informed, and keep control in your hands.”''';
        break;
      case 1:
        title = "🟠 Medium Risk";
        content = '''🎯 **Purpose**: Promote behavioral awareness and prevent escalation.

📝 **Journaling Prompt**
“What situations or emotions triggered gambling thoughts today?”

💭 **Reflection Questions**
• How did you handle the urge?  
• What else could you try next time?

🧠 **Decision-Making Challenge**
“If you gamble today and lose, what might you miss out on tomorrow?”

❓ **Mini Quiz**
“Name 3 consequences of continued gambling behavior.”

⏰ **Reminder Tools**
• Phone alarms: “You’re stronger than the urge.”  
• Sticky notes in wallet/card slots

🧡 **Encouragement**
“You’re self-aware, and that’s powerful. One mindful choice at a time can change your future.”''';
        break;
      case 2:
        title = "🔴 High Risk";
        content = '''🎯 **Purpose**: Provide urgent support for potential gambling addiction.

📞 **Emergency Support**
• 🇵🇰 Pakistan: 042-35761999 (Will Addict Rehab Center, Lahore)  
• 🌐 [Gamblers Anonymous](https://www.gamblersanonymous.org)  
• 📧 support@addictionhelpline.com

📘 **Daily CBT Exercise**
*Thought Diary Prompt:*  
“What triggered your urge to gamble today? What were you feeling and thinking?”

*Cognitive Reframe:*  
“What would a supportive friend say to you right now?”

🧘 **Breathing & Grounding Techniques**
*4-7-8 Breathing:*  
Inhale 4s → Hold 7s → Exhale 8s (Repeat 3x)

*5-4-3-2-1 Grounding:*  
• 5 things you see  
• 4 things you feel  
• 3 things you hear  
• 2 things you smell  
• 1 thing you taste

🔒 **Restriction Tools**
• Set screen time limits for gambling apps  
• Ask a trusted friend to block sites  
• Install apps like *BetBlocker* or *Gamban*

💪 **Motivational Message**
“Recovery is possible. You’ve taken the first step by using this app. Progress begins today.”''';
        break;
      default:
        title = "Unknown";
        content = "Invalid risk level.";
    }
  }

  Future<void> _downloadIntervention(BuildContext context) async {
    final resultText = '''
📄 Recommended Interventions

Risk Level: $title

$content
''';

    if (kIsWeb) {
      final bytes = utf8.encode(resultText);
      final blob = html.Blob([Uint8List.fromList(bytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "intervention_recommendation.txt")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getExternalStorageDirectory();
      final path = '${directory!.path}/intervention_recommendation.txt';
      final file = io.File(path);
      await file.writeAsString(resultText);
      Share.shareFiles([path], text: 'Here is your intervention recommendation');
    }
  }

  Future<void> _saveInterventionLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('intervention_history') ?? [];
    final entry = {
      'riskLevel': title,
      'recommendation': content,
      'timestamp': DateTime.now().toIso8601String()
    };
    history.add(jsonEncode(entry));
    await prefs.setStringList('intervention_history', history);
  }

  @override
  Widget build(BuildContext context) {
    _initializeContent(); // set title and content

    return Scaffold(
      appBar: AppBar(title: Text("Recovery Strategies")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildRiskSection(context, title, content),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text("Download Recommendation"),
              onPressed: () => _downloadIntervention(context),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save to History"),
              onPressed: _saveInterventionLocally,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskSection(BuildContext context, String title, String details) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getRiskColor(title),
              ),
            ),
            SizedBox(height: 10),
            Text(details, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    if (riskLevel.contains("🟢")) return Colors.green;
    if (riskLevel.contains("🟠")) return Colors.orange;
    if (riskLevel.contains("🔴")) return Colors.red;
    return Colors.black;
  }
}
