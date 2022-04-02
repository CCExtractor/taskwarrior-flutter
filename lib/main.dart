import 'package:flutter/material.dart';
import 'package:taskwarrior/views/home/home.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';import 'package:pathlaws/views/user/profile.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/routes/pageroute.dart';

void main() async {
  await init();
  runApp(MyApp());
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
