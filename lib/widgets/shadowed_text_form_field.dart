import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';

/// Wrapper for [TextFormField] that adds a drop shadow.
class ShadowedTextFormField extends StatelessWidget {
  const ShadowedTextFormField({
    super.key,
    this.height,
    required this.child,
  });
  final TextFormField child;

  /// The height of the shadowed container.
  /// If not specified, defaults to 65.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: Container(
            decoration: AppThemes.textFormFieldBoxDecoration,
            child: child,
          ),
        ),
      ],
    );
  }
}
