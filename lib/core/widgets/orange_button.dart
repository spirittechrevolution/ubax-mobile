import 'package:flutter/material.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 54,
    this.borderRadius = 50,
    this.backgroundColor = const Color(0xFFE67E22),
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
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
