import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  // variables used in this screen
  final TextEditingController _messageController = TextEditingController();

  //submit method to send data to firebase fireStore
  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chats').add({"text": _messageController.text, "timestamp": Timestamp.now(), "userID": FirebaseAuth.instance.currentUser!.uid});
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: "Send a message"),
                maxLines: 4,
                minLines: 1,
                onChanged: (value) => setState(() {
                  //  _messageController.text = value;
                }),
              ),
            ),
            IconButton(
              onPressed: _messageController.text.isEmpty
                  ? null
                  : () {
                      _sendMessage();
                    },
              icon: const Icon(
                Icons.send_rounded,
              ),
            ),
          ],
        ));
  }
}
