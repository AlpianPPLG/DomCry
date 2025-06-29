import 'package:flutter/material.dart';

class SettingsSectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const SettingsSectionTitle({
    super.key,
    required this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}