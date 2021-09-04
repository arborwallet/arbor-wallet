import 'package:flutter/material.dart';
import 'package:gallery/core/arbor_colors.dart';

class ArborButton extends StatelessWidget {

  final String title;
  final Color? backgroundColor;
  final VoidCallback onPressed;


  ArborButton({required this.title, this.backgroundColor,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      hoverColor: Colors.transparent,
      elevation: 0.0,
      focusElevation: 0.0,
      hoverElevation: 0.0,
      fillColor: backgroundColor??ArborColors.lightGreen,
      highlightElevation: 0.0,
      animationDuration: Duration.zero,
      padding: const EdgeInsets.symmetric(vertical: 16),
      constraints: const BoxConstraints(minWidth: 72.0, minHeight: 36.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: onPressed,
      child:  Center(
        child: Text(
          '$title',
          style:const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
