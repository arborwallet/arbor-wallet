import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/views/screens/input_password_screen.dart';
import 'package:arbor/views/screens/scanner_screen.dart';
import 'package:arbor/views/widgets/cards/option_card.dart';
import 'package:arbor/views/widgets/responsiveness/responsive.dart';
import '../../core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class RestoreWalletScreen extends StatelessWidget {
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
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ArborColors.white,
                ),
              )),
          body: Responsive.isDesktop(context) || Responsive.isTablet(context)
              ? Container(
                  constraints: BoxConstraints(
                    maxWidth: 500,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: _RestoreWalletList(),
                )
              : Container(
                  child: _RestoreWalletList(),
                ),
        ),
      ),
    );
  }
}

class _RestoreWalletList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      children: [
        SizedBox(
          height: 10,
        ),
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
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
