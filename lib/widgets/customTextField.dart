import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textController;
  final Function onPressed;
  final TextInputType keyboardType;
  final IconData? textIcon;
  final String hintText;
  final FocusNode? focusNode;
  final bool hideText;
  final bool? autofocus;
  const CustomTextField(
      {Key? key,
      required this.textController,
      required this.hintText,
      required this.onPressed,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.autofocus,
      this.hideText = false,
      this.textIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hideText,
      focusNode: focusNode,
      autofocus: autofocus ?? false,
      controller: textController,
      keyboardType: keyboardType,
      onTap: () {
        onPressed();
      },
      decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: appColors.offWhite,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: appColors.textGrey)),
    );
  }
}
