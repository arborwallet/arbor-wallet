import 'package:flutter/material.dart';
import '../../core/constants/arbor_colors.dart';

class ArborButton extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final bool loading;
  final bool disabled;

  ArborButton(
      {required this.title,
      this.backgroundColor = const Color(0xFF77BC4A),
      required this.onPressed,
      this.disabled = false,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      hoverColor: Colors.transparent,
      elevation: 0.0,
      focusElevation: 0.0,
      hoverElevation: 0.0,
      fillColor: disabled || loading
          ? backgroundColor!.withOpacity(0.2)
          : backgroundColor,
      highlightElevation: 0.0,
      animationDuration: Duration.zero,
      padding: const EdgeInsets.symmetric(vertical: 16),
      constraints: const BoxConstraints(minWidth: 72.0, minHeight: 36.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: disabled || loading ? () {} : onPressed,
      child: Center(
        child: loading
            ? Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ArborColors.white,
                  ),
                ),
              )
            : Text(
                '$title',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
