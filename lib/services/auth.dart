import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth({
    @required this.googleSignIn,
    @required this.firebaseAuth,
  });

//  static String _providerId = '';
//  static String get providerId => _providerId;
//
//  static String _uid = '';
//  static String get uid => _uid;
//
//  static String _displayName = '';
//  static String get displayName => _displayName;
//
//  static String _photoUrl = '';
//  static String get photoUrl => _photoUrl;
//
//  static String _email = '';
//  static String get email => _email;
//
//  static bool _isEmailVerified = false;
//  static bool get isEmailVerified => _isEmailVerified;
//
//  static bool _isAnonymous = false;
//  static bool get isAnonymous => _isAnonymous;
//
//  static String _idToken = '';
//  static String get idToken => _idToken;
//
//  static String _accessToken = '';
//  static String get accessToken => _accessToken;


  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    // TODO error handling for failures
    final GoogleSignInAuthentication googleAuth =
    await googleAccount.authentication;
    return firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

//  static Future<bool> _setUserFromFirebase(FirebaseUser user) async {
//
//    _idToken = await user?.getIdToken() ?? '';
//
//    _accessToken = '';
//
//    _isEmailVerified = user?.isEmailVerified ?? false;
//
//    _isAnonymous = user?.isAnonymous ?? true;
//
//    _providerId = user?.providerData[0]?.providerId ?? '';
//
//    _uid = user?.providerData[0]?.uid ?? '';
//
//    _displayName = user?.providerData[0]?.displayName ?? '';
//
//    _photoUrl = '';
//
//    _email = user?.providerData[0]?.email ?? '';
//
//    _user = user;
//
//    var id = _user?.uid ?? '';
//
//    return id.isNotEmpty;
//  }

}