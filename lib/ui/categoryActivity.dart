import 'package:strings/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:easy_vegan_cooking/ui/searchFilterActivity.dart';
import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:easy_vegan_cooking/data/data.dart';

import '../main.dart';
import 'gridActivity.dart';
import '../helpers.dart';

class CategoryActivity extends StatefulWidget {
  // GridActivity({Key key, this.title}) : super(key: key);
  CategoryActivity() {
    interstitialAd.load();
  }

  @override
  _CategoryActivityState createState() => _CategoryActivityState();
}

class _CategoryActivityState extends State<CategoryActivity> {
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text(
    'Easy Vegan Cooking',
    style: TextStyle(fontWeight: FontWeight.bold),
  );
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";

  Widget _buildAppBarTitle() {
    return Container(
      // width: 200,
      // color: Colors.red,
      child: Row(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * .6,
              child: _appBarTitle),
          Container(
            // width: 200,
            child: IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
          ),
        ],
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = TextField(
          style: TextStyle(color: Colors.white, fontSize: 19),
          controller: _filter,
          decoration: InputDecoration(
            fillColor: Colors.white,
            // prefixIcon: Icon(
            //   Icons.search,
            //   color: Colors.white,
            // ),
            hintText: 'Search recipe',
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            // border: UnderlineInputBorder(
            //     borderSide: BorderSide(color: Colors.white))
          ),
          onEditingComplete: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchFilterActivity(
                        searchTerm: _filter.text,
                      )),
            );
          },
        );
      } else {
        this._searchIcon = new Icon(
          Icons.search,
          color: Colors.white,
        );
        this._appBarTitle = new Text('Easy Vegan Cooking',
            style: TextStyle(fontWeight: FontWeight.bold));
        // filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(centerTitle: true, title: _buildAppBarTitle()
        // leading: Container(
        //   child: new IconButton(
        //     icon: _searchIcon,
        //     onPressed: _searchPressed,
        //   ),
        // ),
        );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => (context) {
    //       interstitialAd.show();
    //       print('ADD SHOWED');
    //     });
    // interstitialAd.show();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Do you want to close the app?',
              style: TextStyle(color: PrimaryColor),
            ),
            content: new Text(
                'Please share us your feedback before leaving the app, we would love hearing from you'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: AccentColor),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  // Navigator.of(context).pop(false);
                  String url =
                      "https://play.google.com/store/apps/details?id=com.kevinrmendez.easy.vegan.cooking";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: new Text(
                  'review app',
                  style: TextStyle(color: AccentColor),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: AccentColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // var filteredData = data.where((recipe) => recipe["category"] == "dinner");
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: _buildBar(context),
        body: Column(
          children: <Widget>[
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  children: categories.map((Map category) {
                    return GestureDetector(
                        child: Card(
                          child: GridTile(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      category["image"],
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            footer: Container(
                              height: 30,
                              child: GridTileBar(
                                // backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
                                backgroundColor: Colors.white,
                                title: Text(
                                  capitalize(category["title"]),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontFamily: 'JosefinSans',
                                      fontSize: 16,
                                      color: Colors.black,
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GridActivity(
                                      category: category["title"],
                                    )),
                          );
                        });
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
