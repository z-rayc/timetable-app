import 'package:flutter/material.dart';

class CSubtitle extends StatelessWidget {
  const CSubtitle(
    this.text, {
    super.key,
    this.style = const TextStyle(),
    this.overrideFontSize,
    this.overrideSoftWrap,
  });

  final String text;
  final TextStyle style;
  final double? overrideFontSize;
  final bool? overrideSoftWrap;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        softWrap: overrideSoftWrap ?? true,
        style: style.copyWith(
          //if null set to 16
          fontSize: overrideFontSize ?? 18,
        ));
  }
}
