// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskwarrior/services/notification_services.dart';
import 'package:taskwarrior/views/profile/profile.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';
import 'package:flutter/material.dart';
// import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/views/home/home.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart'
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/routes/pageroute.dart';

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
  @override
  void initState() {
    super.initState();

    notificationService.initiliazeNotification();

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
