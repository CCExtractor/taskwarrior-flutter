import 'package:flutter/material.dart';

class TaskDetailsTableUI extends StatelessWidget {
  final String name;
  final dynamic value;
  TaskDetailsTableUI({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(height);

    return Row(
      children: [
        Text(
          '$name:',
          style: TextStyle(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            child: Container(
              width: width - (_textSize(name, TextStyle()).width) - 85,
              height: height-746,
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Text(
                  '$value',
                  style: TextStyle(
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Size _textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
