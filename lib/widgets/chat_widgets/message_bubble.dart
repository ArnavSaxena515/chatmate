import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key,
      this.isSender = true,
      this.tail = true,
      required this.text,
      this.username = "",
      this.color = Colors.white70,
      this.userNameTextStyle = const TextStyle(
        color: Colors.deepOrange,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      this.messageTextStyle = const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      this.timeStampStyle = const TextStyle(
        color: Colors.green,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      required this.time})
      : super(key: key);
  final bool isSender, tail;
  final String time;
  final String text, username;
  final TextStyle userNameTextStyle, messageTextStyle, timeStampStyle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      // if sender, align message to the top left
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        // use custom paint widget to draw out a customised bubble shape for the messages to be displayed in
        child: CustomPaint(
          painter: SpecialChatBubbleOne(color: color, alignment: isSender ? Alignment.topRight : Alignment.topLeft, tail: tail),
          child: Container(
            constraints: BoxConstraints(
                // set the max width that a message bubble can take which is 0.7 of total width available according to app window
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            // if sender, then margin from right side is kept 17 for the tail
            // if not sender, then margin left side is kept as 17 for the tail
            margin: isSender ? const EdgeInsets.fromLTRB(7, 7, 17, 7) : const EdgeInsets.fromLTRB(17, 7, 7, 7),
            child: Column(
              // clipBehavior: Clip.none,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if we have a username and message is not by the current user
                if (username.isNotEmpty && !isSender)
                  Text(
                    username,
                    style: userNameTextStyle,
                    textAlign: TextAlign.left,
                  ),

                Text(
                  text,
                  style: messageTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: timeStampStyle,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                //todo add time stamp
              ],
            ),
          ),
        ),
      ),
    );
  }
}
