import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';

class RideInfoItem extends StatelessWidget {
  final String keyText;
  final String valueText;
  final double valueSize;
  final Color valueColor;
  final FontWeight valueWeight;
  const RideInfoItem(
      {Key? key,
      required this.keyText,
      required this.valueText,
      this.valueColor = appColors.green,
      this.valueSize = 28,
      this.valueWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          keyText,
          style: TextStyle(color: appColors.green, fontSize: 12),
        ),
        Text(valueText,
            style: TextStyle(
                color: valueColor,
                fontSize: valueSize,
                fontWeight: valueWeight)),
      ],
    );
  }
}
