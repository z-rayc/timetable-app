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
    final double paddingRight = isMe ? 0.0 : 40.0;
    final double paddingLeft = isMe ? 40.0 : 0.0;
    double paddingTop = 0.0;
    double paddingBottom = 0.0;
    BorderRadius borderRadius = BorderRadius.circular(0);

    if (order == ChatBubbleOrder.first) {
      paddingTop = 10.0;
      paddingBottom = 0.0;
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      );
    } else if (order == ChatBubbleOrder.middle) {
      paddingTop = 0.0;
      paddingBottom = 0.0;
      borderRadius = BorderRadius.circular(0);
    } else if (order == ChatBubbleOrder.last) {
      paddingTop = 0.0;
      paddingBottom = 10.0;
      borderRadius = const BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      );
    } else if (order == ChatBubbleOrder.firstAndLast) {
      paddingTop = 10.0;
      paddingBottom = 10.0;
      borderRadius = const BorderRadius.all(
        Radius.circular(10.0),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        right: paddingRight,
        left: paddingLeft,
        top: 2,
        bottom: 0,
      ),
      child: Column(
        children: [
          if (order == ChatBubbleOrder.first ||
              order == ChatBubbleOrder.firstAndLast)
            Row(
              children: [
                if (isMe) const Spacer(),
                Text(
                  message.authorName,
                ),
                if (!isMe) const Spacer(),
              ],
            ),
          Row(
            children: [
              if (isMe) const Spacer(),
              Flexible(
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
