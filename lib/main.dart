import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'appFeatures/home_screen.dart';
import 'appFeatures/history_screen.dart';
import 'appFeatures/guidelines_screen.dart';
import 'appFeatures/educational_module/categories_screen.dart';
import 'appFeatures/settings_screen.dart';
import 'appFeatures/file_picker.dart';
import 'appFeatures/intervention_history.dart';
import 'appFeatures/personal_assessment.dart';
import 'theme/theme_provider.dart'; // Import the ThemeProvider



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(), // Provide ThemeProvider here
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Neuro Gambling Scanner',
            theme: themeProvider.themeData, // Use theme from ThemeProvider
            initialRoute: '/',  // Start from Splash Screen
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => HomeScreen(),
              '/file_upload': (context) => FileUploadScreen(),
              '/risk_analysis': (context) => RiskHistoryScreen(),
              '/interventionHistory': (context) => InterventionHistoryScreen(),
              '/education': (context) => const CategoriesScreen(),
              '/assessment': (context) =>     PersonalAssessmentScreen(),
              '/guidelines': (context) => const GuidelinesScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
