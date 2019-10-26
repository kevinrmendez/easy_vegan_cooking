import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  final bool share;
  final bool save;

  final bool blackScreen;
  final Function callback;
  final List recipes;
  final List shoppingCart;

  AppState(
      {this.save,
      this.callback,
      this.share,
      this.blackScreen,
      this.recipes,
      this.shoppingCart,
      Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppState of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppState);
}
