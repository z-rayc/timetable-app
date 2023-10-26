import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';

/// Wrapper for [TextFormField] that adds a drop shadow.
class ShadowedTextFormField extends StatelessWidget {
  const ShadowedTextFormField({
    super.key,
    required this.child,
  });
  final TextFormField child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppThemes.textFormFieldBoxDecoration,
      child: child,
    );
  }
}
