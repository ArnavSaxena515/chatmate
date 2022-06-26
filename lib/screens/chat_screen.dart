import 'package:chatmate/widgets/chat_widgets/messages.dart';
import 'package:chatmate/widgets/chat_widgets/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/menu_item.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat-screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatMate"),
        actions: [
          DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              dropdownColor: Colors.white,
              items: const [
                DropdownMenuItem(
                  child: MenuItem(
                    icon: Icons.person,
                    label: "Manage User",
                  ),
                  value: 'manage_user_information',
                ),
                DropdownMenuItem(
                  child: MenuItem(
                    icon: Icons.exit_to_app,
                    label: "Logout",
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (selectedOption) {
                if (selectedOption == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Container(
          child: Column(
        children: const [
          Expanded(child: Messages()),
          SendMessage(),
        ],
      )),
    );
  }
}
