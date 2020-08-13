import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher/url_launcher.dart';

class AboutActivity extends StatefulWidget {
  // AboutActivity({Key key}) : super(key: key);

  @override
  _AboutActivityState createState() => _AboutActivityState();
}

class _AboutActivityState extends State<AboutActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildIcon({IconData icon, String url}) {
    return IconButton(
      color: Theme.of(context).accentColor,
      icon: Icon(icon),
      onPressed: () async {
        String url =
            "https://play.google.com/store/apps/details?id=com.easy.vegan.cooking.pro";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var filteredData = data.where((recipe) => recipe["category"] == "dinner");
    // var recipes = AppState.of(context).recipes;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Favorite vegan recipes'),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 4,
          padding: EdgeInsets.symmetric(horizontal: 40),
          margin: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildTitle(
                'About',
              ),
              Text(
                  'Easy vegan cooking is an app that will help you to eat healthy vegan recipes'),
              Text(
                  'If you want to learn more about healthy vegan eating, read our blog'),
              _buildTitle('Follow us'),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _buildIcon(
                    icon: FontAwesomeIcons.instagram,
                    url: "https://www.instagram.com/easy.vegan.cooking/"),
                _buildIcon(
                    icon: FontAwesomeIcons.facebook,
                    url:
                        "https://www.facebook.com/Easy-Vegan-Cooking-101809041505334"),
                _buildIcon(
                    icon: Icons.web,
                    url:
                        "https://www.facebook.com/Easy-Vegan-Cooking-101809041505334")
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
