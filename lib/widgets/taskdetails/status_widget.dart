import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget(
      {required this.name,
      required this.value,
      required this.callback,
      Key? key})
      : super(key: key);

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                '${'$name:'.padRight(13)}$value',
              ),
            ],
          ),
        ),
        onTap: () {
          switch (value) {
            case 'pending':
              return callback('completed');
            case 'completed':
              return callback('deleted');
            case 'deleted':
              return callback('pending');
          }
        },
      ),
    );
  }
}
