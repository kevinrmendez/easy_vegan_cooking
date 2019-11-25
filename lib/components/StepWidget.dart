import 'package:flutter/material.dart';

import '../main.dart';

class StepWidget extends StatefulWidget {
  final String step;
  final int stepNumber;
  const StepWidget({
    this.step,
    this.stepNumber,
    Key key,
  }) : super(key: key);

  @override
  _StepWidgetState createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  bool isChecked;
  @override
  void initState() {
    isChecked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "${widget.stepNumber}",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Flexible(
            child: Container(
              child: Text(
                "${widget.step}",
                // style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          Opacity(
              opacity: isChecked ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check,
                  color: AccentColor,
                ),
              ))
        ],
      )),
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
    );
  }
}
