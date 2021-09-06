import 'package:qr_code_scanner/qr_code_scanner.dart';

import '/core/arbor_colors.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final Key key = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArborColors.green,
      appBar: AppBar(
        backgroundColor: ArborColors.green,
        title: Text('Sync Devices'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            QRView(
              key: key,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderWidth: 5.0,
                borderRadius: 20.0,
                cutOutSize: 327,
              ),
            ),
            SizedBox(
              height: 16,
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
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
