// assets for login page

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:sayhello/services/auth.dart';
import 'package:sayhello/services/sign_in.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool submitting = false;
  bool rememberMe = false;

  void _checkLastLogin() async {
  }

  var _fldUserID = TextEditingController();
  var _fldPW = TextEditingController();

  double logowidth;
  double logoheight;
  double loginwidth;

  void toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }

  @override

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLastLogin());
  }

  Widget build(BuildContext context) {
    Orientation orient = MediaQuery.of(context).orientation;

    if (orient == Orientation.portrait) {
      logowidth = 30.0;
      logoheight = 30.0;
      loginwidth = MediaQuery.of(context).size.width * 0.6;
    } else {
      logowidth = 30.0;
      logoheight = 30.0;
      loginwidth = MediaQuery.of(context).size.width * 0.32;
    }

//    final logo = CircleAvatar(
//      backgroundColor: Colors.transparent,
//      radius: 48.0,
//      child: Image.asset('assets/icons/flutter-logo.png'),
//    );

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 56.0,
        child: Image.asset('assets/icons/flutter-logo.png'),
      ),
    );

    final name = Text(
      'SayHello',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.redAccent,
        fontSize: 30.0,
      ),
    );

    final userId = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _fldUserID,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'User Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      style: new TextStyle(color: Colors.white),
    );

    final pw = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _fldPW,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      style: new TextStyle(color: Colors.white),
    );

//    final remembermeSlider = Row(
//      children: <Widget>[
//        Flexible(
//          child: SwitchListTile(
//            title: const Text('Remember Me?',
//                style: TextStyle(color: Colors.white)),
//            value: rememberMe,
//            onChanged: (bool value) {
//              setState(() {
//                rememberMe = value;
//              });
//            },
//          ),
//        ),
//      ],
//    );

//    final loginButton = Container(
//      width: loginwidth,
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: Material(
//        child: MaterialButton(
//          minWidth: 100.0,
//          height: 49.0,
//          onPressed: () async {
//            SystemChannels.textInput.invokeMethod('TextInput.hide');
//            toggleSubmitState();
//            await loginInitial(_fldUserID.value.text,
//                _fldPW.value.text, rememberMe, context);
//            toggleSubmitState();
//          },
//          color: const Color(0xFF6BBEFF),
//          child: !submitting
//              ? new Text('Login',
//              style: TextStyle(color: Colors.white, fontSize: 18.0))
//              : const Center(child: const CircularProgressIndicator()),
//        ),
//      ),
//    );

    buildLogin(BuildContext context) {
      ListView outpage = ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              name,
              SizedBox(height: 20.0),
              userId,
              SizedBox(height: 8.0),
              pw,
              SizedBox(height: 12.0),
          ],
      );
      return outpage;

//      if (orient == Orientation.portrait) {
//      } else {
//      }
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(68, 90, 140, 1.0),
      body: Center(
        child: buildLogin(context),
      ),
      floatingActionButton: SignIn(
        auth: Auth(
          firebaseAuth: FirebaseAuth.instance,
          googleSignIn: GoogleSignIn(),),
      ),
    );
  }
}
