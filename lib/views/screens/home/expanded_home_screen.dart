import 'package:arbor/models/models.dart';
import 'package:arbor/views/screens/home/expanded_home_page.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
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
    return Container(
      color: ArborColors.green,
      child: SafeArea(
        child: Scaffold(
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ExpandedHomePage(
                index: widget.index,
                wallet: widget.wallet,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
