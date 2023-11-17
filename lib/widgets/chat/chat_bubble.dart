import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.order,
  });
  final ChatMessage message;
  final bool isMe;
  final ChatBubbleOrder order;

  @override
  Widget build(BuildContext context) {
    double edgeTop = 0;
    double edgeBottom = 0;

    if (order == ChatBubbleOrder.first) {
      edgeTop = 20;
    } else if (order == ChatBubbleOrder.middle) {
      edgeTop = 2;
      edgeBottom = 2;
    } else if (order == ChatBubbleOrder.last) {
      edgeBottom = 20;
    } else if (order == ChatBubbleOrder.firstAndLast) {
      edgeTop = 20;
      edgeBottom = 20;
    }

    BorderRadius borderRadius = isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(edgeTop),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(edgeBottom),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(edgeTop),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(edgeBottom),
            bottomRight: Radius.circular(20),
          );

    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (order == ChatBubbleOrder.first ||
              order == ChatBubbleOrder.firstAndLast)
            Text(message.authorName),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isMe) const Spacer(),
              Flexible(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppThemes.theme.colorScheme.primary
                        : AppThemes.theme.colorScheme.tertiary,
                    borderRadius: borderRadius,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: isMe
                          ? AppThemes.theme.colorScheme.onPrimary
                          : AppThemes.theme.colorScheme.onTertiary,
                    ),
                  ),
                ),
              ),
              if (!isMe) const Spacer(flex: 1),
            ],
          ),
        ],
      ),
    );
  }
}

enum ChatBubbleOrder {
  first,
  middle,
  last,
  firstAndLast,
}
