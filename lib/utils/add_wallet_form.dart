import 'package:arbor/models/fork.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:arbor/models/wallet.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:arbor/hive_constants.dart';

class KeygenResponse {
  final bool success;
  final String phrase;
  final String privateKey;
  final String publicKey;

  KeygenResponse({
    required this.success,
    required this.phrase,
    required this.privateKey,
    required this.publicKey,
  });

  factory KeygenResponse.fromJson(Map<String, dynamic> json) {
    return KeygenResponse(
      success: json['success'],
      phrase: json['phrase'],
      privateKey: json['private_key'],
      publicKey: json['public_key'],
    );
  }
}

class WalletResponse {
  WalletResponse({
    required this.success,
    required this.address,
    required this.fork,
  });

  final bool success;
  final String address;
  final ForkResponse fork;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
    success: json["success"],
    address: json["address"],
    fork: ForkResponse.fromJson(json["fork"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "address": address,
    "fork": fork.toJson(),
  };
}

class ForkResponse {
  ForkResponse({
    required this.name,
    required this.ticker,
    required this.unit,
    required this.precision,
  });

  final String name;
  final String ticker;
  final String unit;
  final int precision;

  factory ForkResponse.fromJson(Map<String, dynamic> json) => ForkResponse(
    name: json["name"],
    ticker: json["ticker"],
    unit: json["unit"],
    precision: json["precision"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "ticker": ticker,
    "unit": unit,
    "precision": precision,
  };
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

  late final Box box;
  late Future<Wallet> fetchedWallet;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  Future<Wallet> _fetchWalletKeys() async {
    final keygenResponse = await http.get(Uri.parse('https://farmforcrypto.com/api/v1/keygen'));

    //print('HEADERS: ${response.headers}');
    //print('BODY: ${response.body}');

    if (keygenResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      KeygenResponse keygen = KeygenResponse.fromJson(jsonDecode(keygenResponse.body));

      if (keygen.success == true) {
        // final walletResponse = await http.post(
        //   Uri.parse('https://farmforcrypto.com/api/v1/wallet'),
        //   headers: {
        //     "Content-Type": "application/x-www-form-urlencoded",
        //   },
        //   encoding: Encoding.getByName('utf-8'),
        //   body: {
        //     "public_key": keygen.publicKey,
        //     "fork": "xch",
        //   },
        // );
        // HACK
        final walletResponse = await http.get(Uri.parse('https://farmforcrypto.com/api/v1/wallet'));

        if (walletResponse.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.
          // HACK
          ForkResponse fork = ForkResponse(name: 'Chia', ticker: 'xch', unit: 'mojo', precision: 12);
          WalletResponse wallet = WalletResponse(success: true, address: 'xch16ezg9sjwmcf0n64r22qjdxgza02jwawptldys3yx53uw9t9f6eys2z4te7', fork: fork);
          // WalletResponse wallet = WalletResponse.fromJson(jsonDecode(walletResponse.body));
          // temp wallet model to be filled out/persisted later
          Wallet walletModel = Wallet(
            name: '',
            password: '',
            phrase: keygen.phrase,
            privateKey: keygen.privateKey,
            publicKey: keygen.publicKey,
            address: wallet.address,
            fork: Fork(name: fork.name, ticker: fork.ticker, unit: fork.unit, precision: fork.precision),
          );

          return walletModel;
        } else {
          String apiError = jsonDecode(keygenResponse.body)[0]['error'];
          throw Exception('Error: $apiError');
        }
      } else {
        String apiError = jsonDecode(keygenResponse.body)[0]['error'];
        throw Exception('Error: $apiError');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to create a wallet.');
    }
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
            // fetchedWallet = _fetchWalletKeys();
            // async() {
            fetchedWallet = _fetchWalletKeys();
            setState(() {
                _fetchingNewWalletKeys = true;
              });
          }
        },
        child: const Text('Add'),
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
