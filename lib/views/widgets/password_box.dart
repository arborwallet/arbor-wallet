import 'package:arbor/core/arbor_colors.dart';
import 'package:flutter/material.dart';

class PasswordBox extends StatelessWidget {

  final int? index;
  final ValueChanged<String>? onChanged;
  PasswordBox({this.index,this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: ArborColors.logoGreen,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
          ),
          Text(
            '$index.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ArborColors.white,
            ),
          ),

          Expanded(
            child: TextFormField(
              maxLines: 1,
              scrollPadding: EdgeInsets.zero,

              onChanged: onChanged,
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontSize: 16,

              ),
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.all(16),
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
