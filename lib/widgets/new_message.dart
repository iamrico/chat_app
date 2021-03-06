import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var enteredMessage = '';
  final controller = TextEditingController();
  
  Future<void> _sendMessage() async {
    controller.clear();
    final user = await  FirebaseAuth.instance.currentUser();
    final userData = await Firestore.instance.collection('users').document(user.uid).get();
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('chats/wXLCL7Z4f1BN7N6M3zzQ/messages').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['avatar']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
