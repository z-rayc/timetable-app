import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';

/// A dropdown menu that is used in a form.
class FormDropdownMenu extends StatelessWidget {
  const FormDropdownMenu({
    super.key,
    required this.items,
    required this.controller,
    required this.onSelected,
    required this.name,
    required this.width,
  });

  final String name;
  final double width;
  final List<DropdownMenuEntry<String>> items;
  final TextEditingController controller;
  final Function(String?) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            AppThemes.boxShadow(3),
          ]),
      child: DropdownMenu<String>(
        enableSearch: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        width: width,
        initialSelection: items[0].label,
        controller: controller,
        label: Text(name),
        dropdownMenuEntries: items,
        onSelected: (String? program) => onSelected(program),
      ),
    );
  }
}
