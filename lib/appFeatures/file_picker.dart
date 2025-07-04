import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neurogambling_scanner/appFeatures/history_screen.dart';
import 'package:neurogambling_scanner/appFeatures/interventions_screen.dart';

// Web-specific imports
import 'dart:html' as html;
import 'dart:io' as io;

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen>
    with SingleTickerProviderStateMixin {
  String predictionResult = '';
  bool isLoading = false;
  String selectedFileName = '';
  String riskLabel = '';
  String recoveryStrategy = '';
  String moodLabel = ''; // Mood label based on risk
  String moodDescription = ''; // Mood description based on risk
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showRiskAlert(int riskLevel) {
    String title;
    String message;

    switch (riskLevel) {
      case 0:
        title = "✅ Low Risk Assessment";
        message = "Great! You're currently at low risk. Still, it's good to stay informed.";
        break;
      case 1:
        title = "⚠️ Medium Risk Detected";
        message = "You're showing signs of developing gambling behavior. Review the strategy below.";
        break;
      case 2:
        title = "🚨 High Risk Alert!";
        message = "You are at high risk of gambling addiction. Immediate intervention is highly recommended!";
        break;
      default:
        title = "❓ Unknown Risk";
        message = "An error occurred while assessing risk.";
    }

    _animationController.forward();

    showDialog(
      context: context,
      builder: (context) => FadeTransition(
        opacity: _fadeInAnimation,
        child: AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK ✅"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InterventionScreen(riskLevel: riskLevel)),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> savePredictionLocally(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('prediction_history') ?? [];
    history.add(jsonEncode(entry));
    await prefs.setStringList('prediction_history', history);
  }

  void updateRecoveryStrategy(int riskLevel) {
    switch (riskLevel) {
      case 0:
        riskLabel = '🟢 Low Risk';
        recoveryStrategy = 'Maintain healthy habits. Avoid triggers and keep a balanced lifestyle.';
        moodLabel = '😊 Calm';
        moodDescription = 'You are feeling calm and in control of your gambling habits.';
        break;
      case 1:
        riskLabel = '🟠 Medium Risk';
        recoveryStrategy = 'Consider self-monitoring tools and seek advice from a counselor.';
        moodLabel = '😟 Stress';
        moodDescription = 'You may feel a bit stressed. It is important to track your habits and manage stress.';
        break;
      case 2:
        riskLabel = '🔴 High Risk';
        recoveryStrategy = 'Immediate professional help is recommended. Consider therapy or support groups.';
        moodLabel = '😞 Depressed';
        moodDescription = 'You might be feeling overwhelmed or hopeless. Seeking help is crucial.';
        break;
      default:
        riskLabel = '❓ Unknown';
        recoveryStrategy = 'An error occurred while determining the recovery strategy.';
        moodLabel = '❓ Unknown Mood';
        moodDescription = 'An error occurred while determining the mood.';
    }
  }

  Future<void> uploadFile() async {
    if (!kIsWeb) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        setState(() {
          predictionResult = 'Storage permission denied';
        });
        return;
      }
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: kIsWeb,
      );

      if (result == null || result.files.single.bytes == null) {
        setState(() {
          predictionResult = 'No file selected.';
          isLoading = false;
        });
        return;
      }

      setState(() {
        selectedFileName = result.files.single.name;
        isLoading = true;
      });

      final fileName = result.files.single.name;

      if (kIsWeb) {
        final fileBytes = result.files.single.bytes!;
        final blob = html.Blob([fileBytes]);
        final webFile = html.File([blob], fileName);
        final formData = html.FormData();
        formData.appendBlob('file', webFile, fileName);
        final request = html.HttpRequest();

        request.open('POST', 'https://flaskapi-production-3732.up.railway.app/predict');
        request.onLoadEnd.listen((event) async {
          if (request.status == 200) {
            final jsonResp = jsonDecode(request.responseText!);
            final prediction = jsonResp['predictions'][0];
            updateRecoveryStrategy(prediction);

            showRiskAlert(prediction); // Show alert for all risk levels

            await savePredictionLocally({
              'file': selectedFileName,
              'prediction': prediction.toString(),
              'riskLabel': riskLabel,
              'strategy': recoveryStrategy,
              'moodLabel': moodLabel,
              'moodDescription': moodDescription,
              'timestamp': DateTime.now().toIso8601String(),
            });

            setState(() {
              predictionResult = prediction.toString();
              isLoading = false;
            });
          } else {
            setState(() {
              predictionResult = 'Error ${request.status}';
              isLoading = false;
            });
          }
        });

        request.send(formData);
      } else {
        final path = result.files.single.path!;
        final file = io.File(path);
        final uri = Uri.parse('https://flaskapi-production-3732.up.railway.app/predict');
        final request = http.MultipartRequest('POST', uri);
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
        final response = await request.send();
        final responseBody = await http.Response.fromStream(response);

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(responseBody.body);
          final prediction = jsonResponse["predictions"][0];
          updateRecoveryStrategy(prediction);

          showRiskAlert(prediction); // Show alert for all risk levels

          await savePredictionLocally({
            'file': selectedFileName,
            'prediction': prediction.toString(),
            'riskLabel': riskLabel,
            'strategy': recoveryStrategy,
            'moodLabel': moodLabel,
            'moodDescription': moodDescription,
            'timestamp': DateTime.now().toIso8601String(),
          });

          setState(() {
            predictionResult = prediction.toString();
            isLoading = false;
          });
        } else {
          setState(() {
            predictionResult = 'Server Error ${response.statusCode}';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        predictionResult = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import Dataset")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RiskHistoryScreen()),
                  );
                },
                child: Text(
                  "History",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : uploadFile,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Choose & Upload Dataset"),
            ),
            SizedBox(height: 20),
            if (selectedFileName.isNotEmpty) Text("📁 Selected File: $selectedFileName"),
            if (predictionResult.isNotEmpty) ...[
              SizedBox(height: 20),
              Text("📊 Prediction: $predictionResult"),
              SizedBox(height: 10),
              Text("🧩 Risk Assessment: $riskLabel", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("🛠 Recovery Strategy:\n$recoveryStrategy"),
              SizedBox(height: 10),
              Text("😊 Mood: $moodLabel", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("💬 Mood Description: $moodDescription"),
            ],
          ],
        ),
      ),
    );
  }
}
