import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';


class PasswordQRShareSheet extends StatefulWidget {
  const PasswordQRShareSheet({
    required this.walletPhrase,
  });

  final String walletPhrase;

  @override
  _PasswordQRShareSheetState createState() => _PasswordQRShareSheetState(walletPhrase);
}

class _PasswordQRShareSheetState extends State<PasswordQRShareSheet> {
  _PasswordQRShareSheetState(this.walletPhrase);

  static const double PASSWORD_PADDING=20;
  final String walletPhrase;
  bool _isPasswordPlaintext = false;

  void _showPasswordInPlainText() {
    setState(() {
      if (!_isPasswordPlaintext) {
        _isPasswordPlaintext = true;
      } else {
        _isPasswordPlaintext = false;
      }
    });
  }
  String _passwordString() {
    return _isPasswordPlaintext ? widget.walletPhrase : '*' * widget.walletPhrase.toString().length;
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.94,
        minChildSize: 0.84,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text('Wallet Sync'),
            ),
            floatingActionButton: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                        heroTag: "show",
                        backgroundColor: Colors.lightGreen,
                        child: _isPasswordPlaintext ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                        onPressed: () {
                          _showPasswordInPlainText();
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      heroTag: "close",
                      backgroundColor: Colors.lightGreen,
                      child: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            ),
            body: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(PASSWORD_PADDING),
                    child: QrImage(
                      data: widget.walletPhrase,
                      version: QrVersions.auto,
                      embeddedImage: AssetImage('assets/images/logo.png'),
                      // size: 400.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(PASSWORD_PADDING, 0.0, PASSWORD_PADDING, 0.0),
                    child: InkWell(
                        child: ListTile(
                          title: Text(
                              _passwordString(),
                              // style: TextStyle(fontSize: 30.0),
                          ),
                          trailing: Icon(Icons.copy),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: widget.walletPhrase));
                          },
                        ),
                    ),
                  ),
                ],
              )
            ),
          );
        }
    );
  }
}