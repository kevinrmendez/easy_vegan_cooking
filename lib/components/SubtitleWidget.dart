import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {
  final String text;
  SubtitleWidget(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}
