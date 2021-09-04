import 'package:flutter/material.dart';
import 'package:gallery/core/constants/hive_constants.dart';
import 'package:gallery/core/models/models.dart';
import 'package:hive/hive.dart';

class UpdateWalletForm extends StatefulWidget {
  final int index;
  final Wallet wallet;

  const UpdateWalletForm({
    required this.index,
    required this.wallet,
  });

  @override
  _UpdateWalletFormState createState() => _UpdateWalletFormState();
}

class _UpdateWalletFormState extends State<UpdateWalletForm> {
  final _walletFormKey = GlobalKey<FormState>();

  late final _nameController;
  late final _passwordController;
  late final Box box;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  // Update info of wallet box
  void _updateInfo() {
    var existingWallet = widget.wallet;
    var newWallet = Wallet(
      name: _nameController.text,
      password: _passwordController.text,
      phrase: existingWallet.phrase,
      privateKey: existingWallet.privateKey,
      publicKey: existingWallet.publicKey,
      address: existingWallet.address,
      fork: existingWallet.fork,
      balance: existingWallet.balance,
    );

    box.putAt(widget.index, newWallet);

    print('Info updated in box!');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box(HiveConstants.walletBox);
    _nameController = TextEditingController(text: widget.wallet.name);
    _passwordController = TextEditingController(text: widget.wallet.password);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _walletFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Name'),
          TextFormField(
            controller: _nameController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Wallet password'),
          TextFormField(
            controller: _passwordController,
            validator: _fieldValidator,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
            child: Container(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_walletFormKey.currentState!.validate()) {
                    _updateInfo();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Update'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}