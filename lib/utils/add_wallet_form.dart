import 'package:flutter/material.dart';
import 'package:gallery/api/services.dart';
import 'package:gallery/hive_constants.dart';
import 'package:gallery/models/fork.dart';
import 'package:gallery/models/wallet.dart';
import 'package:hive/hive.dart';

import 'dart:async';


class AddWalletForm extends StatefulWidget {
  const AddWalletForm({Key? key}) : super(key: key);

  @override
  _AddWalletFormState createState() => _AddWalletFormState();
}

class _AddWalletFormState extends State<AddWalletForm> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _walletFormKey = GlobalKey<FormState>();

  final walletService = WalletService();
  bool _fetchingNewWalletKeys = false;

  late final Box box;
  late Future<Wallet> fetchedWallet;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  // Add info to wallet box
  _addInfo({required String phrase, required String privateKey, required String publicKey, required String address, required Fork fork}) async {
    Wallet newWallet = Wallet(
      name: _nameController.text,
      password: _passwordController.text,
      phrase: phrase,
      privateKey: privateKey,
      publicKey: publicKey,
      address: address,
      fork: fork,
      balance: 0,
    );

    box.add(newWallet);
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box(HiveConstants.walletBox);
  }

  Widget _buildSaveWalletToLocalStore() {
    assert(_fetchingNewWalletKeys);
    return FutureBuilder<Wallet>(
      future: fetchedWallet,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return Text(snapshot.data!.title);
          _addInfo(
            phrase: snapshot.data!.phrase,
            privateKey: snapshot.data!.privateKey,
            publicKey: snapshot.data!.publicKey,
            address: snapshot.data!.address,
            fork: snapshot.data!.fork,
          );
          Future.delayed(Duration.zero, () async {
            Navigator.of(context).pop();
          });


          return const Text('success');
        } else if (snapshot.hasError) {
          // TODO: Show dialog not text
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildCreateNewWalletButton() {
    assert(!_fetchingNewWalletKeys);
    return Container(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_walletFormKey.currentState!.validate()) {
            fetchedWallet = walletService.fetchWalletKeys();
            setState(() {
                _fetchingNewWalletKeys = true;
              });
          }
        },
        child: const Text('Create'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _walletFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Wallet Name'),
          TextFormField(
            controller: _nameController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Wallet Password'),
          TextFormField(
            controller: _passwordController,
            validator: _fieldValidator,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
            child: Center(
              child: _fetchingNewWalletKeys ? _buildSaveWalletToLocalStore() : _buildCreateNewWalletButton(),
            )
          ),
        ],
      ),
    );
  }
}
