import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);  // Access the current theme

    // Get current Firebase user
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? "User";

    // Format the user name nicely from the email
    final userName = userEmail
        .split('@')[0]
        .replaceAll(RegExp(r'[0-9]'), '')
        .replaceAll(RegExp(r'[._]'), ' ')
        .split(' ')
        .map((str) => str.isNotEmpty
        ? '${str[0].toUpperCase()}${str.substring(1)}'
        : '')
        .join(' ');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Neuro Gambling Scanner",
          style: GoogleFonts.merriweather(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        // Removed the back arrow button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section with user's name
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: theme.cardColor,
                  radius: 22,
                  child: Icon(
                    Icons.person,
                    size: 26,
                    color: theme.iconTheme.color,
                  ),
                ),
                Text(
                  "  Hello, $userName!",
                  style: GoogleFonts.merriweather(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),

            // Navigation Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildNavButton(context, "Predict Your Gambling Risk", Icons.upload_file, Colors.blue, "/file_upload"),
                  _buildNavButton(context, "User Help and Guidelines", Icons.bar_chart, Colors.blue, "/guidelines"),
                  _buildNavButton(context, "Risk Analysis History", Icons.analytics, Colors.red, "/risk_analysis"),
                  _buildNavButton(context, "Interventions History", Icons.psychology, Colors.green, "/interventionHistory"),
                  _buildNavButton(context, "Education Resources", Icons.school, Colors.orange, "/education"),
                  _buildNavButton(context, "Personal Assessment", Icons.psychology_alt, Colors.purple, "/assessment"),
                  _buildNavButton(context, "Setting", Icons.settings, Colors.red, "/settings",),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigation Button Widget
  Widget _buildNavButton(BuildContext context, String title, IconData icon, Color color, String route) {
    final theme = Theme.of(context); // Get the current theme

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        padding: EdgeInsets.all(16),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
