import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class ArborAlertDialog extends StatelessWidget {

  final String? title;
  final String? subTitle;
  final VoidCallback? onCancelPressed,onYesPressed;

  const ArborAlertDialog({Key? key,this.title,this.subTitle,this.onCancelPressed,this.onYesPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "$title",
        style: TextStyle(fontSize: 14, color: ArborColors.black),
      ),
      content: Text(
        "$subTitle",
        style: TextStyle(fontSize: 12, color: ArborColors.black),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: onCancelPressed,
        ),
        TextButton(
          child: Text(
            "Yes",
            style: TextStyle(color: ArborColors.errorRed),
          ),
          onPressed:onYesPressed,
        ),
      ],
    );
  }
}