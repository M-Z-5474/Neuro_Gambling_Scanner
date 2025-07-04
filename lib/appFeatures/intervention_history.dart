import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterventionHistoryScreen extends StatefulWidget {
  @override
  _InterventionHistoryScreenState createState() => _InterventionHistoryScreenState();
}

class _InterventionHistoryScreenState extends State<InterventionHistoryScreen> {
  List<Map<String, dynamic>> interventionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('intervention_history') ?? [];

    final decoded = stored.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    setState(() {
      interventionHistory = decoded.reversed.toList(); // latest first
    });
  }

  void _showDetailsDialog(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(entry['riskLevel']),
        content: SingleChildScrollView(
          child: Text(entry['recommendation']),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Intervention History")),
      body: interventionHistory.isEmpty
          ? Center(child: Text("No interventions saved yet."))
          : ListView.builder(
        itemCount: interventionHistory.length,
        itemBuilder: (context, index) {
          final entry = interventionHistory[index];
          return ListTile(
            title: Text(entry['riskLevel']),
            subtitle: Text("Saved on ${entry['timestamp'].toString().split('T')[0]}"),
            trailing: TextButton(
              child: Text("View Details"),
              onPressed: () => _showDetailsDialog(entry),
            ),
          );
        },
      ),
    );
  }
}
