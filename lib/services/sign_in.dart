import 'package:flutter/material.dart';

import 'package:sayhello/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sayhello/container/container.dart';
import 'package:sayhello/screens/start_page.dart';
import 'package:sayhello/screens/home_page.dart';
import 'package:sayhello/screens/register_page.dart';

class SignIn extends StatelessWidget {
  const SignIn({
    @required this.auth,
  });

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _handleSignInGoogle(context),
      icon: Image.asset('assets/icons/google_g_logo.png', height: 24.0),
      label: const Text('Sign in with Google'),
    );
  }

  void _handleSignInGoogle(BuildContext context) {
    bool newUser;

    auth.signInWithGoogle().then((FirebaseUser user) {
      _existingUser(context, user, newUser).then((newUser) {
        if (newUser) {
          _navigateToRegistration(user, context);
        }

        else {
          _showSnackBar(context, 'Welcome ${user.displayName}');
          Navigator.of(context).push(MaterialPageRoute // go to Account Balance page
            (builder: (BuildContext context) => ChatScreen(user.displayName)));
        }
      });
    });
  }

//  Future<LoginPage> logoutWithGoogle() async {
//    await googleSignIn.signOut();
//    return new LoginPage();
//  }

  Future _existingUser(context, user, newUser) async {
    if (user != null) { // check new user
      final StateContainerState state = StateContainer.of(context);
      state.updateSession(user);

      var data = await Firestore.instance.collection("users").where("uid", isEqualTo: user.uid).getDocuments();
      var list = data.documents;

      if (list.length == 0) {
        // Add data to server if new user
        return true;
      }
      else {
        return false;
      }
    }
    else { // email auth failed...
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    final SnackBar snackBar = SnackBar(content: Text(msg));

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _navigateToRegistration(user, BuildContext context) {
    Navigator.pushNamed(context, RegisterPage.routeName);
  }
}

loginInitial(_parm1, _parm2, remember, context) async {
  bool test = false;
  final StateContainerState state = StateContainer.of(context);
  Object user = state.getSession();

//  if (user!=null) {
//    Navigator.of(context).push(MaterialPageRoute // go to Account Balance page
//      (builder: (BuildContext context) => ChatScreen()));
//  }
//  else {
//    badLogin(context, "Unable to Login");
//  }

}

Future<bool> badLogin(BuildContext context, msg) {
  // login failed, show msg w/ context
  return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}