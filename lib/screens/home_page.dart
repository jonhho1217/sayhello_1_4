import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sayhello/container/container.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:math';
import 'dart:io';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  ChatScreen(this._userName);

  final String _userName;

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Main Chat"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("threads")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                        snapshot.data.documents[index];

                        bool isOwnMessage = false;
                        if (document['user_name'] == widget._userName) {
                          isOwnMessage = true;
                        }

                        if (document.data.containsKey("imageUrl")) {
//                          if () {
//
//                          }
                          return Image.network(document.data['imageUrl']);
                        }

                        return _message(document['message'], document['user_name'], isOwnMessage);

                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  },
                ),
              ),
              new Divider(height: 1.0),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controller,
                        onSubmitted: _handleSubmit,
                        decoration:
                        new InputDecoration.collapsed(hintText: "Send Message"),
                      ),
                    ),
                    new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _handleSubmit(_controller.text);
                          }),
                    ),
                    new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.photo_camera,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            onTakePhotoButtonPressed(_controller.text);
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future onTakePhotoButtonPressed(message) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    String imageFileName = createImageFileName();
    Uri downloadUrl = await uploadPhoto(imageFileName, imageFile);

    _handleSubmitImage(message, downloadUrl.toString());
  }

  String createImageFileName() {
    int random = new Random().nextInt(100000);
    return "image_$random.jpg";
  }

  Future uploadPhoto(String imagefileName, var imageFile) async {
    Uri downloadUrl;
    StorageReference ref = FirebaseStorage.instance.ref().child("$imagefileName.jpg");
    await ref.putFile(imageFile).onComplete.then((val) {
      val.ref.getDownloadURL().then((val) {
        print(val);
        downloadUrl = Uri.parse(val); //Val here is Already String
      });
    });

    return downloadUrl;
  }

  Widget _message(String message, String userName, bool isOwnMessage) {
    MainAxisAlignment align = MainAxisAlignment.center;
    if (isOwnMessage) {
      align = MainAxisAlignment.end;
    }

    return Row(
      mainAxisAlignment: align,
      children: <Widget>[
        Icon(Icons.person),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(userName),
            Text(message),
          ],
        )
      ],
    );
  }

  _handleSubmit(String message) {
    _controller.text = "";
    var db = Firestore.instance;
    db.collection("threads").add({
      "user_name": widget._userName,
      "message": message,
      "created_at": DateTime.now()
    }).then((val) {
      print("Sent");
    }).catchError((err) {
      print(err);
    });
  }

  _handleSubmitImage(String message, String uri) {

    _controller.text = "";
    var db = Firestore.instance;
    db.collection("threads").add({
      "user_name": widget._userName,
      "message": message,
      "imageUrl": uri,
      "created_at": DateTime.now()
    }).then((val) {
      print("Sent");
    }).catchError((err) {
      print(err);
    });
  }
}
