import 'package:flutter/material.dart';

import 'package:easy_vegan_cooking/components/horizontalList/horizontalNewRecipesList.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';

class HorizontalNewRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          WidgetUtils.boldTitle('New Recipes'),
          HorizontalNewRecipesList()
        ],
      ),
    );
  }
}
