import '../widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder(
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final chatDocs = chatSnapshot.data.documents;

            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, i) => MessageBubble(
                chatDocs[i]['text'],
                chatDocs[i]['username'],
                chatDocs[i]['userImage'],
                chatDocs[i]['userId'] == futureSnapshot.data.uid,
                key: ValueKey(chatDocs[i].documentID),
              ),
              itemCount: chatDocs.length,
            );
          },
          stream: Firestore.instance
              .collection('chats/wXLCL7Z4f1BN7N6M3zzQ/messages')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
        );
      },
    );
  }
}
