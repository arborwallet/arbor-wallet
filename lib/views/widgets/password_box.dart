import 'package:arbor/core/arbor_colors.dart';
import 'package:flutter/material.dart';

class PasswordBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: ArborColors.logoGreen,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '1.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ArborColors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: '...',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
