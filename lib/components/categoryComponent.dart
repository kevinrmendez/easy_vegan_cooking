import 'package:easy_vegan_cooking/ui/gridActivity.dart';
import 'package:easy_vegan_cooking/data/data.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

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
