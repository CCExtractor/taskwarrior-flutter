import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/config/taskwarriorfonts.dart';
import 'package:taskwarrior/utility/utilities.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';
// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage.dart';
import 'package:taskwarrior/model/storage/client.dart';
import 'package:taskwarrior/model/storage/set_config.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/widgets/fingerprint.dart';
import 'package:taskwarrior/widgets/home_paths.dart' as rc;
import 'package:taskwarrior/widgets/taskdetails.dart';
import 'package:taskwarrior/widgets/taskserver.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageTaskServer extends StatefulWidget {
  const ManageTaskServer({super.key});

  @override
  State<ManageTaskServer> createState() => _ManageTaskServerState();
}

class _ManageTaskServerState extends State<ManageTaskServer> {
  late Storage storage;
  Server? server;
  Credentials? credentials;

  bool isTaskDServerActive = true;
  @override
  void initState() {
    super.initState();
  }

  bool hideKey = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storage = StorageWidget.of(context).storage;
  }

  Future<void> _setConfigurationFromFixtureForDebugging() async {
    var contents = await rootBundle.loadString('assets/.taskrc');
    rc.Taskrc(storage.home.home).addTaskrc(contents);
    server = Taskrc.fromString(contents).server;
    credentials = Taskrc.fromString(contents).credentials;
    for (var entry in {
      'taskd.certificate': '.task/first_last.cert.pem',
      'taskd.key': '.task/first_last.key.pem',
      'taskd.ca': '.task/ca.cert.pem',
      // 'server.cert': '.task/server.cert.pem',
    }.entries) {
      var contents = await rootBundle.loadString('assets/${entry.value}');
      storage.guiPemFiles.addPemFile(
        key: entry.key,
        contents: contents,
        name: entry.value.split('/').last,
      );
    }
    setState(() {});
  }

  ///fetch statistics from the taskserver
  Future<void> _showStatistics(BuildContext context) async {
    ///show loading dialog
    ///while the statistics are being fetched

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Utils.showAlertDialog(
          title: Text(
            'Fetching statistics...',
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Please wait...',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Fetch statistics header from storage
      var header = await storage.home.statistics(await client());

      // Determine the maximum key length for formatting purposes
      var maxKeyLength =
          header.keys.map<int>((key) => (key as String).length).reduce(max);

      // Dismiss the loading dialog
      Navigator.of(context).pop();

      // Show statistics in a dialog
      await showDialog(
        context: context,
        builder: (context) => Utils.showAlertDialog(
          scrollable: true,
          title: Text(
            'Statistics:',
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display each key-value pair in the statistics header
                    for (var key in header.keys.toList())
                      Text(
                        '${'$key:'.padRight(maxKeyLength + 1)} ${header[key]}',
                        style: TextStyle(
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.white
                              : TaskWarriorColors.black,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppSettings.isDarkMode
                      ? TaskWarriorColors.kLightSecondaryBackgroundColor
                      : TaskWarriorColors.ksecondaryBackgroundColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Ok',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.black
                      : TaskWarriorColors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } on Exception catch (e, trace) {
      // Dismiss the loading dialog
      Navigator.of(context).pop();

      //Displaying Error message.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            trace.toString().startsWith("#0")
                ? "Please set up your TaskServer."
                : e.toString(),
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.kprimaryTextColor
                  : TaskWarriorColors.kLightPrimaryTextColor,
            ),
          ),
          backgroundColor: AppSettings.isDarkMode
              ? TaskWarriorColors.ksecondaryBackgroundColor
              : TaskWarriorColors.kLightSecondaryBackgroundColor,
          duration: const Duration(seconds: 2)));
      // Log the error and trace
      logError(e, trace);
      // Refresh the state of ProfilesWidget
      ProfilesWidget.of(context).setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var profile = storage.profile.uri.pathSegments.lastWhere(
      (segment) => segment.isNotEmpty,
    );
    final TextEditingController taskrcContentController =
        TextEditingController();
    Server? server;
    Credentials? credentials;

    var alias = ProfilesWidget.of(context).profilesMap[profile];

    var contents = rc.Taskrc(storage.home.home).readTaskrc();
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }
    var tileColor = AppSettings.isDarkMode
        ? TaskWarriorColors.ksecondaryBackgroundColor
        : TaskWarriorColors.kLightSecondaryBackgroundColor;
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }

    String? credentialsString;
    if (credentials != null) {
      String key;
      if (hideKey) {
        key = credentials.key.replaceAll(RegExp(r'[0-9a-f]'), '*');
      } else {
        key = credentials.key;
      }

      credentialsString = '${credentials.org}/${credentials.user}/$key';

      if (credentialsString.isNotEmpty && server.toString().isNotEmpty) {
        //print(credentialsString);
        taskrcContentController.text =
            "taskd.server=$server\ntaskd.credentials=${credentials.org}/${credentials.user}/$key";

        setState(() {
          isTaskDServerActive = false;
        });
      }
    }

    /// The [setConfig] function is used to set the configuration of the TaskServer from the clipboard
    void setContent() async {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      taskrcContentController.text = clipboardData?.text ?? '';

      // Check if the clipboard data is not empty
      if (taskrcContentController.text.isNotEmpty) {
        // Add the clipboard data to the taskrc file
        storage.taskrc.addTaskrc(taskrcContentController.text);

        // Read the contents of the taskrc file
        var contents = rc.Taskrc(storage.home.home).readTaskrc();

        // Check if the contents were successfully read
        if (contents != null) {
          // Parse the contents into a Taskrc object
          var taskrc = Taskrc.fromString(contents);

          // Check if the server and credentials are present in the Taskrc object
          if (taskrc.server != null && taskrc.credentials != null) {
            // Update the server and credentials variables
            setState(() {
              server = taskrc.server;
              credentials = taskrc.credentials;
            });
            // Handle the case when server or credentials are missing in the Taskrc object
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Success: Server or credentials are verified in taskrc file',
                  style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                ),
                backgroundColor: AppSettings.isDarkMode
                    ? TaskWarriorColors.ksecondaryBackgroundColor
                    : TaskWarriorColors.kLightSecondaryBackgroundColor,
                duration: const Duration(seconds: 2)));
          } else {
            Navigator.pop(context);
            // Handle the case when server or credentials are missing in the Taskrc object
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Error: Server or credentials are missing in taskrc file',
                  style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                ),
                backgroundColor: AppSettings.isDarkMode
                    ? TaskWarriorColors.ksecondaryBackgroundColor
                    : TaskWarriorColors.kLightSecondaryBackgroundColor,
                duration: const Duration(seconds: 2)));
          }
        } else {
          Navigator.pop(context);

          // Handle the case when there is an error reading the taskrc file
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Error: Failed to read taskrc file',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              backgroundColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.ksecondaryBackgroundColor
                  : TaskWarriorColors.kLightSecondaryBackgroundColor,
              duration: const Duration(seconds: 2)));
        }
      }
    }

    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        titleSpacing:
            0, // Reduce the spacing between the title and leading/back button
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Configure TaskServer",
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeLarge,
              ),
            ),
            Text(
              alias ?? profile,
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeSmall,
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
              String url =
                  "https://github.com/CCExtractor/taskwarrior-flutter?tab=readme-ov-file#taskwarrior-mobile-app";
              if (!await launchUrl(Uri.parse(url))) {
                throw Exception('Could not launch $url');
              }
            },
          ),
          if (kDebugMode)
            IconButton(
              icon: Icon(
                Icons.bug_report,
                color: TaskWarriorColors.white,
              ),
              onPressed: _setConfigurationFromFixtureForDebugging,
            ),
          IconButton(
            icon: Icon(
              Icons.show_chart,
              color: TaskWarriorColors.white,
            ),
            onPressed: () => _showStatistics(context),
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
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Configure TASKRC",
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              // double heightOfModalBottomSheet =
                              //     MediaQuery.of(context).size.height * 0.6;

                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Wrap(
                                  children: [
                                    Container(
                                      // height: heightOfModalBottomSheet,
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: tileColor,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(16.0)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Configure TaskRc',
                                            style: TextStyle(
                                              fontWeight: TaskWarriorFonts.bold,
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.white
                                                  : TaskWarriorColors.black,
                                            ),
                                          ),
                                          Text(
                                            'Paste the taskrc content or select taskrc file',
                                            style: TextStyle(
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.white
                                                  : TaskWarriorColors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              height: height * 0.15,
                                              child: TextField(
                                                style: TextStyle(
                                                    color:
                                                        AppSettings.isDarkMode
                                                            ? TaskWarriorColors
                                                                .white
                                                            : TaskWarriorColors
                                                                .black),
                                                controller:
                                                    taskrcContentController,
                                                maxLines: 8,
                                                decoration: InputDecoration(
                                                    counterStyle: TextStyle(
                                                        color: AppSettings.isDarkMode
                                                            ? TaskWarriorColors
                                                                .white
                                                            : TaskWarriorColors
                                                                .black),
                                                    suffixIconConstraints:
                                                        const BoxConstraints(
                                                      maxHeight: 24,
                                                      maxWidth: 24,
                                                    ),
                                                    isDense: true,
                                                    suffix: IconButton(
                                                      onPressed: () async {
                                                        setContent();
                                                      },
                                                      icon: const Icon(
                                                          Icons.content_paste),
                                                    ),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelStyle: GoogleFonts
                                                        .poppins(
                                                            color: AppSettings
                                                                    .isDarkMode
                                                                ? TaskWarriorColors
                                                                    .white
                                                                : TaskWarriorColors
                                                                    .black),
                                                    labelText:
                                                        'Paste your taskrc contents here'),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Or",
                                            style: TextStyle(
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.white
                                                  : TaskWarriorColors.black,
                                            ),
                                          ),
                                          FilledButton.tonal(
                                            style: ButtonStyle(
                                                backgroundColor: AppSettings
                                                        .isDarkMode
                                                    ? WidgetStateProperty.all<
                                                            Color>(
                                                        TaskWarriorColors.black)
                                                    : WidgetStateProperty.all<
                                                            Color>(
                                                        TaskWarriorColors
                                                            .white)),
                                            onPressed: () async {
                                              await setConfig(
                                                storage: storage,
                                                key: 'TASKRC',
                                              );
                                              setState(() {});
                                              Get.back();
                                            },
                                            child: Text(
                                              'Select TASKRC file',
                                              style: TextStyle(
                                                color: AppSettings.isDarkMode
                                                    ? TaskWarriorColors.white
                                                    : TaskWarriorColors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      //   height: MediaQuery.of(context).size.height * 0.05,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: TaskWarriorColors.borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            taskrcContentController.text.isEmpty
                                ? "Set TaskRc"
                                : "Taskrc file is verified",
                            style: TextStyle(
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors
                                      .kLightSecondaryBackgroundColor
                                  : TaskWarriorColors.ksecondaryBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: taskrcContentController.text.isNotEmpty
                                  ? Icon(
                                      Icons.check,
                                      color: TaskWarriorColors.green,
                                    )
                                  : Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppSettings.isDarkMode
                                          ? TaskWarriorColors.black
                                          : TaskWarriorColors.white,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Offstage(
                offstage: isTaskDServerActive,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TaskD Server Info",
                            style: TextStyle(
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              //   height: MediaQuery.of(context).size.height * 0.05,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: tileColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: TaskWarriorColors.borderColor,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  server == null
                                      ? Text(
                                          'Not Configured',
                                          style: TextStyle(
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.white
                                                : TaskWarriorColors.black,
                                          ),
                                        )
                                      : Text(
                                          '$server',
                                          style: TextStyle(
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.white
                                                : TaskWarriorColors.black,
                                          ),
                                        ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: AppSettings.isDarkMode
                                          ? TaskWarriorColors
                                              .kLightSecondaryBackgroundColor
                                          : TaskWarriorColors
                                              .ksecondaryBackgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: server != null
                                          ? Icon(
                                              Icons.check,
                                              color: TaskWarriorColors.green,
                                            )
                                          : Icon(
                                              Icons.chevron_right_rounded,
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.black
                                                  : TaskWarriorColors.white,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TaskD Server Credentials",
                            style: TextStyle(
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              //   height: MediaQuery.of(context).size.height * 0.05,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: tileColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: TaskWarriorColors.borderColor),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  credentialsString == null
                                      ? Text(
                                          'Not Configured',
                                          style: TextStyle(
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.white
                                                : TaskWarriorColors.black,
                                          ),
                                        )
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              credentialsString,
                                              style: TextStyle(
                                                color: AppSettings.isDarkMode
                                                    ? TaskWarriorColors.white
                                                    : TaskWarriorColors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                  GestureDetector(
                                    onTap: () {
                                      hideKey = !hideKey;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: AppSettings.isDarkMode
                                            ? TaskWarriorColors
                                                .kLightPrimaryBackgroundColor
                                            : TaskWarriorColors
                                                .kprimaryBackgroundColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: credentials == null
                                          ? Icon(
                                              Icons.chevron_right_rounded,
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.black
                                                  : TaskWarriorColors.white,
                                            )
                                          : Icon(
                                              hideKey
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.green
                                                  : TaskWarriorColors.green,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            for (var pem in [
              'taskd.certificate',
              'taskd.key',
              'taskd.ca',
              if (StorageWidget.of(context).serverCertExists) 'server.cert',
            ])
              PemWidget(
                storage: storage,
                pem: pem,
                optionString: pem == "taskd.certificate"
                    ? "Configure your certificate"
                    : pem == "taskd.key"
                        ? "Configure TaskServer key"
                        : pem == "taskd.ca"
                            ? "Configure Server Certificate"
                            : "Configure Server Certificate",
                listTileTitle: pem == "taskd.certificate"
                    ? "Select Certificate"
                    : pem == "taskd.key"
                        ? "Select key"
                        : pem == "taskd.ca"
                            ? "Select Certificate"
                            : "Select Certificate",
              ),
          ],
        ),
      ),
    );
  }
}

class PemWidget extends StatefulWidget {
  const PemWidget(
      {required this.storage,
      required this.pem,
      super.key,
      required this.optionString,
      required this.listTileTitle});

  final Storage storage;
  final String pem;
  final String optionString;
  final String listTileTitle;
  @override
  State<PemWidget> createState() => _PemWidgetState();
}

class _PemWidgetState extends State<PemWidget> {
  @override
  Widget build(BuildContext context) {
    var contents = widget.storage.guiPemFiles.pemContents(widget.pem);
    var name = widget.storage.guiPemFiles.pemFilename(widget.pem);
    String identifier = "";
    try {
      if (contents != null) {
        identifier = fingerprint(contents).toUpperCase(); // Null check removed
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    var tileColor = AppSettings.isDarkMode
        ? TaskWarriorColors.ksecondaryBackgroundColor
        : TaskWarriorColors.kLightSecondaryBackgroundColor;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.optionString,
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: (widget.pem == 'server.cert')
                ? () {
                    widget.storage.guiPemFiles.removeServerCert();
                    ProfilesWidget.of(context).setState(
                      () {},
                    );
                    setState(
                      () {},
                    );
                  }
                : () async {
                    await setConfig(
                      storage: widget.storage,
                      key: widget.pem,
                    );
                    setState(
                      () {},
                    );
                  },
            onLongPress: (widget.pem != 'server.cert' && name != null)
                ? () {
                    widget.storage.guiPemFiles.removePemFile(widget.pem);
                    setState(() {});
                  }
                : null,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: TaskWarriorColors.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            name == null
                                ? widget.listTileTitle
                                : (widget.pem == 'server.cert')
                                    ? ''
                                    : "$name = ",
                            style: TextStyle(
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            ),
                          ),
                          Text(
                            widget.pem == 'taskd.key'
                                ? name != null
                                    ? "private.key.pem"
                                    : ""
                                : identifier,
                            style: TextStyle(
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.kLightSecondaryBackgroundColor
                          : TaskWarriorColors.ksecondaryBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: name == null
                          ? Icon(
                              Icons.chevron_right_rounded,
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.black
                                  : TaskWarriorColors.white,
                            )
                          : Icon(
                              Icons.check,
                              color: TaskWarriorColors.green,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
