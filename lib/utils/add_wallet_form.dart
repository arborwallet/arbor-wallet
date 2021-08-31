import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:arbor/models/wallet.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:arbor/hive_constants.dart';

class WalletResponse {
  final bool success;
  final String phrase;
  final String privateKey;
  final String publicKey;

  WalletResponse({
    required this.success,
    required this.phrase,
    required this.privateKey,
    required this.publicKey,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'],
      phrase: json['phrase'],
      privateKey: json['private_key'],
      publicKey: json['public_key'],
    );
  }
}



class AddWalletForm extends StatefulWidget {
  const AddWalletForm({Key? key}) : super(key: key);

  @override
  _AddWalletFormState createState() => _AddWalletFormState();
}

class _AddWalletFormState extends State<AddWalletForm> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _walletFormKey = GlobalKey<FormState>();

  bool _fetchingNewWalletKeys = false;
  // ValueNotifier _fetchingNewWalletKeys = ValueNotifier(false);

  late final Box box;
  late Future<WalletResponse> fetchedWallet;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  Future<WalletResponse> _fetchWalletKeys() async {
    final response = await http
        .get(Uri.parse('https://farmforcrypto.com/api/v1/keygen'));

    print('HEADERS: ${response.headers}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return WalletResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch generated wallet keys.');
    }
  }

  // Add info to wallet box
  _addInfo({required String phrase, required String privateKey, required String publicKey}) async {
    Wallet newWallet = Wallet(
      name: _nameController.text,
      password: _passwordController.text,
      phrase: phrase,
      privateKey: privateKey,
      publicKey: publicKey,
    );

    box.add(newWallet);
    print('Info added to box!');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box(HiveConstants.walletBox);
  }

  Widget _buildSaveWalletToLocalStore() {
    assert(_fetchingNewWalletKeys);
    return new FutureBuilder<WalletResponse>(
      future: fetchedWallet,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return Text(snapshot.data!.title);
          _addInfo(
            phrase: snapshot.data!.phrase,
            privateKey: snapshot.data!.privateKey,
            publicKey: snapshot.data!.publicKey,
          );
          Future.delayed(Duration.zero, () async {
            Navigator.of(context).pop();
          });


          return Text('success');
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
    return new Container(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_walletFormKey.currentState!.validate()) {
            // fetchedWallet = _fetchWalletKeys();
            // async() {
            fetchedWallet = _fetchWalletKeys();
            setState(() {
                _fetchingNewWalletKeys = true;
              });
          }
        },
        child: Text('Add'),
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
          Text('Wallet Name'),
          TextFormField(
            controller: _nameController,
            validator: _fieldValidator,
          ),
          SizedBox(height: 24.0),
          Text('Wallet Password'),
          TextFormField(
            controller: _passwordController,
            validator: _fieldValidator,
          ),
          Spacer(),
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
