import 'package:flutter/material.dart';
import 'package:easy_vegan_cooking/components/horizontalList/horizontalCategoryList.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';

class HorizontalCategory extends StatelessWidget {
  final String category;
  final int listSize;
  HorizontalCategory({this.category, this.listSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          WidgetUtils.boldTitle(category),
          HorizontalCategoryList(
              category: this.category, listSize: this.listSize)
        ],
      ),
    );
  }
}
