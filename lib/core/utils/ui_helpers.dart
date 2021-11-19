import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class UIHelpers {
  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$message!"),
        duration: Duration(milliseconds: 1000),
        backgroundColor: ArborColors.deepGreen,
        elevation: 2,
        padding: EdgeInsets.all(
          10,
        ), // Inner padding for SnackBar content.
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  static showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$message!"),
        duration: Duration(milliseconds: 1000),
        backgroundColor: ArborColors.errorRed,
        elevation: 2,
        padding: EdgeInsets.all(
          10,
        ), // Inner padding for SnackBar content.
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
