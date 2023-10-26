import 'package:flutter/material.dart';
import 'package:timetable_app/app_theme.dart';

class ShadowedTextFormField extends StatelessWidget {
  const ShadowedTextFormField({
    super.key,
    required this.textFormField,
  });
  final TextFormField textFormField;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [kBoxShadow]),
      child: textFormField,
    );
  }
}
