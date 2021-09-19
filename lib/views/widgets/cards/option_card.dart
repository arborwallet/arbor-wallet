import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionCard extends StatelessWidget {
  final String? iconPath;
  final String? description;
  final String? actionText;
  final VoidCallback? onPressed;

  OptionCard(
      {this.iconPath, this.description, this.actionText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        elevation: 2,
        color: ArborColors.logoGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20),),),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                '$iconPath',
                height: 60,
                width: 60,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '$description',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: ArborColors.white,
                ),
              ),
              Text(
                '$actionText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ArborColors.green,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}