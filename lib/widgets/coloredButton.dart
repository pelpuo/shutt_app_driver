import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';

class coloredButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final Color color;
  final Color textColor;
  final double elevation;
  const coloredButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      this.elevation = 0,
      this.color = appColors.green,
      this.textColor = appColors.appWhite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      minWidth: double.infinity,
      color: color,
      padding: const EdgeInsets.all(16),
      onPressed: () {
        onPressed();
      },
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w400, color: textColor),
      ),
    );
  }
}
