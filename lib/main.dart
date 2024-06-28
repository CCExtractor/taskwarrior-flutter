// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:taskwarrior/controller/WidgetController.dart';
import 'package:taskwarrior/controller/onboarding_controller.dart';
import 'package:taskwarrior/routes/pageroute.dart';
import 'package:taskwarrior/views/Onboarding/onboarding_screen.dart';
import 'package:taskwarrior/views/profile/profile.dart';
import 'package:taskwarrior/widgets/app_placeholder.dart';
import 'package:uuid/uuid.dart';

import 'package:taskwarrior/services/notification_services.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';

import 'package:taskwarrior/model/storage/storage_widget.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/model/json/task.dart';
import 'package:taskwarrior/model/storage.dart';

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
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(FutureBuilder<List<Directory>>(
          future: getDirectories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ProfilesWidget(
                defaultDirectory: snapshot.data![0],
                baseDirectory: testingDirectory ?? snapshot.data![1],
                child: const MyApp(),
              );
            } else {
              return const AppSetupPlaceholder();
            }
          })));
}

Future<List<Directory>> getDirectories() async {
  Directory defaultDirectory = await getApplicationDocumentsDirectory();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? directory = prefs.getString('baseDirectory');
  Directory baseDirectory =
      (directory != null) ? Directory(directory) : defaultDirectory;
  return [defaultDirectory, baseDirectory];
}

Future init() async {
  Loggy.initLoggy(logPrinter: const PrettyPrinter());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
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

    ///sort the data by daily burn down
    checkForUpdate();
    notificationService.initiliazeNotification();
  }

  Future<void> checkForUpdate() async {
    // print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          // print('update available');
          update();
        }
      });
    }).catchError((e) {
      // print(e.toString());
    });
  }

  void update() async {
    // print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      // print(e.toString());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    WidgetController widgetController = Get.put(WidgetController(context));
    widgetController.fetchAllData();

    return Sizer(builder: ((context, orientation, deviceType) {
      return GetMaterialApp(
        builder: (context, child) {
          return Builder(
            builder: (BuildContext context) {
              return child!;
            },
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Taskwarrior',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Palette.kToDark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // initialRoute: PageRoutes.home,
        routes: {
          PageRoutes.home: (context) => const HomePage(),
          PageRoutes.profile: (context) => const ProfilePage(),
        },

        home: CheckOnboardingStatus(),
      );
    }));
  }
}

class CheckOnboardingStatus extends StatelessWidget {
  final OnboardingController onboardingController =
      Get.put(OnboardingController());

  CheckOnboardingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (onboardingController.hasCompletedOnboarding.value) {
          return const HomePage();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}
