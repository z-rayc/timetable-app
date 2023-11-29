import 'package:flutter/material.dart';

/// A list tile for displaying an email.
/// Displays the email and a delete icon button.
class EmailListTile extends StatelessWidget {
  const EmailListTile({
    required this.email,
    required this.onTapDelete,
    super.key,
  });

  final String email;
  final VoidCallback onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(email),
      trailing: IconButton(
        onPressed: onTapDelete,
        icon: const Icon(Icons.delete),
      ),
    ));
  }
}