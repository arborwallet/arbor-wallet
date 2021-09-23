import 'package:arbor/core/enums/status.dart';
import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/views/screens/base/base_screen.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final Key key = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestoreWalletProvider>(
      builder: (_, model, __) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (model.recoverWalletStatus == Status.SUCCESS) {
            model.clearErrorMessages();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BaseScreen()),
              (route) => false,
            );
            model.clearStatus();
          }

          if (model.recoverWalletStatus == Status.LOADING) {
            showLoadingDialog(context);
          }
        });
        return Scaffold(
          backgroundColor: ArborColors.green,
          appBar: AppBar(
            backgroundColor: ArborColors.green,
            title: Text(
              'Sync Devices',
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
            ),
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
                    onQRViewCreated: model.onQRViewCreated,
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
                SizedBox(
                  height: 40,
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

  showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 4.0,
                  ),
                  height: 50,
                  width: 50,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Importing Wallet...',
                style: TextStyle(
                    fontSize: 16,
                    color: ArborColors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
