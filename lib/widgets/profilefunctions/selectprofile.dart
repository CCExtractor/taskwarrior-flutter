import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectProfile extends StatelessWidget {
  const SelectProfile(
    this.currentProfile,
    this.profilesMap,
    this.selectProfile, {
    Key? key,
  }) : super(key: key);

  final String currentProfile;
  final Map profilesMap;
  final void Function(String) selectProfile;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const PageStorageKey<String>('task-list'),
      title: Text('Profile: $currentProfile', overflow: TextOverflow.fade,),
      children: [
        for (var entry in profilesMap.entries)
          SelectProfileListTile(
            currentProfile,
            entry.key,
            () => selectProfile(entry.key),
            entry.value,
          ),
      ],
    );
  }
}

class SelectProfileListTile extends StatelessWidget {
  const SelectProfileListTile(
    this.selectedUuid,
    this.uuid,
    this.select, [
    this.alias,
    Key? key,
  ]) : super(key: key);

  final String selectedUuid;
  final String uuid;
  final void Function() select;
  final String? alias;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Radio<String>(
        value: uuid,
        groupValue: selectedUuid,
        onChanged: (_) => select(),
      ),
      title: SingleChildScrollView(
        key: PageStorageKey<String>('scroll-title-$uuid'),
        scrollDirection: Axis.horizontal,
        child: Text(
          alias ?? '',
          style: GoogleFonts.firaMono(),
        ),
      ),
      subtitle: SingleChildScrollView(
        key: PageStorageKey<String>('scroll-subtitle-$uuid'),
        scrollDirection: Axis.horizontal,
        child: Text(
          uuid,
          style: GoogleFonts.firaMono(),
        ),
      ),
    );
  }
}
