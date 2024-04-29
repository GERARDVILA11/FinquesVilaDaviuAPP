import 'package:flutter/material.dart';

class WidgetIconaText extends StatelessWidget {
  final String text;
  final Icon icon;
  final Color color;

  const WidgetIconaText({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // Alineació vertical
      crossAxisAlignment: CrossAxisAlignment.center, // Alineació horizontal
      children: [
        icon,
        const SizedBox(height: 5), // Espai vertical entre la icona i el text
        Text(
          text,
          style: TextStyle(
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
