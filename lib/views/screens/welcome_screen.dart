import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/arbor_colors.dart';
import '/core/constants/asset_paths.dart';
import '/screens/info_screen.dart';
import '/views/widgets/arbor_button.dart';
import 'restore_wallet_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArborColors.green,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
                height: 0.45.sh,
                child: Center(
                  child: SvgPicture.asset(
                    AssetPaths.wealth,
                    height: 0.4.sh,
                  ),
                ),
              ),
               SizedBox(
                height: 20.h,
              ),
              Text(
                'Control Your Wealth',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
               SizedBox(
                height: 20.h,
              ),
              Text(
                'Funds are under your control and your privacy is protected, no account required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                softWrap: true,
              ),
               SizedBox(
                height: 40.h,
              ),
              ArborButton(
                title: 'Get Started',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => InfoScreen()),
                        (route) => false,
                  );
                },
              ),
             SizedBox(
                height: 20.h,
              ),
              ArborButton(
                backgroundColor: ArborColors.deepGreen,
                title: 'I already have a wallet',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestoreWalletScreen()));
                },
              ),
             SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
