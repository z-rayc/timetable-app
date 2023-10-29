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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Material(
        elevation: 2,
        shadowColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          // leading: Icon(icon),
          title: Row(
            children: [
              Icon(icon),
              const Spacer(),
              Text(title),
              const Spacer(),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
