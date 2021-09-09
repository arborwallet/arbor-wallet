import 'package:flutter/material.dart';
import '/utils/add_wallet_form.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddWalletForm(),
      ),
    );
  }
}
