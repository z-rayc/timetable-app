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
    var isNewAuthor =
        order == ChatBubbleOrder.first || order == ChatBubbleOrder.firstAndLast;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 2,
        top: (isNewAuthor) ? 14 : 0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (isNewAuthor)
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 1,
              ),
              child: Text(message.authorName),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isMe) const Spacer(),
              Flexible(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppThemes.theme.colorScheme.secondary
                        : AppThemes.theme.colorScheme.tertiary,
                    borderRadius: borderRadius,
                  ),
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: isMe
                          ? AppThemes.theme.colorScheme.onSecondary
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
