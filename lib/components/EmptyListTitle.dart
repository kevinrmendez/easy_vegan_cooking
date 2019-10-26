import 'package:flutter/material.dart';

class EmptyListTitle extends StatelessWidget {
  final String text;
  EmptyListTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}
