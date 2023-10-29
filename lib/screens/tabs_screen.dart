import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/screens/chats_screen.dart';
import 'package:timetable_app/screens/temp_timetable_screen.dart';
import 'package:timetable_app/widgets/nav_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
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
        pushNewScreen(context, NavState.selectCourses);
        break;
      case NavDrawerChoice.settings:
        pushNewScreen(context, NavState.settings);
        break;
    }
  }

  void _selectTab(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String activeTitle = 'Timetable';
    Widget activePage = const TempTimetableScreen();

    if (_selectedPageIndex == 1) {
      activeTitle = 'Chats';
      activePage = const ChatsScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activeTitle),
      ),
      drawer: NavDrawer(onSelectedNavItem: _handleDrawerNav),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
