import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/views/screens/input_password_screen.dart';
import 'package:arbor/views/screens/scanner_screen.dart';
import 'package:arbor/views/widgets/cards/option_card.dart';
import '../../core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class RestoreWalletScreen extends StatefulWidget {
  @override
  _RestoreWalletScreenState createState() => _RestoreWalletScreenState();
}

class _RestoreWalletScreenState extends State<RestoreWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ArborColors.green,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ArborColors.green,
          appBar: AppBar(
            backgroundColor: ArborColors.green,
            centerTitle: true,
              title: Text(
                'Restore Wallet',
                style: TextStyle(
                  color: ArborColors.white,
                ),
              ),
              leading:  IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ArborColors.white,
                ),
              )
          ),
          body: Container(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16,),
              children: [
                SizedBox(height: 10,),
                OptionCard(
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
                OptionCard(
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
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


