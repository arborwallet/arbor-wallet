import 'package:arbor/models/models.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/views/screens/home/expanded_home_page.dart';
import 'package:arbor/views/widgets/responsiveness/responsive.dart';
import 'package:flutter/material.dart';

class ExpandedHomeScreen extends StatefulWidget {
  final int index;
  final Wallet wallet;

  const ExpandedHomeScreen({
    required this.index,
    required this.wallet,
  });

  @override
  _ExpandedHomeScreenState createState() => _ExpandedHomeScreenState();
}

class _ExpandedHomeScreenState extends State<ExpandedHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArborColors.green,
      appBar: AppBar(
        title: Text(
          'Your Wallet',
          style: TextStyle(
            color: ArborColors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,false);
          },
          icon: Icon(
            Icons.arrow_back,
            color: ArborColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ArborColors.green,
      ),
      body: Responsive.isDesktop(context)
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*kIsWeb & Responsive.isDesktop(context)
                    ? ArborDrawer(
                        onWalletsTapped: () => Navigator.pop(context),
                        onSettingsTapped: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<Widget>(
                            builder: (context) => SettingsScreen(),
                          ),
                        ),
                      )
                    : Container(),*/
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                      color: ArborColors.black,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: ExpandedHomePage(
                          index: widget.index,
                          wallet: widget.wallet,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ExpandedHomePage(
                  index: widget.index,
                  wallet: widget.wallet,
                ),
              ),
            ),
    );
  }
}
