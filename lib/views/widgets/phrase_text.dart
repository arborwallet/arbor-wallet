import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class PhraseText extends StatelessWidget {
  final int itemNumber;
  final String word;
  final bool visible;

  PhraseText(
      {required this.itemNumber, required this.word, this.visible: false});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${itemNumber+1}. ${visible ? word : '********'}',
      style: TextStyle(color: ArborColors.white, fontSize: 14),
    );
  }
}
