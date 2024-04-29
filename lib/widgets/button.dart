import 'package:finques_viladaviu_app/widgets/constant_color.dart';
import 'package:flutter/material.dart';

class WidgetButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const WidgetButton({
    super.key,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
        ),
        decoration: BoxDecoration(
          color: ColorFinques.verd,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
