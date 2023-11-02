import 'package:flutter/material.dart';

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
      ),
      child: DropdownMenu<String>(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
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
