import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taskwarrior/app/utils/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/about_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AboutPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AboutPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
      title: Text(
        'About',
        style: GoogleFonts.poppins(color: TaskWarriorColors.white),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.chevron_left,
          color: TaskWarriorColors.white,
        ),
      ),
    );
  }

 @override
  Size get preferredSize => AppBar().preferredSize;
}
