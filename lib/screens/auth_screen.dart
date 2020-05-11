import 'package:flutter/material.dart';
import '../widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, File image, BuildContext ctx) async {
    AuthResult result;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('userImage')
            .child(result.user.uid + '.jpg');

        await storageRef.putFile(image).onComplete;

        final link = await storageRef.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(result.user.uid)
            .setData({
          'username': username,
          'email': email,
          'avatar': link,
        });
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Theme.of(ctx).backgroundColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
