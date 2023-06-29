// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggy/loggy.dart';
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

class ConfigureTaskserverRoute extends StatefulWidget {
  const ConfigureTaskserverRoute([Key? key]) : super(key: key);

  @override
  State<ConfigureTaskserverRoute> createState() =>
      _ConfigureTaskserverRouteState();
}

class _ConfigureTaskserverRouteState extends State<ConfigureTaskserverRoute> {
  late Storage storage;
  Server? server;
  Credentials? credentials;

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
    var alias = ProfilesWidget.of(context).profilesMap[profile];

    var contents = rc.Taskrc(storage.home.home).readTaskrc();
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }
    var color =
        AppSettings.isDarkMode ? Colors.white : Palette.kToDark.shade200;
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
      body: Container(
        color: AppSettings.isDarkMode ? Palette.kToDark.shade200 : Colors.white,
        child: ListView(
          children: [
            TaskrcWidget(storage),
            for (var pem in [
              'taskd.certificate',
              'taskd.key',
              'taskd.ca',
              if (StorageWidget.of(context).serverCertExists) 'server.cert',
            ])
              PemWidget(
                storage: storage,
                pem: pem,
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: color),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    ///Link the TaskServer or the Inther.am documentation
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "I dont know how to configure the TaskServer",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.firaMono(
                        color: color,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PemWidget extends StatefulWidget {
  const PemWidget({required this.storage, required this.pem, Key? key})
      : super(key: key);

  final Storage storage;
  final String pem;

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
    return ListTile(
      textColor: color,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.pem.padRight(17),
                style: GoogleFonts.firaMono(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: (widget.pem == 'server.cert') ? '' : ' = $name',
                style: GoogleFonts.firaMono(
                  color: color,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        // child: Text(
        //   '${widget.pem.padRight(17)}${(widget.pem == 'server.cert') ? '' : ' = $name'}',
        //   style: GoogleFonts.firaMono(),
        // ),
      ),
      subtitle: (key) {
        if (key == 'taskd.key') {
          return null;
        }
        if (contents == null) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              'SHA1: null',
              style: GoogleFonts.firaMono(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }
        try {
          var identifier = fingerprint(contents).toUpperCase();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'SHA1 = ',
                    style: GoogleFonts.firaMono(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: identifier,
                    style: GoogleFonts.firaMono(
                      color: color,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          );
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              '${e.runtimeType}',
              style: GoogleFonts.firaMono(),
            ),
          );
        }
      }(widget.pem),
      onTap: (widget.pem == 'server.cert')
          ? () {
              widget.storage.guiPemFiles.removeServerCert();
              ProfilesWidget.of(context).setState(() {});
              setState(() {});
            }
          : () async {
              await setConfig(storage: widget.storage, key: widget.pem);
              setState(() {});
            },
      onLongPress: (widget.pem != 'server.cert' && name != null)
          ? () {
              widget.storage.guiPemFiles.removePemFile(widget.pem);
              setState(() {});
            }
          : null,
    );
  }
}

class TaskrcWidget extends StatefulWidget {
  const TaskrcWidget(this.storage, {Key? key}) : super(key: key);

  final Storage storage;

  @override
  State<TaskrcWidget> createState() => _TaskrcWidgetState();
}

class _TaskrcWidgetState extends State<TaskrcWidget> {
  final TextEditingController _taskrcContentController =
      TextEditingController();
  bool hideKey = true;

  Storage get storage => widget.storage;

  @override
  Widget build(BuildContext context) {
    var color =
        AppSettings.isDarkMode ? Colors.white : Palette.kToDark.shade200;

    Server? server;
    Credentials? credentials;

    /// The [setConfig] function is used to set the configuration of the TaskServer from the clipboard
    void setContent() async {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      _taskrcContentController.text = clipboardData?.text ?? '';

      // Check if the clipboard data is not empty
      if (_taskrcContentController.text.isNotEmpty) {
        // Add the clipboard data to the taskrc file
        storage.taskrc.addTaskrc(_taskrcContentController.text);

        // Read the contents of the taskrc file
        var contents = rc.Taskrc(widget.storage.home.home).readTaskrc();

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
          } else {
            // Handle the case when server or credentials are missing in the Taskrc object
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Error: Server or credentials missing in taskrc file')),
            );
          }
        } else {
          // Handle the case when there is an error reading the taskrc file
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to read taskrc file')),
          );
        }
      }
    }

    var contents = rc.Taskrc(widget.storage.home.home).readTaskrc();
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }
    String? credentialsString;
    if (credentials != null) {
      String key;
      if (hideKey) {
        key = credentials!.key.replaceAll(RegExp(r'[0-9a-f]'), '*');
      } else {
        key = credentials!.key;
      }

      credentialsString = '${credentials!.org}/${credentials!.user}/$key';

      if (credentialsString.isNotEmpty && server.toString().isNotEmpty) {
        //print(credentialsString);
        _taskrcContentController.text =
            "taskd.server=$server\ntaskd.credentials=${credentials!.org}/${credentials!.user}/$key";
      }
    }
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: height * 0.15,
            child: TextField(
              controller: _taskrcContentController,
              maxLines: 8,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 24,
                  maxWidth: 24,
                ),
                isDense: true,
                suffix: IconButton(
                    onPressed: () async {
                      setContent();
                    },
                    icon: const Icon(Icons.content_paste)),
                border: const OutlineInputBorder(),
                labelStyle: GoogleFonts.firaMono(color: color),
                labelText: 'Paste your taskrc contents here',
              ),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Or",
              style: GoogleFonts.firaMono(color: color),
            )
          ],
        ),
        FilledButton.tonal(
          onPressed: () async {
            await setConfig(
              storage: widget.storage,
              key: 'TASKRC',
            );
            setState(() {});
          },
          child: const Text('Select TASKRC'),
        ),
        // ListTile(
        //   textColor: color,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         'Select TASKRC',
        //         style: GoogleFonts.firaMono(),
        //       ),
        //     ],
        //   ),
        //   onTap: () async {
        //     await setConfig(
        //       storage: widget.storage,
        //       key: 'TASKRC',
        //     );
        //     setState(() {});
        //   },
        // ),
        Divider(
          height: height * 0.05,
        ),
        ListTile(
          textColor: color,
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              'Selected TaskServer Configuration',
              style: GoogleFonts.firaMono(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        ListTile(
            textColor: color,
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'taskd.server      = ',
                      style: GoogleFonts.firaMono(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: '$server',
                      style: GoogleFonts.firaMono(
                        color: color,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: (server == null)
                ? null
                : () async {
                    late String mainDomain;
                    if (server!.address == 'localhost') {
                      mainDomain = server!.address;
                    } else {
                      var parts = server!.address.split('.');
                      var length = parts.length;
                      mainDomain = parts.sublist(length - 2, length).join('.');
                    }

                    ProfilesWidget.of(context).renameProfile(
                      profile: widget.storage.profile.path.split('/').last,
                      alias: mainDomain,
                    );
                  }),
        ListTile(
          textColor: color,
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'taskd.credentials = ',
                    style: GoogleFonts.firaMono(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: '$credentialsString',
                    style: GoogleFonts.firaMono(
                      color: color,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
          trailing: (credentials == null)
              ? null
              : IconButton(
                  icon: Icon(hideKey ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    hideKey = !hideKey;
                    setState(() {});
                  },
                ),
        ),
      ],
    );
  }
}
