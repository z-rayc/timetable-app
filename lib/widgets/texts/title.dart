import 'package:flutter/material.dart';

class CTitle extends StatelessWidget {
  const CTitle(
    this.text, {
    super.key,
    this.style = const TextStyle(),
    this.overrideFontSize,
    this.overrideFontWeight,
  });

  final String text;
  final TextStyle style;
  final double? overrideFontSize;
  final FontWeight? overrideFontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: style.copyWith(
          //if null set to 24
          fontSize: overrideFontSize ?? 24,
          //if null set to w500
          fontWeight: overrideFontWeight ?? FontWeight.w500,
        ));
  }
}
