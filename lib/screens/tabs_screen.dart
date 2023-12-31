import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/screens/chat/chats_overview_screen.dart';
import 'package:timetable_app/screens/chat/new_chat_overlay.dart';
import 'package:timetable_app/screens/timetables/timetable_screen.dart';
import 'package:timetable_app/widgets/nav_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The root widget when the user is signed in.
/// Provides a bottom navigation bar to switch between the [TimetableScreen] and [ChatsOverviewScreen].
/// Also provides a drawer to navigate to other screens. (drawer provides redundant navigation to [MyCoursesScreen] and [AccountSettingsScreen])
/// If there isn't enough space to display the bottom navigation bar, it is hidden and user must use the drawer to navigate.
///
/// The top app bar has dynamic title and actions depending on the selected tab.
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final db = kSupabase.rest;
  final functions = kSupabase.functions;
  int _selectedPageIndex = 0;

  /// Reacts to drawer navigation events.
  /// Pops the drawer, and switches between available tabs or pushes a new screen.
  void _handleDrawerNav(NavDrawerChoice choice) {
    Navigator.of(context).pop();

    switch (choice) {
      case NavDrawerChoice.timetable:
        _selectTab(0);
        break;
      case NavDrawerChoice.chat:
        _selectTab(1);
        break;
      case NavDrawerChoice.myCourses:
        pushNewScreen(context, NavState.myCourses);
        break;
      case NavDrawerChoice.settings:
        pushNewScreen(context, NavState.accountSettings);
        break;
    }
  }

  /// set state of the selected tab
  void _selectTab(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  /// Shows the new chat overlay.
  void showNewChatOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const NewChatOverlay();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String activeTitle = AppLocalizations.of(context)!.timeTableTitle;
    Widget activePage = const TimetableScreen();
    List<Widget> activeActions = [
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit my courses',
        onPressed: () {
          pushNewScreen(context, NavState.myCourses);
        },
      ),
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Add custom event',
        onPressed: () {
          pushNewScreen(context, NavState.createEvent);
        },
      ),
    ];

    if (_selectedPageIndex == 1) {
      activeTitle = AppLocalizations.of(context)!.chats;
      activePage = const ChatsOverviewScreen();
      activeActions = [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'New chat',
          onPressed: showNewChatOverlay,
        ),
      ];
    }

    final isNarrow = MediaQuery.of(context).size.width < 600;
    final isTall = MediaQuery.of(context).size.height > 500;
    return Scaffold(
      appBar: AppBar(
        title: Text(activeTitle),
        actions: activeActions,
      ),
      extendBody: true,
      drawer: NavDrawer(onSelectedNavItem: _handleDrawerNav),
      body: activePage,
      bottomNavigationBar: isNarrow ||
              isTall // don't show navbar on wide screen with little height
          ? Container(
              margin: const EdgeInsets.only(
                  bottom: 10, left: 10, right: 10, top: 10),
              decoration: AppThemes.bottomNavBarBoxDecoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kBottomNavBarRounding),
                clipBehavior: Clip.antiAlias,
                child: BottomNavigationBar(
                  currentIndex: _selectedPageIndex,
                  onTap: _selectTab,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: AppLocalizations.of(context)!.timeTableTitle,
                      activeIcon: const Icon(Icons.calendar_today_rounded),
                    ),
                    BottomNavigationBarItem(
                      icon: const ChatsTabsIcon(),
                      label: AppLocalizations.of(context)!.chats,
                      activeIcon: const Icon(Icons.chat),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

/// Icon for the chats tab.
/// Displays a notification icon if there are any unread messages.
class ChatsTabsIcon extends ConsumerWidget {
  const ChatsTabsIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const icon = Icon(Icons.chat_bubble_outline_outlined);
    final bool anyUnread = ref.watch(anyUndreadMessagesProvider);
    Widget content = icon;
    if (anyUnread) {
      content = const Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(
            top: -8,
            right: -12,
            child: Icon(
              Icons.circle_notifications,
              size: 20,
              semanticLabel: 'Unread messages',
            ),
          ),
        ],
      );
    }
    return content;
  }
}
