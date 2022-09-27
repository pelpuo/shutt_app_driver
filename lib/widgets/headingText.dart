import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final TextAlign alignment;
  const HeadingText(
      {Key? key, required this.text, this.alignment = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      style: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: appColors.green),
    );
  }
}
