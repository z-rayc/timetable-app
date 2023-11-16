import 'package:flutter/material.dart';

class NewChatOverlay extends StatelessWidget {
  const NewChatOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          Text('New Chat'),
          
        ],
      )
    );
  }
}
