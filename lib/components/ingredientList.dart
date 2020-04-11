import 'package:easy_vegan_cooking/activity/CartActivity.dart';
import 'package:flutter/material.dart';
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
  bool isShoppingCartEmpty;
  List<Widget> ingredientsWidget(List<Ingredient> ingredients) {
    List<Widget> list = List();

    ingredientList.forEach((item) {
      var row = Container(
          height: 30,
          // margin: EdgeInsets.symmetric(vertical: 40),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: item.isChecked,
                onChanged: (value) {
                  setState(() {
                    item.isChecked = value;
                  });
                },
              ),
              Flexible(
                // fit: FlexFit.loose,
                child: Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    item.name,
                    // overflow: TextOverflow.visible,
                    // style: TextStyle(fontSize: 10),
                  ),
                ),
              )
            ],
          ));
      list.add(row);
    });
    return list;
  }

  Container shoppingCartButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: PrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: IconButton(
        icon: Icon(Icons.shopping_cart),
        color:
            // Theme.of(context).primaryColor,
            Colors.white,
        onPressed: () {
          ingredientList.forEach((ingredient) {
            if (ingredient.isChecked) {
              Provider.of<CartModel>(context, listen: false).add(ingredient);
              setState(() {
                ingredient.isChecked = false;
                isShoppingCartEmpty = false;
              });
            }
          });
          if (!isShoppingCartEmpty) {
            final snackBar = SnackBar(
              duration: Duration(seconds: 5),
              content: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartActivity()),
                    );
                  },
                  child: Text('ingredients added to groceries list')),
              backgroundColor: AccentColor,
            );
            Scaffold.of(context).showSnackBar(snackBar);
            isShoppingCartEmpty = true;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    widget.ingredientData.forEach((item) {
      Ingredient ingredient = Ingredient(name: item, isChecked: false);
      ingredientList.add(ingredient);
    });
    isShoppingCartEmpty = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SubtitleWidget(
              'Ingredients',
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ingredientsWidget(ingredientList),
                  ),
                  Positioned(right: 0, child: shoppingCartButton(context)),
                ],
              ),
            ),
            // Stack(
            //   fit: StackFit.loose,
            //   alignment: AlignmentDirectional.topEnd,
            //   children: <Widget>[
            //     Column(
            //       mainAxisSize: MainAxisSize.min,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: ingredientsWidget(ingredientList),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
