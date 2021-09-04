import 'package:flutter/material.dart';
import 'package:gallery/core/arbor_colors.dart';
import 'package:gallery/core/constants/asset_paths.dart';
import 'package:gallery/screens/info_screen.dart';
import 'package:gallery/views/widgets/arbor_button.dart';

import 'on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              AssetPaths.logo,
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Secure & Easy to Use Crypto Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ArborButton(
              title: 'Get Started',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<Widget>(builder: (context)=>OnBoardingScreen()));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ArborButton(
              backgroundColor: ArborColors.deepGreen,
              title: 'I already have a wallet',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<Widget>(builder: (context)=>InfoScreen()));
              },
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
