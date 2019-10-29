import 'package:easy_vegan_cooking/activity/searchFilterActivity.dart';
import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:flutter/material.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import '../data/data.dart';
import '../apikeys.dart';
import 'gridActivity.dart';

class CategoryActivity extends StatefulWidget {
  // GridActivity({Key key, this.title}) : super(key: key);

  @override
  _CategoryActivityState createState() => _CategoryActivityState();
}

class _CategoryActivityState extends State<CategoryActivity> {
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Easy vegan cooking');
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  void _showAd() async {
    _counter++;
    if (_counter % 3 == 0) {
      interstitialAd.load();
    }

    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }

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
        this._appBarTitle = new Text('Easy Vegan Cooking');
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() {
    if (_counter % 3 == 0) {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Do you want to close the app?'),
              content: new Text(
                  'Please share use your feedback before leaving the app, we would love hearing from you'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
                // FlatButton(
                //   onPressed: () async {
                //     // Navigator.of(context).pop(false);
                //     String url =
                //         "https://play.google.com/store/apps/details?id=com.kevinrmendez.easy.vegan.cooking";
                //     if (await canLaunch(url)) {
                //       await launch(url);
                //     } else {
                //       throw 'Could not launch $url';
                //     }
                //   },
                //   child: new Text('review app'),
                // ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
              ],
            ),
          ) ??
          false;
    }
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
                          footer: GridTileBar(
                            title: Text(
                              category["title"],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        onTap: () async {
                          // String url = recipe["image"];
                          // print('URL');
                          // print(url);
                          _showAd();
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
            AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: AdmobBannerSize.BANNER,
            ),
          ],
        ),
      ),
    );
  }
}

String getBannerAdUnitId() {
  return apikeys["addMobBanner"];
}

AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["addMobInterstellar"];
}

int _counter = 0;
