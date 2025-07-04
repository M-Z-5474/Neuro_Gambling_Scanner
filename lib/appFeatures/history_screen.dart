import 'package:flutter/material.dart';
import 'package:neurogambling_scanner/services/shared_preference.dart';
class RiskHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prediction History")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadPredictionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No history found."));
          }

          final history = snapshot.data!;
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text("📁 ${item['file']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📊 Prediction: ${item['prediction']}"),
                      Text("🧩 Risk: ${item['riskLabel']}"),
                      Text("🕒 Time: ${item['timestamp']}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
