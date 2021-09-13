import 'package:arbor/views/screens/restore_wallet_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/arbor_colors.dart';
import '../../views/widgets/arbor_button.dart';
import '../../core/constants/asset_paths.dart';

import 'on_boarding_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArborColors.green,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Image.asset(
                AssetPaths.logo,
                width:  0.2.sh,
                //height: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            Positioned(
              bottom: 20.h,
              right: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Secure & Easy to Use Crypto Wallet',
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
                  ArborButton(
                    title: 'Get Started',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnBoardingScreen()));
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
