import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddWalletCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ArborColors.green,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ArborColors.green,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'All Done',
              style: TextStyle(color: ArborColors.white),
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: ArborColors.green,
          ),
          body: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                SvgPicture.asset(
                  AssetPaths.walletCreated,
                  fit: BoxFit.cover,
                  height: 150,
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                Text(
                  'You are now responsible for keeping the wallet phrase safe. We cannot help you to recover your secret phrase',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ArborColors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                ArborButton(
                  backgroundColor: ArborColors.logoGreen,
                  disabled: false,
                  loading: false,
                  title: 'Go Back',
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ArborButton(
                  backgroundColor: ArborColors.logoGreen,
                  disabled: false,
                  loading: false,
                  title: 'I wrote down the secret phrase',
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
