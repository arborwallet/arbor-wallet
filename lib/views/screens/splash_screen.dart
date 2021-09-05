import 'package:flutter/material.dart';
import '/screens/info_screen.dart';
import '/core/arbor_colors.dart';
import '/views/widgets/arbor_button.dart';
import '/core/constants/asset_paths.dart';

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Image.asset(
                AssetPaths.logo,
                width: MediaQuery.of(context).size.width * 0.5,
                //height: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            Positioned(
              bottom: 30,right: 0,left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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

                ],
              ),
            ),

          ],
        ),
        /*child: Column(
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
        ),*/
      ),
    );
  }
}

class NewSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              AssetPaths.logo,
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
          Positioned(
            bottom: 40,right: 0,left: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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

              ],
            ),
          ),

        ],
      ),
    );
  }
}

