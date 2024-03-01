// ignore_for_file: use_super_parameters

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:taskwarrior/model/storage.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/widgets/taskw.dart';

//import 'package:taskc/storage.dart';

// import 'package:task/task.dart';

class ProfilesWidget extends StatefulWidget {
  const ProfilesWidget({
    Key? key,
    required this.defaultDirectory,
    required this.baseDirectory,
    required this.child,
  }) : super(key: key);

  final Directory defaultDirectory;
  final Directory baseDirectory;
  final Widget child;

  @override
  State<ProfilesWidget> createState() => _ProfilesWidgetState();

  static InheritedProfiles of(BuildContext context) {
    return InheritedModel.inheritFrom<InheritedProfiles>(context)!;
  }
}

class _ProfilesWidgetState extends State<ProfilesWidget> {
  late Directory baseDirectory;
  late Map<String, String?> profilesMap;
  late String currentProfile;

  Profiles get _profiles => Profiles(baseDirectory);

  @override
  void initState() {
    super.initState();
    baseDirectory = widget.baseDirectory;
    _checkProfiles();
    profilesMap = _profiles.profilesMap();
    currentProfile = _profiles.getCurrentProfile()!;
    setState(() {});
  }

  void _checkProfiles() {
    if (_profiles.profilesMap().isEmpty) {
      _profiles.setCurrentProfile(_profiles.addProfile());
    } else if (!_profiles
        .profilesMap()
        .containsKey(_profiles.getCurrentProfile())) {
      _profiles.setCurrentProfile(_profiles.profilesMap().keys.first);
    }
  }

  Directory getDefaultDirectory() {
    return widget.defaultDirectory;
  }

  Directory getBaseDirectory() {
    return baseDirectory;
  }

  void setBaseDirectory(Directory newBaseDirectory) {
    baseDirectory = newBaseDirectory;
    profilesMap = _profiles.profilesMap();
    setState(() {});
  }

  void addProfile() {
    _profiles.addProfile();
    profilesMap = _profiles.profilesMap();
    setState(() {});
  }

  void copyConfigToNewProfile(String profile) {
    _profiles.copyConfigToNewProfile(profile);
    profilesMap = _profiles.profilesMap();
    setState(() {});
  }

  void deleteProfile(String profile) {
    _profiles.deleteProfile(profile);
    _checkProfiles();
    profilesMap = _profiles.profilesMap();
    currentProfile = _profiles.getCurrentProfile()!;
    setState(() {});
  }

  void renameProfile({required String profile, required String? alias}) {
    _profiles.setAlias(profile: profile, alias: alias!);
    profilesMap = _profiles.profilesMap();
    setState(() {});
  }

  void selectProfile(String profile) {
    _profiles.setCurrentProfile(profile);
    currentProfile = _profiles.getCurrentProfile()!;
    setState(() {});
  }

  Storage getStorage(String profile) {
    return _profiles.getStorage(profile);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProfiles(
      getDefaultDirectory: getDefaultDirectory,
      getBaseDirectory: getBaseDirectory,
      setBaseDirectory: setBaseDirectory,
      addProfile: addProfile,
      copyConfigToNewProfile: copyConfigToNewProfile,
      deleteProfile: deleteProfile,
      renameProfile: renameProfile,
      selectProfile: selectProfile,
      currentProfile: currentProfile,
      profilesMap: profilesMap,
      getStorage: getStorage,
      setState: setState,
      child: StorageWidget(
        profile: Directory(
          '${baseDirectory.path}/profiles/$currentProfile',
        ),
        child: widget.child,
      ),
    );
  }
}

class InheritedProfiles extends InheritedModel<String> {
  const InheritedProfiles({
    super.key,
    required this.getDefaultDirectory,
    required this.getBaseDirectory,
    required this.setBaseDirectory,
    required this.addProfile,
    required this.copyConfigToNewProfile,
    required this.deleteProfile,
    required this.renameProfile,
    required this.selectProfile,
    required this.currentProfile,
    required this.profilesMap,
    required this.getStorage,
    required this.setState,
    required child,
  }) : super(child: child);

  final Directory Function() getDefaultDirectory;
  final Directory Function() getBaseDirectory;
  final void Function(Directory) setBaseDirectory;
  final Function() addProfile;
  final Function(String) copyConfigToNewProfile;
  final Function(String) deleteProfile;
  final void Function({
    required String profile,
    required String? alias,
  }) renameProfile;
  final Function(String) selectProfile;
  final String currentProfile;
  final Map<String, String?> profilesMap;
  final Storage Function(String) getStorage;
  final void Function(void Function()) setState;

  @override
  bool updateShouldNotify(InheritedProfiles oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
      InheritedProfiles oldWidget, Set<String> dependencies) {
    return true;
  }
}
