import 'package:flutter/material.dart';

class CLabel extends StatelessWidget {
  const CLabel(
    this.text, {
    super.key,
    this.style = const TextStyle(),
    this.overrideFontSize,
  });

  final String text;
  final TextStyle style;
  final double? overrideFontSize;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: style.copyWith(
          //if null set to 16
          fontSize: overrideFontSize ?? 16,
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis);
  }
}
