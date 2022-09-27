import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';

class greenButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  const greenButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      minWidth: double.infinity,
      color: appColors.lightGreen,
      padding: const EdgeInsets.all(16),
      onPressed: () {
        onPressed();
      },
      child: Text(
        label,
        style: const TextStyle(
            fontWeight: FontWeight.w400, color: appColors.appWhite),
      ),
    );
  }
}
