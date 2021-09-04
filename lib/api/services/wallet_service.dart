import "package:arbor/api/services/api_service.dart";
import 'package:arbor/api/responses.dart';
import 'package:arbor/models/models.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class WalletService extends ApiService {
  WalletService(
    {this.baseURL = ApiService.baseURL}
  );

  final String baseURL;

  // @GET("/v1/keygen") and @POST("v1/wallet")
  Future<Wallet> fetchWalletKeys() async {
    final keygenResponse = await http.get(Uri.parse('${baseURL}/api/v1/keygen'));

    // print('HEADERS: ${keygenResponse.headers}');
    // print('BODY: ${keygenResponse.body}');

    if (keygenResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      KeygenResponse keygen = KeygenResponse.fromJson(jsonDecode(keygenResponse.body));

      if (keygen.success == true) {
        final walletResponse = await http.post(
          Uri.parse('${baseURL}/api/v1/wallet'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'public_key': keygen.publicKey,
            'fork': 'xch',
          }),
        );

        if (walletResponse.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.
          WalletResponse wallet = WalletResponse.fromJson(jsonDecode(walletResponse.body));
          // temp wallet model to be filled out/persisted later
          Wallet walletModel = Wallet(
            name: '',
            password: '',
            phrase: keygen.phrase,
            privateKey: keygen.privateKey,
            publicKey: keygen.publicKey,
            address: wallet.address,
            fork: Fork(name: wallet.fork.name, ticker: wallet.fork.ticker, unit: wallet.fork.unit, precision: wallet.fork.precision),
            balance: 0,
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
}