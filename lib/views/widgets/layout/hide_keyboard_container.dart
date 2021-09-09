import 'package:flutter/material.dart';

class HideKeyboardContainer extends StatelessWidget {

  final Widget child;
  HideKeyboardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: child
    );
  }
}