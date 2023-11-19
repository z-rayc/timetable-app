import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';

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
    return Material(
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius)),
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
    );
  }
}
