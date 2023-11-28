import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:timetable_app/widgets/nav_drawer_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    final SizedBox spacing = SizedBox(height: isWide ? 10 : 20);

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: !isWide ? 180 : 100,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: AppThemes.theme.colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty_rounded,
                      color: AppThemes.theme.colorScheme.onPrimary, size: 32),
                  const SizedBox(width: 10),
                  Text("Chronos",
                      style: TextStyle(
                          color: AppThemes.theme.colorScheme.onPrimary,
                          fontSize: 24)),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    spacing,
                    NavDrawerItem(
                      icon: Icons.calendar_today,
                      title: AppLocalizations.of(context)!.timeTableTitle,
                      onTap: () {
                        onSelectedNavItem(NavDrawerChoice.timetable);
                      },
                    ),
                    spacing,
                    NavDrawerItemChat(onSelectedNavItem: onSelectedNavItem),
                    spacing,
                    NavDrawerItem(
                      icon: Icons.edit_document,
                      title: AppLocalizations.of(context)!.myCourses,
                      onTap: () {
                        onSelectedNavItem(NavDrawerChoice.myCourses);
                      },
                    ),
                    spacing,
                    NavDrawerItem(
                      icon: Icons.settings,
                      title: AppLocalizations.of(context)!.settingsTitle,
                      onTap: () {
                        onSelectedNavItem(NavDrawerChoice.settings);
                      },
                    ),
                    spacing,
                    // TODO remove dev screen FROM HERE
                    NavDrawerItem(
                      icon: Icons.error,
                      title: 'Dev screen',
                      onTap: () {
                        onSelectedNavItem(NavDrawerChoice.devscreen);
                      },
                    ),
                    spacing
                    // TODO remove dev screen TO HERE
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavDrawerItemChat extends ConsumerWidget {
  const NavDrawerItemChat({
    super.key,
    required this.onSelectedNavItem,
  });

  final void Function(NavDrawerChoice p1) onSelectedNavItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool anyUnread = ref.watch(anyUndreadMessagesProvider);
    Widget content = NavDrawerItem(
      icon: Icons.chat,
      title: AppLocalizations.of(context)!.chats,
      onTap: () {
        onSelectedNavItem(NavDrawerChoice.chat);
      },
    );
    if (anyUnread) {
      content = Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(
            top: -5,
            right: -8,
            child: Icon(
              semanticLabel: AppLocalizations.of(context)!.unreadMessages,
              Icons.circle_notifications,
              color: Colors.red,
            ),
          ),
        ],
      );
    }
    return content;
  }
}
