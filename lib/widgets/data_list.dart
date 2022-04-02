// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:pathlaws/services/business_service.dart';
// import 'package:pathlaws/views/articles/articleview.dart';
// import 'package:pathlaws/views/questions/questionview.dart';
// import 'package:pathlaws/views/recentUpdates/recentUpdateView.dart';
// import 'package:pathlaws/views/business/businessView.dart';

class DataList extends StatefulWidget {
  //final List items;
  final String type;

  const DataList({Key? key,/* required this.items,*/ required this.type})
      : super(key: key);
  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  ListTile _buildItemsForListView(BuildContext context, int index) {
    if (widget.type == 'highPriorityTasks') {
      return ListTile(
        title: Text(/*widget.items[index]['title'])*/'High Priority Task'),
      );
    } else if (widget.type == 'lowPriorityTasks') {
      return ListTile(
        title: Text(/*widget.items[index]['title']*/'Low Priority Task'),
      );
    } else {
      return ListTile(
        title: Text(/*widget.items[index]['title']*/'Medium Priority Task'),

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //itemCount: widget.items.length,
      itemCount: 3,
      itemBuilder: _buildItemsForListView,
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );
  }
}
