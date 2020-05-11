import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.yellow,
        accentColor: Colors.pink,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged, builder: (ctx,snapshot){
        if(snapshot.hasData) {
          return ChatScreen();
        }
        else {
          return AuthScreen();
        }
      }),
    );
  }
}
