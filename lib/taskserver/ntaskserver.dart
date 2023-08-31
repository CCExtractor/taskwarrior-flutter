import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';
// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage.dart';
import 'package:taskwarrior/model/storage/client.dart';
import 'package:taskwarrior/model/storage/set_config.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/widgets/fingerprint.dart';
import 'package:taskwarrior/widgets/home_paths.dart' as rc;
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/taskdetails.dart';
import 'package:taskwarrior/widgets/taskserver.dart';

class ManageTaskServer extends StatefulWidget {
  const ManageTaskServer({Key? key}) : super(key: key);

  @override
  State<ManageTaskServer> createState() => _ManageTaskServerState();
}

class _ManageTaskServerState extends State<ManageTaskServer> {
  late Storage storage;
  Server? server;
  Credentials? credentials;
  bool _value = false;

  bool isTaskDServerActive = true;
  @override
  void initState() {
    super.initState();
    checkAutoSync();
  }

  checkAutoSync() async {
    ///check if auto sync is on or off
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getBool('sync') ?? false;
    });
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
        return const AlertDialog(
          title: Text('Fetching statistics...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Please wait...'),
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
        builder: (context) => AlertDialog(
          scrollable: true,
          title: const Text('Statistics:'),
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
                        style: GoogleFonts.firaMono(),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    } on Exception catch (e, trace) {
      // Dismiss the loading dialog
      Navigator.of(context).pop();

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
    var color =
        AppSettings.isDarkMode ? Colors.white : Palette.kToDark.shade200;
    var tileColor = AppSettings.isDarkMode
        ? const Color.fromARGB(255, 48, 46, 46)
        : const Color.fromARGB(255, 220, 216, 216);
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

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Success: Server or credentials are verified in taskrc file')),
            );
          } else {
            Navigator.pop(context);
            // Handle the case when server or credentials are missing in the Taskrc object
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Error: Server or credentials are missing in taskrc file')),
            );
          }
        } else {
          Navigator.pop(context);

          // Handle the case when there is an error reading the taskrc file
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to read taskrc file')),
          );
        }
      }
    }

    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.kToDark.shade200,
        titleSpacing:
            0, // Reduce the spacing between the title and leading/back button
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Configure TaskServer",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              alias ?? profile,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(
                Icons.bug_report,
                color: Colors.white,
              ),
              onPressed: _setConfigurationFromFixtureForDebugging,
            ),
          IconButton(
            icon: const Icon(
              Icons.show_chart,
              color: Colors.white,
            ),
            onPressed: () => _showStatistics(context),
          ),
        ],
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      backgroundColor:
          AppSettings.isDarkMode ? Palette.kToDark.shade200 : Colors.white,
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
                    style: GoogleFonts.firaMono(
                        fontWeight: FontWeight.w500, color: color),
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
                                            style: GoogleFonts.firaMono(
                                              fontWeight: FontWeight.bold,
                                              color: color,
                                            ),
                                          ),
                                          Text(
                                            'Paste the taskrc content or select taskrc file',
                                            style: GoogleFonts.firaMono(
                                              fontWeight: FontWeight.w400,
                                              color: color,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              height: height * 0.15,
                                              child: TextField(
                                                controller:
                                                    taskrcContentController,
                                                maxLines: 8,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                decoration: InputDecoration(
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
                                                  labelStyle:
                                                      GoogleFonts.firaMono(
                                                          color: color),
                                                  labelText:
                                                      'Paste your taskrc contents here',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Or",
                                            style: GoogleFonts.firaMono(
                                                color: color),
                                          ),
                                          FilledButton.tonal(
                                            onPressed: () async {
                                              await setConfig(
                                                storage: storage,
                                                key: 'TASKRC',
                                              );
                                              setState(() {});
                                            },
                                            child: const Text(
                                                'Select TASKRC file'),
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
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            taskrcContentController.text.isEmpty
                                ? "Set TaskRc"
                                : "Taskrc file is verified",
                            style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.w400, color: color),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: AppSettings.isDarkMode
                                  ? const Color.fromARGB(255, 220, 216, 216)
                                  : const Color.fromARGB(255, 48, 46, 46),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: taskrcContentController.text.isNotEmpty
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppSettings.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
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
                            style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.w500, color: color),
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
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  server == null
                                      ? Text(
                                          'Not Configured',
                                          style: GoogleFonts.firaMono(
                                              fontWeight: FontWeight.w400,
                                              color: color),
                                        )
                                      : Text(
                                          '$server',
                                          style: GoogleFonts.firaMono(
                                              fontWeight: FontWeight.w400,
                                              color: color),
                                        ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: AppSettings.isDarkMode
                                          ? const Color.fromARGB(
                                              255, 220, 216, 216)
                                          : const Color.fromARGB(
                                              255, 48, 46, 46),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: server != null
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : Icon(
                                              Icons.chevron_right_rounded,
                                              color: AppSettings.isDarkMode
                                                  ? Colors.black
                                                  : Colors.white,
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
                            style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.w500, color: color),
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
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  credentialsString == null
                                      ? Text(
                                          'Not Configured',
                                          style: GoogleFonts.firaMono(
                                              fontWeight: FontWeight.w400,
                                              color: color),
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
                                              style: GoogleFonts.firaMono(
                                                  fontWeight: FontWeight.w400,
                                                  color: color),
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
                                            ? const Color.fromARGB(
                                                255, 220, 216, 216)
                                            : const Color.fromARGB(
                                                255, 48, 46, 46),
                                        shape: BoxShape.circle,
                                      ),
                                      child: credentials == null
                                          ? Icon(
                                              Icons.chevron_right_rounded,
                                              color: AppSettings.isDarkMode
                                                  ? Colors.black
                                                  : Colors.white,
                                            )
                                          : Icon(
                                              hideKey
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: AppSettings.isDarkMode
                                                  ? Colors.green
                                                  : Colors.green,
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
                    "Configure AutoSync",
                    style: GoogleFonts.firaMono(
                        fontWeight: FontWeight.w500, color: color),
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
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Enable Sync",
                            style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.w400, color: color),
                          ),
                          Switch(
                              splashRadius: 24,
                              thumbIcon: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    );
                                  }
                                  return null;
                                },
                              ),
                              value: _value,
                              onChanged: (bool value) async {
                                setState(() {
                                  _value = !_value;
                                });

                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('sync', _value);
                              }),
                        ],
                      ),
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

class PemWidget extends StatefulWidget {
  const PemWidget(
      {required this.storage,
      required this.pem,
      Key? key,
      required this.optionString,
      required this.listTileTitle})
      : super(key: key);

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
    var color =
        AppSettings.isDarkMode ? Colors.white : Palette.kToDark.shade200;
    var contents = widget.storage.guiPemFiles.pemContents(widget.pem);
    var name = widget.storage.guiPemFiles.pemFilename(widget.pem);
    String identifier = "";
    try {
      identifier = fingerprint(contents!).toUpperCase();
    } catch (e) {
      debugPrint(e.toString());
    }

    var tileColor = AppSettings.isDarkMode
        ? const Color.fromARGB(255, 48, 46, 46)
        : const Color.fromARGB(255, 220, 216, 216);

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
            style:
                GoogleFonts.firaMono(fontWeight: FontWeight.w500, color: color),
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
                border: Border.all(color: Colors.grey.shade300),
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
                            style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.w400, color: color),
                          ),
                          Text(
                            widget.pem == 'taskd.key'
                                ? name != null
                                    ? "private.key.pem"
                                    : ""
                                : identifier,
                            style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.w400, color: color),
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
                          ? const Color.fromARGB(255, 220, 216, 216)
                          : const Color.fromARGB(255, 48, 46, 46),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: name == null
                          ? Icon(
                              Icons.chevron_right_rounded,
                              color: AppSettings.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : const Icon(
                              Icons.check,
                              color: Colors.green,
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
