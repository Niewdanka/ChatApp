import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.username,
    required this.userImage,
  }) : super(key: key);

  final String username;
  final String message;
  final bool isMe;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: !isMe
                    ? Colors.grey[350]
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(15),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: !isMe ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: !isMe ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isMe)
          Positioned(
            top: 0,
            left: 120,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ),
          ),
      ],
    );
  }
}
