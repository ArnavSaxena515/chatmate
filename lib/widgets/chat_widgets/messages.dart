import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chatmate/widgets/chat_widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widget to output all the messages
class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  // Function to get username from user ID
  Future<String> _getUsername({required String userID}) async {
    final userName = await FirebaseFirestore.instance.collection('users').doc(userID).get().then((userData) => userData['username']);
    print(userName);
    return userName;
  }

  Future<String> _getUserImageUrl(String userID) async =>
      await FirebaseFirestore.instance.collection('users').doc(userID).get().then((userData) => userData['userImageUrl']);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chats').orderBy("timestamp", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final chatData = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: chatData.length,
            itemBuilder: (_, index) {
              final String senderId = chatData[index]['userID'];
              // final username = _getUsername(userID: senderId);
              // print(username);

              return FutureBuilder(
                future: _getUsername(userID: senderId),
                builder: (BuildContext context, AsyncSnapshot<String> username) {
                  final bool isSender = senderId == FirebaseAuth.instance.currentUser!.uid;
                  final Timestamp timeStamp = chatData[index]['timestamp'];
                  final messageTime = DateFormat("HH:mm").format(timeStamp.toDate());
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          print("Gesture detected");
                          FutureBuilder(
                              future: _getUserImageUrl(senderId),
                              builder: (BuildContext context, AsyncSnapshot<String> imageUrlSnapshot) {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        height: imageUrlSnapshot.connectionState == ConnectionState.waiting
                                            ? 100
                                            : imageUrlSnapshot.connectionState == ConnectionState.done
                                                ? 400
                                                : 100,
                                        child: imageUrlSnapshot.connectionState == ConnectionState.waiting
                                            ? const CircularProgressIndicator()
                                            : Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  CircleAvatar(
                                                    maxRadius: 40,
                                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                                    backgroundImage: Image.network(imageUrlSnapshot.data!).image,
                                                  ),
                                                ],
                                              ),
                                      );
                                    });
                                return SizedBox();
                              });
                        },
                        child: MessageBubble(
                          time: messageTime,
                          username: username.data ?? "",
                          text: chatData[index]['text'].toString(),
                          color: isSender ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                          isSender: isSender,
                          tail: true,
                          messageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      // BubbleSpecialOne(
                      //   text: "${username.data}\n" + chatData[index]['text'].toString(),
                      //   color: const Color(0xFF1B97F3),
                      //   isSender: senderId == FirebaseAuth.instance.currentUser!.uid,
                      //   tail: true,
                      //   textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                      // ),
                      // Positioned(
                      //   top: 0,
                      //   left: 20,
                      //   child: Text(
                      //     username.data ?? "Unknown User",
                      //     style: const TextStyle(color: Colors.white),
                      //   ),
                      // ),
                    ],
                  );
                },
              );
              //Text(chatData[index]['text']);
            },
          );
        }
      },
    );
  }
}
