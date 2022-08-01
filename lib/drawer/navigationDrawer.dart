// // ignore_for_file: override_on_non_overriding_member, prefer_const_constructors, file_names

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:taskwarrior/views/home/home.dart';
// import 'package:taskwarrior/widgets/createDrawerHeader.dart';
// import 'package:taskwarrior/widgets/createDrawerBodyItem.dart';
// import 'package:taskwarrior/routes/pageroute.dart';

// class NavigationDrawer extends StatelessWidget {
//   const NavigationDrawer(this.filters, {Key? key}) : super(key: key);
//   final Filters filters;

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ListView(
//         dragStartBehavior: DragStartBehavior.start,
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           createDrawerHeader(),
//           createDrawerBodyItem(
//             icon: Icons.home,
//             text: 'Home',
//             onTap: () =>
//                 Navigator.pushReplacementNamed(context, PageRoutes.home),
//           ),
//         ],
//       ),
//     );
//   }
// }
