import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'appState.dart';
import 'components/appTItle.dart';

PermissionStatus _permissionStatus;

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  // bool save;
  // bool share;

  @override
  void initState() {
    // save = false;
    // share = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //WARNING MESSAGE BEFORE DELETING CONTACTS
    // void _warningMessage(String message) {
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text(message),
    //           actions: <Widget>[
    //             FlatButton(
    //                 child: Text('close'),
    //                 onPressed: () {
    //                   // Navigator.of(context).pop();
    //                   Navigator.popUntil(context, ModalRoute.withName('/'));
    //                 }),
    //             FlatButton(
    //                 child: Text('ok'),
    //                 onPressed: () async {
    //                   await _db.deleteAllContacts();
    //                   Navigator.pop(context);
    //                 })
    //           ],
    //         );
    //       });
    // }

    // _deleteContacts() async {
    //   _warningMessage('Are you sure you want to delete all your contacts');
    // }

    // _importContacts() async {
    //   Iterable<Contact> contacts = await ContactsService.getContacts();
    //   return contacts;
    // }

    Future<PermissionStatus> _checkPermission() async {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.contacts);
      return permission;
    }

    _requestPermission() async {
      // await PermissionHandler()
      //     .shouldShowRequestPermissionRationale(PermissionGroup.contacts);
      // await PermissionHandler().openAppSettings();
      _permissionStatus = await _checkPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return await PermissionHandler()
            .requestPermissions([PermissionGroup.contacts]);
      }
    }

    AppState appState = AppState.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: appTitle('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: ListView(
              children: <Widget>[
                SwitchListTile(
                  value: appState.share,
                  // value: false,
                  title: Text('share'),
                  onChanged: (value) {
                    setState(() {
                      AppState.of(context).callback(share: value);
                      // widget.onChangeTheme(Brightness.dark);
                    });
                    print(appState.share);
                    print(value);
                  },
                ),
                SwitchListTile(
                  value: appState.save,
                  // value: false,
                  title: Text('save image'),
                  onChanged: (value) {
                    setState(() {
                      AppState.of(context).callback(save: value);
                    });
                  },
                ),

                // SwitchListTile(
                //   value: appState.blackScreen,
                //   // value: false,
                //   title: Text('black screen'),
                //   onChanged: (value) {
                //     setState(() {
                //       AppState.of(context).callback(blackScreen: value);
                //     });
                //   },
                // ),
                // ListTile(
                //   title: Text('delete contacts'),
                //   onTap: () {
                //     _deleteContacts();
                //   },
                //   trailing: Icon(Icons.delete),
                // ),
                // ListTile(
                //   title: Text('import contacts'),
                //   onTap: () async {
                // if (_permissionStatus == null) {
                //   _permissionStatus = await _checkPermission();
                // } else {
                //   if (_permissionStatus == PermissionStatus.granted) {
                //     _importContacts();
                //   } else {
                //     _requestPermission();
                //   }
                // }
                // _requestPermission().then((value) {
                //   _importContacts().then((contacts) {
                //     // print(contacts);
                //     contacts.map((contact) {
                //       if (contact == null) {
                //         print('NULL');
                //       } else {
                //         print(contact.toString());
                //       }
                //     });
                //   });
                // });
                //   },
                //   trailing: Icon(Icons.delete),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
