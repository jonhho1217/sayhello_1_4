import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sayhello/container/container.dart';
import 'package:sayhello/constants.dart';

import 'package:sayhello/screens/start_page.dart';
import 'package:sayhello/screens/register_page.dart';
import 'package:sayhello/themes.dart';

void main() => runApp(new StateContainer(child: new SayHelloApp()));

class SayHelloApp extends StatelessWidget {

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