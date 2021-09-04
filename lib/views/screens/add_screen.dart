import 'package:flutter/material.dart';
import 'package:gallery/views/widgets/form/add_wallet_form.dart';

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
        title: const Text('New Wallet'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: AddWalletForm(),
      ),
    );
  }
}