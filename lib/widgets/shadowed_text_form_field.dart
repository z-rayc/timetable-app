import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';

/// Wrapper for [TextFormField] that adds a drop shadow.
/// Internally uses a stack to place the 'shadow' behind the text field.
/// The shadow will not appear correctly if font size is changed, it is a tradeoff for the design.
class ShadowedTextFormField extends StatelessWidget {
  const ShadowedTextFormField({
    super.key,
    this.height,
    required this.child,
  });
  final TextFormField child;

  /// The height of the shadowed container.
  /// If not specified, defaults to 55.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height ?? 55,
          child: Container(
            decoration: AppThemes.textFormFieldBoxDecoration,
          ),
        ),
        child
      ],
    );
  }
}
