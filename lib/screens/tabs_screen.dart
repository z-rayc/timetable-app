import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/screens/chat/chats_overview_screen.dart';
import 'package:timetable_app/screens/chat/new_chat_overlay.dart';
import 'package:timetable_app/screens/timetable_screen.dart';
import 'package:timetable_app/widgets/nav_drawer.dart';

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
      case NavDrawerChoice.devscreen:
        pushNewScreen(context, NavState.devScreenChoice);
    }
  }

  void _selectTab(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

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
    String activeTitle = 'Timetable';
    Widget activePage = const TimetableScreen();
    List<Widget> activeActions = [
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit my courses',
        onPressed: () {
          pushNewScreen(context, NavState.myCourses);
        },
      ),
      // refresh button
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: () {
          // get my courses and call supabase endpoint to make it readd the events
          var mycourses = ref
              .read(myCoursesProvider)
              .asData
              ?.value
              .courseUsers
              .map((e) => e.course.id)
              .toList();

          for (var course in mycourses ?? []) {
            log('Calling edge function for course $course');
            functions.invoke('getEventsByCourse', body: {
              'id': course,
              'sem': "23h",
            }).then((v) {
              log('Edge function response: ${v.data}');
            });
          }
          ref.invalidate(dailyTimetableProvider);
          //
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Refreshed'),
            behavior: SnackBarBehavior.floating,
          ));
        },
      ),
    ];

    if (_selectedPageIndex == 1) {
      activeTitle = 'Chats';
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
      drawer: NavDrawer(onSelectedNavItem: _handleDrawerNav),
      body: activePage,
      bottomNavigationBar: isNarrow ||
              isTall // don't show navbar on wide screen with little height
          ? Container(
              margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              decoration: AppThemes.bottomNavBarBoxDecoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kBottomNavBarRounding),
                clipBehavior: Clip.antiAlias,
                child: BottomNavigationBar(
                  currentIndex: _selectedPageIndex,
                  onTap: _selectTab,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today_outlined),
                      label: 'Timetable',
                      activeIcon: Icon(Icons.calendar_today_rounded),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_outlined),
                      label: 'Chats',
                      activeIcon: Icon(Icons.chat_rounded),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
