import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:timetable_app/widgets/nav_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Item in the navigation drawer. Displays an icon and a title.
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

/// Special navigation drawer item for the chat item.
/// Displays a notification icon if there are unread messages.
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
