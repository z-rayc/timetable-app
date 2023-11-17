import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/chat_message.dart';

const double kSmallRadius = 5;
const double kBigRadius = 20;

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

  BorderRadius _calculateBorder() {
    double edgeTop = kSmallRadius;
    double edgeBottom = kSmallRadius;

    if (order == ChatBubbleOrder.first) {
      edgeTop = kBigRadius;
      edgeBottom = kSmallRadius;
    } else if (order == ChatBubbleOrder.last) {
      edgeTop = kSmallRadius;
      edgeBottom = kBigRadius;
    } else if (order == ChatBubbleOrder.firstAndLast) {
      edgeTop = kBigRadius;
      edgeBottom = kBigRadius;
    }
    //else if (order == ChatBubbleOrder.middle) {} // Default small radius

    return isMe
        ? BorderRadius.only(
            topLeft: const Radius.circular(kBigRadius),
            topRight: Radius.circular(edgeTop),
            bottomLeft: const Radius.circular(kBigRadius),
            bottomRight: Radius.circular(edgeBottom),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(edgeTop),
            topRight: const Radius.circular(kBigRadius),
            bottomLeft: Radius.circular(edgeBottom),
            bottomRight: const Radius.circular(kBigRadius),
          );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = _calculateBorder();

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
