// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskwarrior/widgets/taskfunctions/datetime_differences.dart';
import 'package:uuid/uuid.dart';

import 'package:taskwarrior/routes/pageroute.dart';
import 'package:taskwarrior/services/notification_services.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/views/profile/profile.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, unused_element, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_build_context_synchronously

import 'package:taskwarrior/model/storage/storage_widget.dart';
// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/model/json/task.dart';
import 'package:taskwarrior/model/storage.dart';

import 'widgets/taskfunctions/urgency.dart';
// import 'package:taskwarrior/model/task.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart'

Future main([List<String> args = const []]) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  Directory? testingDirectory;
  if (args.contains('flutter_driver_test')) {
    testingDirectory = Directory(
      '${Directory.systemTemp.path}/flutter_driver_test/${const Uuid().v1()}',
    )..createSync(recursive: true);
    stdout.writeln(testingDirectory);
    Directory(
      '${testingDirectory.path}/profiles/acae0462-6a34-11e4-8001-002590720087',
    ).createSync(recursive: true);
  }

  runApp(
    FutureBuilder<Directory>(
      future: getApplicationDocumentsDirectory(),
      builder: (context, snapshot) => (snapshot.hasData)
          ? ProfilesWidget(
              baseDirectory: testingDirectory ?? snapshot.data!,
              child: const MyApp(),
            )
          : const Placeholder(),
    ),
  );
}

Future init() async {
  Loggy.initLoggy(logPrinter: const PrettyPrinter());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

// ignore: use_key_in_widget_constructors
class _MyAppState extends State<MyApp> {
  NotificationService notificationService = NotificationService();

  late InheritedStorage storageWidget;

  late Storage storage;
  late final Filters filters;
  List<Task> taskData = [];
  List<ChartSeries> dailyBurnDown = [];
  Directory? baseDirectory;
  List<Task> allData = [];
  bool stopTraver = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      storageWidget = StorageWidget.of(context);
      var currentProfile = ProfilesWidget.of(context).currentProfile;

      getApplicationDocumentsDirectory().then((directory) {
        setState(() {
          baseDirectory = directory;
          storage = Storage(
            Directory('${baseDirectory!.path}/profiles/$currentProfile'),
          );
        });

        ///fetch all data contains all the tasks
        allData = storage.data.allData();

        ///check if allData is not empty
        if (allData.isNotEmpty) {
          print("length of all data is ${allData.length}");
          List<Task> temp = [];
          for (int i = 0; i < allData.length; i++) {
            if (allData[i].status == "pending") {
              if (temp.length < 3) {
                temp.add(allData[i]);
              } else {
                break;
              }
            }
          }

          allData = temp;
          print("length of tem data is ${allData.length}");

          _sendAndUpdate();
        }
      });
    });

    ///sort the data by daily burn down

    notificationService.initiliazeNotification();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  Future<void> _sendData() async {
    try {
      for (int i = 0; i < allData.length && i < 3; i++) {
        String subtitle = 'No Task';

        if (allData[i].modified != null) {
          subtitle = 'Last Modified: ${age(allData[i].modified!)}';
        } else if (allData[i].start != null) {
          subtitle = 'Last Modified: ${age(allData[i].start!)}';
        }

        if (allData[i].due != null) {
          subtitle += ' | Due: ${when(allData[i].due!)}';
        } else {
          subtitle += ' | Due: -';
        }

        subtitle = subtitle.replaceAll(RegExp(r' +'), ' ') +
            formatUrgency(urgency(allData[i]));

        await HomeWidget.saveWidgetData<String>('title${i + 1}',
            '${allData[i].id == 0 ? "#" : allData[i].id}. ${allData[i].description}');
        await HomeWidget.saveWidgetData<String>('subtitle${i + 1}', subtitle);
      }

      // If there is no data in allData, set "No Data" for all three slots.
      for (int i = allData.length; i < 3; i++) {
        await HomeWidget.saveWidgetData<String>('title${i + 1}', 'No Task');
        await HomeWidget.saveWidgetData<String>('subtitle${i + 1}', '');
      }
    } catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) => AlertDialog(
                title: const Text('App started from HomeScreenWidget'),
                content: Text('Here is the URI: $uri'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskwarrior',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Palette.kToDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: PageRoutes.home,
      routes: {
        PageRoutes.home: (context) => HomePage(),
        PageRoutes.profile: (context) => const ProfilePage(),
      },
    );
  }
}
