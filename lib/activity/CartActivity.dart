import 'package:easy_vegan_cooking/Ingredient.dart';
import 'package:easy_vegan_cooking/appState.dart';
import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:easy_vegan_cooking/components/EmptyListTitle.dart';
import 'package:flutter/material.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../CartModel.dart';
import '../apikeys.dart';
import '../helpers.dart';

class CartActivity extends StatefulWidget {
  // GridActivity({Key key, this.title}) : super(key: key);

  @override
  _CartActivityState createState() => _CartActivityState();
}

class _CartActivityState extends State<CartActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _menuSelected(choice) {
      switch (choice) {
        case 'delete':
          {
            Provider.of<CartModel>(context, listen: false).removeAll();
            print('delete all');
          }
          break;
      }
    }

    // var filteredData = data.where((recipe) => recipe["category"] == "dinner");
    AppState appState = AppState.of(context);
    List shoppingList = AppState.of(context).shoppingCart;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Groceries'), actions: <Widget>[
        PopupMenuButton(
          icon: Icon(
            Icons.more_horiz,
            size: 30,
          ),
          onSelected: _menuSelected,
          color: Colors.white,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'delete',
                child: Container(child: Text('Delete all')),
              ),
            ];
          },
        ),
      ]),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Consumer<CartModel>(builder: (context, cartModel, child) {
            List<Ingredient> shoppingList = cartModel.ingredients;
            return shoppingList.isNotEmpty
                ? ListView.builder(
                    itemCount: shoppingList.length,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        title: Text(shoppingList[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            print('deleting item');
                            Provider.of<CartModel>(context, listen: true)
                                .remove(shoppingList[index]);
                          },
                        ),
                      );
                    },
                  )
                : EmptyListTitle('Groceries',
                    'Add all your ingredients of your recipes here');
          })),
          AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: AdmobBannerSize.BANNER,
          ),
        ],
      ),
    );
  }
}
