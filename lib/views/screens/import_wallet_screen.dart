import '/core/arbor_colors.dart';
import 'package:flutter/material.dart';

class ImportWalletScreen extends StatefulWidget {
  @override
  _ImportWalletScreenState createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArborColors.green,
      appBar: AppBar(
        backgroundColor: ArborColors.green,
        title: Text('Restore Wallet'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _OptionCard(),
            _OptionCard(),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      elevation: 2,
      color: ArborColors.logoGreen,
      shape: StadiumBorder(),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.qr_code),
            SizedBox(
              height: 10,
            ),
            Text(
              'Scan a QR Code on Arbor Wallet on another device',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: ArborColors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Scan QR Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: ArborColors.deepGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

