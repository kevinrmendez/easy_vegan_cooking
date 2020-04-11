import 'package:easy_vegan_cooking/activity/CartActivity.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../CartModel.dart';
import '../Ingredient.dart';
import '../main.dart';
import 'SubtitleWidget.dart';

class IngredientList extends StatefulWidget {
  final List ingredientData;
  const IngredientList({Key key, this.ingredientData}) : super(key: key);

  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  List<Ingredient> ingredientList = [];
  List<Widget> ingredientsWidget(List<Ingredient> ingredients) {
    List<Widget> list = List();

    ingredientList.forEach((item) {
      var row = Row(
        children: <Widget>[
          Checkbox(
            value: item.isChecked,
            onChanged: (value) {
              setState(() {
                item.isChecked = value;
                if (item.isChecked) {
                  Provider.of<CartModel>(context, listen: false).add(item);
                  WidgetUtils.showSnackBar(
                      context: context,
                      message: 'ingredient added to groceries list',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartActivity()),
                        );
                      });
                } else {
                  Provider.of<CartModel>(context, listen: false).remove(item);
                  WidgetUtils.showSnackBar(
                      context: context,
                      message: 'ingredient removed from groceries list',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartActivity()),
                        );
                      });
                }
              });
            },
          ),
          Flexible(
            // fit: FlexFit.loose,
            child: Container(
              width: MediaQuery.of(context).size.width * .8,
              child: Text(
                item.name,
                // overflow: TextOverflow.visible,
                // style: TextStyle(fontSize: 10),
              ),
            ),
          )
        ],
      );
      list.add(row);
    });
    return list;
  }

  @override
  void initState() {
    widget.ingredientData.forEach((item) {
      Ingredient ingredient = Ingredient(name: item, isChecked: false);
      ingredientList.add(ingredient);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: <Widget>[
            Icon(FontAwesomeIcons.lemon),
            SubtitleWidget(
              'Ingredients',
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: ingredientsWidget(ingredientList),
              ),
              // Positioned(right: 0, child: shoppingCartButton(context)),
            ),
          ],
        ),
      ),
    );
  }
}
