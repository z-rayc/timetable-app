import 'package:flutter/material.dart';
import 'package:timetable_app/widgets/nav_drawer_item.dart';

enum NavDrawerChoice {
  timetable,
  chat,
  myCourses,
  settings,
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.onSelectedNavItem});
  final void Function(NavDrawerChoice) onSelectedNavItem;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month),
                Text("Menu"),
              ],
            ),
          ),
          NavDrawerItem(
            icon: Icons.calendar_today,
            title: 'Timetable',
            onTap: () {
              onSelectedNavItem(NavDrawerChoice.timetable);
            },
          ),
          NavDrawerItem(
            icon: Icons.chat,
            title: 'Chats',
            onTap: () {
              onSelectedNavItem(NavDrawerChoice.chat);
            },
          ),
          NavDrawerItem(
            icon: Icons.edit_document,
            title: 'My Courses',
            onTap: () {
              onSelectedNavItem(NavDrawerChoice.myCourses);
            },
          ),
          NavDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              onSelectedNavItem(NavDrawerChoice.settings);
            },
          ),
        ],
      ),
    );
  }
}
