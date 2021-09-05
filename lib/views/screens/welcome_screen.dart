import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/core/arbor_colors.dart';
import '/core/constants/asset_paths.dart';
import '/screens/info_screen.dart';
import '/views/widgets/arbor_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.55,
              child: Center(
                child: SvgPicture.asset(
                  AssetPaths.wealth,
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Control Your Wealth',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Funds are under your control and your privacy is protected, no account required',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
            ),
            const SizedBox(
              height: 40,
            ),
            ArborButton(
              title: 'Get Started',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                        builder: (context) => InfoScreen()));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ArborButton(
              backgroundColor: ArborColors.deepGreen,
              title: 'I already have a wallet',
              onPressed: () {

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
