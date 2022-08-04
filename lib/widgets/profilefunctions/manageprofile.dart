import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class ManageProfile extends StatelessWidget {
  const ManageProfile(
    this.rename,
    this.configure,
    this.export,
    this.copy,
    this.delete, {
    Key? key,
  }) : super(key: key);

  final void Function() rename;
  final void Function() configure;
  final void Function() export;
  final void Function() copy;
  final void Function() delete;

  @override
  Widget build(BuildContext context) {
    var triples = [
      Tuple3(Icons.edit, 'Rename profile', rename),
      Tuple3(Icons.link, 'Configure Taskserver', configure),
      Tuple3(Icons.file_download, 'Export tasks', export),
      Tuple3(Icons.copy, 'Copy config to new profile', copy),
      Tuple3(Icons.delete, 'Delete profile', delete),
    ];

    return ExpansionTile(
      key: const PageStorageKey<String>('manage-profile'),
      title: const Text('Manage selected profile'),
      children: [
        for (var triple in triples)
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(triple.item1),
            ),
            title: Text(triple.item2),
            onTap: triple.item3,
          )
      ],
    );
  }
}
