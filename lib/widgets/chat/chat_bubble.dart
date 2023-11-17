import 'package:flutter/material.dart';
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
    return Card(
        child: ListTile(
      title: Text(message.authorName),
      subtitle: Text(message.message),
      leading: Text(order.name),
    ));
  }
}

enum ChatBubbleOrder {
  first,
  middle,
  last,
}
