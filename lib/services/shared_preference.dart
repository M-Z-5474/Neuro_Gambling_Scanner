import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePredictionLocally(Map<String, dynamic> entry) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('prediction_history') ?? [];
  history.add(jsonEncode(entry));
  await prefs.setStringList('prediction_history', history);
}

Future<List<Map<String, dynamic>>> loadPredictionHistory() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('prediction_history') ?? [];
  return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
}
