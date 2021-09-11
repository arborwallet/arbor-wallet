import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/views/widgets/arbor_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arbor/constants.dart';

class NoEncryptionAvailableScreen extends StatelessWidget {
  const NoEncryptionAvailableScreen({Key? key, required this.message}) : super(key: key);
  final String message;
  static const VIEW_PADDING = 40.0;

  void _launchURL({required String url}) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: ArborColors.green,
          body: SafeArea(
            top: true,
            bottom: true,
            left: true,
            right: true,
            child: Padding(
                padding: EdgeInsets.fromLTRB(VIEW_PADDING, 0.0, VIEW_PADDING, 0.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: Image.asset(
                            AssetPaths.logo,
                          ),
                        ),
                      ),
                      Spacer(flex: 2,),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: ArborButton(
                              onPressed: () {
                                _launchURL(url: ArborConstants.baseWebsiteURL);
                              },
                              title: 'Contact Us',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40,),
                    ],
                  ),
                )
            ),
          )
      ),
    );
  }
}