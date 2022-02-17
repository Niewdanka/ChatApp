import 'package:chat_app/widgets/chat/message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createTime',
            descending: true,
          ) //sortowanie według czasu utworzenia wiadomosci
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, i) => MessageWidget(
            message: chatDocs[i]['text'],
            username: chatDocs[i]['username'],
            isMe: chatDocs[i]['userId'] == user!.uid,
            userImage: chatDocs[i]['userImage'],
            key: ValueKey(chatDocs[i].id),
          ),
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
