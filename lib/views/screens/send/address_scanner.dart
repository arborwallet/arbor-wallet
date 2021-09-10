import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class AddressScanner extends StatefulWidget {
  @override
  _AddressScannerState createState() => _AddressScannerState();
}

class _AddressScannerState extends State<AddressScanner> {
  final Key key = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SendCryptoProvider>(
      builder: (_, model, __) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {});
        return Scaffold(
          backgroundColor: ArborColors.green,
          appBar: AppBar(
            backgroundColor: ArborColors.green,
            title: Text('Scan Address'),
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 327,
                  child: QRView(
                    key: key,
                    onQRViewCreated: (_) =>
                        onQRViewCreated(context, model, controller!),
                    overlay: QrScannerOverlayShape(
                      overlayColor: ArborColors.green,
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
              ],
            ),
          ),
        );
      },
    );
  }

  void onQRViewCreated(
    BuildContext context,
    SendCryptoProvider model,
    QRViewController controller,
  ) {
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      model.setReceiverAddress(scanData.code);
      Navigator.pop(context);
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
}
