import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';

class ListviewContainer extends StatelessWidget {
  const ListviewContainer({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppThemes.listViewContainerDecoration,
      child: ListView(
        children: children,
      ),
    );
  }
}
