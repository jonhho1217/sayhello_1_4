import 'package:flutter/material.dart';

import 'package:sayhello/container/container.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sayhello/screens/home_page.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = true;

  var _fldName = TextEditingController();
  var _fldRole = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _fldName,
            decoration: const InputDecoration(
              labelText: 'Display Name',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'Display Name is required';
              }
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _fldRole,
            decoration: const InputDecoration(
              labelText: 'Role',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'Role is required';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _agreedToTOS,
                  onChanged: _setAgreedToTOS,
                ),
                GestureDetector(
                  onTap: () => _setAgreedToTOS(!_agreedToTOS),
                  child: const Text(
                    'I agree to the Terms of Services and Privacy Policy',
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              const Spacer(),
              OutlineButton(
                highlightedBorderColor: Colors.black,
                onPressed: _submittable() ? _submit : null,
                child: const Text('Register'),
                color: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      final StateContainerState state = StateContainer.of(context);
      FirebaseUser user = state.getSession();

      const SnackBar snackBar = SnackBar(content: Text('Form submitted'));
      Scaffold.of(context).showSnackBar(snackBar);

      Firestore.instance.collection('users').document(user.uid).setData({
        'name': _fldName.value.text,
        'role': _fldRole.value.text,
        'uid': user.uid,
      });

      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute // go to Account Balance page
          (builder: (BuildContext context) => ChatScreen(user.displayName)));
    }
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}
