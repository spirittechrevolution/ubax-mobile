import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 54,
    this.borderRadius = 50,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(text, style: textStyle ?? AppTextStyles.button),
      ),
    );
  }
}
