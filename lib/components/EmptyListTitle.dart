import 'package:flutter/material.dart';

class EmptyListTitle extends StatelessWidget {
  final String title;
  final String content;
  EmptyListTitle(this.title, this.content);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
