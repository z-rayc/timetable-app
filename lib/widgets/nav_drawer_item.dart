import 'package:flutter/material.dart';

class NavDrawerItem extends StatelessWidget {
  const NavDrawerItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
