import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sayhello/container/container.dart';
import 'package:sayhello/constants.dart';
import 'package:sayhello/screens/login_page.dart';
import 'package:sayhello/screens/register_page.dart';
import 'package:sayhello/themes.dart';

Future<void> main() async {
  String googlappid = '1:1078068933478:android:668ae3e8dfce9ad5';
  if (Platform.isIOS) {
    googlappid = '1:1078068933478:ios:80ddcc18ff9fd6b7';
  }

  final FirebaseApp app = await FirebaseApp.configure(
    name: 'SayHello',
    options: FirebaseOptions(
      googleAppID: googlappid,
      apiKey: 'AIzaSyC0ALz3dlDvlHw5WJACMRSc9g-H0D7e5Oc',
      projectID: 'sayhello-bed85',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(new StateContainer(child: new SayHelloApp(firestore: firestore)));
}

class SayHelloApp extends StatelessWidget {

  SayHelloApp({this.firestore});
  final Firestore firestore;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: Constants.APP_NAME,
        theme: Themes.getTheme(context),
        home: new LoginPage(),
        routes: <String, WidgetBuilder>{
          RegisterPage.routeName: (BuildContext context) =>
              const RegisterPage(),
        });
  }
}
