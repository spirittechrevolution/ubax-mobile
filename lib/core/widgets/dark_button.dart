import 'package:flutter/material.dart';
import 'package:statefulclickcounter/core/widgets/orange_button.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

class DarkButton extends StatelessWidget {
  const DarkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 54,
    this.borderRadius = 50,
    this.textColor = Colors.white,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final Color textColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return OrangeButton(
      text: text,
      onPressed: onPressed,
      height: height,
      borderRadius: borderRadius,
      backgroundColor: AppColors.dark,
      textColor: textColor,
      textStyle: textStyle,
    );
  }
}
