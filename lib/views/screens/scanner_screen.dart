import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '/core/arbor_colors.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  final Key key = GlobalKey(debugLabel: 'QR');


  @override
  Widget build(BuildContext context) {
    return Consumer<RestoreWalletProvider>(
        builder: (_,model,__){
          return Scaffold(
            backgroundColor: ArborColors.deepGreen,
            appBar: AppBar(
              backgroundColor: ArborColors.deepGreen,
              title: Text('Sync Devices'),
              elevation: 0,
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height:20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 327,
                    child: QRView(
                      key: key,
                      onQRViewCreated:model.onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        overlayColor: ArborColors.deepGreen,
                        borderColor: ArborColors.white,
                        borderWidth: 4.0,
                        borderRadius: 20.0,
                        cutOutSize: 327,
                      ),
                      onPermissionSet: (ctrl, p) => _onPermissionSet(
                        context,
                        ctrl,
                        p,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Scan QR Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: ArborColors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Open Arbor Wallet on your second device. Go to Profile, then Settings then tap Sync Devices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: ArborColors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }


  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera permission not granted'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
