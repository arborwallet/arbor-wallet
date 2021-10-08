import 'dart:io';
import 'dart:typed_data';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:arbor/models/models.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:ui' as ui;

class WalletReceiveScreen extends StatefulWidget {
  const WalletReceiveScreen({
    required this.index,
    required this.wallet,
  });

  final int index;
  final Wallet wallet;

  @override
  _WalletReceiveScreenState createState() => _WalletReceiveScreenState();
}

class _WalletReceiveScreenState extends State<WalletReceiveScreen> {
  //static GlobalKey globalKey = new GlobalKey(debugLabel: 'wallet_receive_screen');


  void shareQrCode(String address) async {
    try {
      final qrValidationResult = QrValidator.validate(
          data: address,
          version: QrVersions.auto,
          errorCorrectionLevel: QrErrorCorrectLevel.L);
      if (qrValidationResult.isValid) {
        final _qrCode = qrValidationResult.qrCode;

        ui.Image logoImage = await getLogoImage();

        //Paint QR code
        final _qrPainter = QrPainter.withQr(
          qr: _qrCode!,
          color: ArborColors.white,
          gapless: true,
          embeddedImage: logoImage,
        );

        //Save in a temporary directory
        final tempDirPath = (await getTemporaryDirectory()).path;
        String path = '${tempDirPath}/wallet-receive-address.png';

        final picData =
            await _qrPainter.toImageData(2048, format: ui.ImageByteFormat.png);
        await writeToFile(picData!, path);

        await Share.shareFiles(
          [path],
          mimeTypes: ['images/png'],
          subject: '${widget.wallet.blockchain.name} Wallet Address',
          text:
              'My ${widget.wallet.blockchain.ticker.toUpperCase()} Wallet Address:  ${widget.wallet.address}',
        );
      } else {
        String _errorMessage = qrValidationResult.error.toString();
        showSnackBar(context, '$_errorMessage', ArborColors.errorRed);
      }
    } on Exception catch (e) {
      showSnackBar(context, '${e.toString()}', ArborColors.errorRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArborColors.green,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: ArborColors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // title: Text('Receive ${widget.wallet.fork.name} (${widget.wallet.name})'),
        title: Text(
          'Receive ${widget.wallet.blockchain.name}',
          style: TextStyle(
            color: ArborColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ArborColors.green,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: ArborColors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(
            color: ArborColors.black,
          ),
        ),
        constraints:
        BoxConstraints(maxWidth: 400, maxHeight: double.infinity),

        child: walletReceiveScreenBody(),
      )
    );
  }

  Widget walletReceiveScreenBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: QrImage(
            data: widget.wallet.address,
            size: 220,
            version: QrVersions.auto,
            embeddedImage: AssetImage('assets/images/logo.png'),
            backgroundColor: ArborColors.white,
            foregroundColor: Colors.black,
            gapless: false,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Tap to copy your ${widget.wallet.blockchain.name} light wallet address:',
          textAlign: TextAlign.center,
          style: TextStyle(color: ArborColors.white, fontSize: 16.0),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          child: ListTile(
            title: Text(
              widget.wallet.address,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: ArborColors.white70,
              ),
            ),
            trailing: Icon(Icons.copy),
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.wallet.address));
              showSnackBar(
                  context, 'Wallet address copied', ArborColors.deepGreen);
            },
          ),
        ),

        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$message"),
        duration: Duration(milliseconds: 1000),
        backgroundColor: color,
        elevation: 2,
        padding: EdgeInsets.all(
          10,
        ), // Inner padding for SnackBar content.
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

  Future<ui.Image> getLogoImage() async {
    final ByteData imageByteData = await rootBundle.load(AssetPaths.logo);
    image.Image baseImageSize =
        image.decodeImage(imageByteData.buffer.asUint8List())!;
    image.Image resizeImage =
        image.copyResize(baseImageSize, height: 30, width: 30);
    ui.Codec codec = await ui
        .instantiateImageCodec(image.encodePng(resizeImage) as Uint8List);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
