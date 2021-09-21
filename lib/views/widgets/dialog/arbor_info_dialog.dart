import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class ArborInfoDialog extends StatelessWidget {

  final String? title,description;
  final VoidCallback? onPressed;
  const ArborInfoDialog({Key? key,this.title,this.description,this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("$title",
        style: TextStyle(fontSize: 14, color: ArborColors.black),),
      content: Text(
        "$description",
        style: TextStyle(fontSize: 12, color: ArborColors.black),),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: ()=>onPressed?? Navigator.pop(context, false),
        ),
      ],
    );
  }
}
