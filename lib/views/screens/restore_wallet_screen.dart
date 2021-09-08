import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/views/screens/input_password_screen.dart';
import 'package:arbor/views/screens/scanner_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class RestoreWalletScreen extends StatefulWidget {
  @override
  _RestoreWalletScreenState createState() => _RestoreWalletScreenState();
}

class _RestoreWalletScreenState extends State<RestoreWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArborColors.green,
      appBar: AppBar(
        backgroundColor: ArborColors.green,
        centerTitle: true,
        elevation: 0,
        title: Text('Restore Wallet'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _OptionCard(
              iconPath: AssetPaths.qr,
              description: 'Scan a QR Code on Arbor Wallet on another device.',
              actionText: 'Scan QR Code',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScannerScreen(),
                  ),
                );
              },
            ),
            _OptionCard(
              iconPath: AssetPaths.restore,
              description: 'Type your 12-word secret backup phrase.',
              actionText: 'Type Secret Phrase',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputPasswordScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String? iconPath;
  final String? description;
  final String? actionText;
  final VoidCallback? onPressed;

  _OptionCard(
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
