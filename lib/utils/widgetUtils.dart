import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import '../main.dart';

class WidgetUtils {
  static Widget boldTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        capitalize(text),
        style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24,
          // color: AccentColor
        ),
      ),
    );
  }

  static Widget recipeTitle({String text = "", BuildContext context}) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
                padding: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width * .7,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )),
          ),
        ],
      ),
    );
  }

  static showSnackBar({BuildContext context, String message, Function onTap}) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content: GestureDetector(onTap: onTap, child: Text(message)),
      backgroundColor: AccentColor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static PreferredSizeWidget appBar({String title, Color iconColor}) {
    return AppBar(
      title: Text(capitalize(title)),
      iconTheme: IconThemeData(color: iconColor),
    );
  }
}
