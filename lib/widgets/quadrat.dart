import 'package:flutter/material.dart';

class WidgetQuadrat extends StatelessWidget {
  final String imatge;
  final Function()? onTap;
  const WidgetQuadrat({super.key, required this.imatge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200]),
          child: Image.asset(
            imatge,
            height: 40,
          )),
    );
  }
}
