
import 'package:flutter/material.dart';
import '/models/models.dart';
import '/utils/expanded_info_page.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Send It BRO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpandedInfoPage(
          index: widget.index,
          wallet: widget.wallet,
        ),
      ),
    );
  }
}
