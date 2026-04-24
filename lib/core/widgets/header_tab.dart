import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

class HeaderTab extends StatelessWidget {
  const HeaderTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w300,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
