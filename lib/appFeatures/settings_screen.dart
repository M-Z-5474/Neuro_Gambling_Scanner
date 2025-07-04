import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:neurogambling_scanner/theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _errorMessage = "";
  bool _isPasswordChangeMode = false;

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> _updatePassword(BuildContext context) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        String newPassword = _newPasswordController.text;
        await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
        setState(() {
          _errorMessage = "Password updated successfully.";
          _isPasswordChangeMode = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error updating password: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Unknown';

    final name = email.split('@')[0]
        .replaceAll(RegExp(r'[0-9]'), '')
        .replaceAll(RegExp(r'[._]'), ' ')
        .split(' ')
        .map((str) => str.isNotEmpty
        ? '${str[0].toUpperCase()}${str.substring(1)}'
        : '')
        .join(' ');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Color(0xFF448AFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Dark Mode Toggle
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
            ),

            const Divider(),

            // Change Password Section
            if (!_isPasswordChangeMode)
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () {
                  setState(() {
                    _isPasswordChangeMode = true;
                  });
                },
              ),

            if (_isPasswordChangeMode) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _newPasswordController,
                    decoration:
                    const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a new password.";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters.";
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Password must contain at least one uppercase letter.";
                      }
                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return "Password must contain at least one special character.";
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return "Password must contain at least one number.";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: ElevatedButton(
                  onPressed: () => _updatePassword(context),
                  child: const Text('Save New Password'),
                ),
              ),
            ],

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
