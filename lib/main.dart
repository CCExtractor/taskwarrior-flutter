import 'package:flutter/material.dart';
import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/views/home/home.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart'
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/routes/pageroute.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await init();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(const MyApp());
}

Future init() async {
  Loggy.initLoggy(logPrinter: const PrettyPrinter());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

// ignore: use_key_in_widget_constructors
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskwarrior',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: PageRoutes.home,
      routes: {
        PageRoutes.home: (context) => HomePage(),
      },
    );
  }
}
