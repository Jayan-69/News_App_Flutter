import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';  // Import main.dart to access MyApp

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load the settings for dark mode from SharedPreferences
  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // Save the settings to SharedPreferences
  _saveSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SwitchListTile(
        title: Text('Dark Mode'),
        value: isDarkMode,
        onChanged: (value) {
          setState(() {
            isDarkMode = value;
            _saveSettings(value);  // Save the setting
            // Switch theme mode immediately after saving the setting
            if (value) {
              // Applying dark mode
              MyApp.of(context)?.setDarkMode();
            } else {
              // Applying light mode
              MyApp.of(context)?.setLightMode();
            }
          });
        },
      ),
    );
  }
}
