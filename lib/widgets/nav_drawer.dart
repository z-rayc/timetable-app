import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/nav_drawer_item.dart';

class NavDrawer extends ConsumerWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Icon(Icons.calendar_month),
                Text("Menu"),
              ],
            ),
          ),
          NavDrawerItem(
            icon: Icons.house,
            title: 'Home',
            screen: NavState.login,
          ),
        ],
      ),
    );
  }
}
