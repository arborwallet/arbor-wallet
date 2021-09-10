import '/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../responses.dart';
import 'api_service.dart';

class WalletService extends ApiService {
  WalletService({this.baseURL = ApiService.baseURL});

  final String baseURL;

  // @GET("/v1/keygen") and @POST("v1/wallet")
  Future<Wallet> fetchWalletKeys() async {
    final keygenResponse =
        await http.get(Uri.parse('${baseURL}/api/v1/keygen'));

    // print('HEADERS: ${keygenResponse.headers}');
    // print('BODY: ${keygenResponse.body}');

    if (keygenResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      KeygenResponse keygen =
          KeygenResponse.fromJson(jsonDecode(keygenResponse.body));

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
          WalletResponse wallet =
              WalletResponse.fromJson(jsonDecode(walletResponse.body));
          // temp wallet model to be filled out/persisted later
          Wallet walletModel = Wallet(
            name: '',
            password: '',
            phrase: keygen.phrase,
            privateKey: keygen.privateKey,
            publicKey: keygen.publicKey,
            address: wallet.address,
            fork: Fork(
                name: wallet.fork.name,
                ticker: wallet.fork.ticker,
                unit: wallet.fork.unit,
                precision: wallet.fork.precision),
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

  // @GET("/v1/balance")
  Future<int> fetchWalletBalance(String walletAddress) async {
    final balanceData = await http.post(
      Uri.parse('${baseURL}/api/v1/balance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'address': walletAddress,
      }),
    );

    if (balanceData.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      BalanceResponse balanceResponse =
          BalanceResponse.fromJson(jsonDecode(balanceData.body));

      if (balanceResponse.success == true) {
        return balanceResponse.balance;
      } else {
        throw Exception('Error: ${balanceResponse.error}');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Oops. We could not retrieve the balance at this time. Try again later.');
    }
  }

  // @GET("/v1/transactions")
  Future<Transactions> fetchWalletTransactions(String walletAddress) async {
    final transactionsData = await http.post(
      Uri.parse('${baseURL}/api/v1/transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'address': walletAddress,
      }),
    );

    if (transactionsData.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      TransactionsResponse tr =
          TransactionsResponse.fromJson(jsonDecode(transactionsData.body));

      if (tr.success == true) {
        List<Transaction> transactionList = [];
        for (TransactionResponse tr in tr.transactions) {
          Transaction transaction = Transaction(
              type: tr.type,
              timestamp: tr.timestamp,
              block: tr.block,
              address: ((tr.sender != null) ? tr.sender! : tr.destination!),
              amount: tr.amount);
          transactionList.add(transaction);
        }

        Transactions transactionsModel = Transactions(
            walletAddress: walletAddress,
            list: transactionList,
            fork: Fork(
                name: tr.fork.name,
                ticker: tr.fork.ticker,
                unit: tr.fork.unit,
                precision: tr.fork.precision));
        return transactionsModel;
      } else {
        throw Exception('Error: ${tr.error}');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Oops. We could not retrieve the balance at this time. Try again later.');
    }
  }

  // @POST("/v1/recover") and @POST("v1/wallet")
  Future<Wallet> recoverWallet(String phrase) async {
    try {
      final recoverKeyResponse = await http.post(
        Uri.parse('${baseURL}/api/v1/recover'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phrase': phrase,
        }),
      );
      if (recoverKeyResponse.statusCode == 200) {
        KeygenResponse keygen =
            KeygenResponse.fromJson(jsonDecode(recoverKeyResponse.body));
        if (keygen.success == true) {
          final getWalletResponse = await http.post(
            Uri.parse('${baseURL}/api/v1/wallet'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'public_key': keygen.publicKey,
              'fork': 'xch',
            }),
          );

          if (getWalletResponse.statusCode == 200) {
            WalletResponse walletResponse =
                WalletResponse.fromJson(jsonDecode(getWalletResponse.body));

            final getWalletBalanceResponse = await http.post(
              Uri.parse('${baseURL}/api/v1/balance'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'address': walletResponse.address,
              }),
            );
            // temp wallet model to be filled out/persisted later
            if (getWalletBalanceResponse.statusCode == 200) {
              BalanceResponse balanceResponse = BalanceResponse.fromJson(
                  jsonDecode(getWalletBalanceResponse.body));

              Wallet wallet = Wallet(
                name: '',
                password: '',
                phrase: keygen.phrase,
                privateKey: keygen.privateKey,
                publicKey: keygen.publicKey,
                address: walletResponse.address,
                fork: Fork(
                    name: walletResponse.fork.name,
                    ticker: walletResponse.fork.ticker,
                    unit: walletResponse.fork.unit,
                    precision: walletResponse.fork.precision),
                balance: balanceResponse.balance,
              );

              return wallet;
            } else {
              String apiError =
                  jsonDecode(getWalletBalanceResponse.body)['error'];
              throw Exception('Error: $apiError');
            }
          } else {
            String apiError = jsonDecode(recoverKeyResponse.body)[0]['error'];
            throw Exception('Error: $apiError');
          }
        }
        {
          String apiError = jsonDecode(recoverKeyResponse.body)[0]['error'];
          throw Exception('Error: $apiError');
        }
      } else {
        throw Exception('Failed to restore wallet.');
      }
    } catch (e) {
      throw Exception('${e.toString()}');
    }
  }

  // @POST("/v1/send")
  Future<dynamic> sendXCH(
      {required String privateKey,required var amount,required String address})async{
    try{
      final responseData = await http.post(
        Uri.parse('${baseURL}/api/v1/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'private_key': privateKey,
          'amount':amount,
          'destination':address
        }),
      );

      print('RESPONSE: ${responseData.body.toString()}');
      if(responseData.statusCode==200){
        if(responseData.body.toString().contains('fork')){
          return 'success';
        }else{
          BaseResponse sendResponse = BaseResponse.fromJson(jsonDecode(responseData.body));
          return sendResponse;
        }
      }else{
        return responseData.body.toString();
      }
    }on Exception catch(e){
      return e.toString();
    }
  }
}
