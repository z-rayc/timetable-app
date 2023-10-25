import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/nav_drawer_item.dart';

class NavDrawer extends ConsumerWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navProvider);

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
            icon: Icons.house,
            title: 'Splash', // TODO splash not in drawer
            onTap: () {
              navState.setCurrentScreen(NavState.splash);
            },
          ),
          NavDrawerItem(
            icon: Icons.key,
            title: 'Login', // TODO login not in drawer
            onTap: () {
              pushNewScreen(context, NavState.login);
            },
          )
        ],
      ),
    );
  }
}
