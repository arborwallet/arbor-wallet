import 'package:arbor/models/models.dart';
import 'package:arbor/utils/expanded_info_page.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/views/widgets/responsiveness/responsive.dart';
import 'package:flutter/material.dart';

class ExpandedInfoScreen extends StatefulWidget {
  final int index;
  final Wallet wallet;

  const ExpandedInfoScreen({
    required this.index,
    required this.wallet,
  });

  @override
  _ExpandedInfoScreenState createState() => _ExpandedInfoScreenState();
}

class _ExpandedInfoScreenState extends State<ExpandedInfoScreen> {
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
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: ArborColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ArborColors.green,
      ),
      body: Responsive.isDesktop(context) || Responsive.isTablet(context)
          ? Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: ExpandedInfoPage(
                      index: widget.index,
                      wallet: widget.wallet,
                    ),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ExpandedInfoPage(
                  index: widget.index,
                  wallet: widget.wallet,
                ),
              ),
            ),
    );
  }
}
