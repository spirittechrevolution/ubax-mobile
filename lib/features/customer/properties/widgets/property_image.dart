import 'package:flutter/material.dart';

import '../utils/properties_utils.dart';

class PropertyImage extends StatelessWidget {
  const PropertyImage({
    super.key,
    required this.path,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String path;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final child = isNetworkImage(path)
        ? Image.network(
            path,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => Container(
              width: width,
              height: height,
              color: const Color(0xFFE2E8F0),
            ),
          )
        : Image.asset(
            path,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => Container(
              width: width,
              height: height,
              color: const Color(0xFFE2E8F0),
            ),
          );

    final r = borderRadius;
    if (r == null) return child;

    return ClipRRect(
      borderRadius: r,
      child: child,
    );
  }
}
