import 'package:easy_vegan_cooking/activity/CartActivity.dart';
import 'package:easy_vegan_cooking/activity/gridActivity.dart';
import 'package:easy_vegan_cooking/activity/searchFilterActivity.dart';
import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:easy_vegan_cooking/data/data.dart';

import 'package:flutter/material.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strings/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../apikeys.dart';
import '../apikeys.dart';
import '../helpers.dart';

class CategoryComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 730,
      child: GridView.count(
          physics: ScrollPhysics(),
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
                  // String url = recipe["image"];
                  // print('URL');
                  // print(url);
                  // showAd();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GridActivity(
                              category: category["title"],
                            )),
                  );
                });
          }).toList()),
    );
  }
}
