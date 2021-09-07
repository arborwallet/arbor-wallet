import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arbor/models/models.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:share_plus/share_plus.dart';

import 'dart:ui' as ui;
import 'package:image/image.dart' as nonui;

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
  static GlobalKey globalKey = new GlobalKey(debugLabel: 'wallet_receive_screen');

  static const double PASSWORD_PADDING=40;

  void _showShareSheet() async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = (await getTemporaryDirectory()).path;
      var file = await new File('${tempDir}/wallet-receive-address.png').create();
      await file.writeAsBytes(pngBytes);

      // // Attempt to remove transparency ( but the alpha channel is removed and the image is black instead )
      // nonui.Image? jpgImage = nonui.decodeImage(file.readAsBytesSync());
      // file = await new File('${tempDir}/wallet-receive-address1.png').create();
      // if (jpgImage != null) {
      //   // jpgImage = nonui.colorOffset(jpgImage, alpha: 0);
      //   // jpgImage = nonui.drawPixel(jpgImage, 0, 0, 0, 0x00);
      //
      //   await file.writeAsBytes(nonui.encodeJpg(jpgImage));
      // }

      await Share.shareFiles([file.path]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Receive ${widget.wallet.fork.name} (${widget.wallet.name})'),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(PASSWORD_PADDING, 0.0, PASSWORD_PADDING, 0.0),
          child: RepaintBoundary(
            key: globalKey,
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: QrImage(
                    data: widget.wallet.address,
                    version: QrVersions.auto,
                    embeddedImage: AssetImage('assets/images/logo.png'),
                  ),
                ),
                SizedBox(height: 20,),
                Flexible(
                    flex: 1,
                    child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Tap to copy your ${widget.wallet.fork.name} light wallet address:',
                              style: TextStyle(fontSize: 20.0),),
                            InkWell(
                              child: ListTile(
                                title: Text(
                                  widget.wallet.address,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                trailing: Icon(Icons.copy),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: widget.wallet.address));
                                },
                              ),
                            ),
                          ],
                        )
                    )
                ),
                // SizedBox(height: 20,),
                // Row(
                //   children: <Widget>[
                //     Flexible(
                //       flex: 1,
                //       fit: FlexFit.tight,
                //       child: ArborButton(
                //         onPressed: () {
                //           _showShareSheet();
                //         },
                //         title: 'Share',
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 40,),
              ],
            ),
          )
        ),
      );
  }
}
