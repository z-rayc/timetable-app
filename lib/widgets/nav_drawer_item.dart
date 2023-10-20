import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/nav_provider.dart';

class NavDrawerItem extends ConsumerWidget {
  const NavDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.screen,
  });

  final IconData icon;
  final String title;
  final NavState screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navProvider);

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        navState.setCurrentScreen(screen);
      },
    );
  }
}
