import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/widgets/nav_drawer_item.dart';

enum NavDrawerChoice {
  timetable,
  chat,
  myCourses,
  settings,
  devscreen, // remove this later TODO
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.onSelectedNavItem});
  final void Function(NavDrawerChoice) onSelectedNavItem;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: !isWide ? 180 : 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: AppThemes.theme.colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month,
                      color: AppThemes.theme.colorScheme.onPrimary, size: 32),
                  const SizedBox(width: 10),
                  Text("Chronos!",
                      style: TextStyle(
                          color: AppThemes.theme.colorScheme.onPrimary,
                          fontSize: 24)),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  NavDrawerItem(
                    // remove this later TODO
                    icon: Icons.error,
                    title: 'Dev screen',
                    onTap: () {
                      onSelectedNavItem(NavDrawerChoice.devscreen);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
