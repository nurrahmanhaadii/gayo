// lib/widgets/custom_divider.dart
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  final Color color;

  const CustomDivider({
    super.key,
    this.thickness = 1.0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      color: color,
    );
  }
}
