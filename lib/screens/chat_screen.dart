import '../widgets/new_message.dart';

import '../widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return ;
    }, onLaunch: (msg){
      print(msg);
      return;
    }, onResume: (msg){
      print(msg);
      return;
    });
    fbm.subscribeToTopic("chats/wXLCL7Z4f1BN7N6M3zzQ/messages/{message}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        DropdownButton(
          
          onChanged: (itemIdentifier) {
            if (itemIdentifier == 'Logout') {
              FirebaseAuth.instance.signOut();
            }
          },
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          items: [
            DropdownMenuItem(
              child: Container(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text('Log out'),
                  ],
                ),
              ),
              value: 'Logout',
            ),
          ],
        ),
      ], title: Text('Chat App')),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      
    );
  }
}
