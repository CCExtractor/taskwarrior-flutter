// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

import 'package:url_launcher/url_launcher.dart';

class ManageTaskChampionCreds extends StatelessWidget {
  final TextEditingController _encryptionSecretController =
      TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _ccsyncBackendUrlController = TextEditingController();

  ManageTaskChampionCreds({super.key}) {
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _encryptionSecretController.text =
        prefs.getString('encryptionSecret') ?? '';
    _clientIdController.text = prefs.getString('clientId') ?? '';
    _ccsyncBackendUrlController.text = prefs.getString('championApiUrl') ?? '';
  }

  Future<void> _saveCredentials(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('encryptionSecret', _encryptionSecretController.text);
    await prefs.setString('clientId', _clientIdController.text);
    await prefs.setString('championApiUrl', _ccsyncBackendUrlController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Credentials saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Configure TaskChampion",
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeLarge,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              color: TaskWarriorColors.white,
            ),
            onPressed: () async {
              String url = "https://github.com/its-me-abhishek/ccsync";
              if (!await launchUrl(Uri.parse(url))) {
                throw Exception('Could not launch $url');
              }
            },
          ),
        ],
        leading: BackButton(
          color: TaskWarriorColors.white,
        ),
      ),
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                    controller: _encryptionSecretController,
                    decoration: InputDecoration(
                      labelText: 'Encryption Secret',
                      labelStyle: TextStyle(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                    controller: _clientIdController,
                    decoration: InputDecoration(
                      labelText: 'Client ID',
                      labelStyle: TextStyle(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                    controller: _ccsyncBackendUrlController,
                    decoration: InputDecoration(
                      labelText: 'CCSync Backend URL',
                      labelStyle: TextStyle(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _saveCredentials(context),
                    child: const Text('Save Credentials'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tip: Click on the info icon in the top right corner to get your credentials',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
