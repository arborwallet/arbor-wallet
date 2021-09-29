import '/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../responses.dart';
import 'api_service.dart';

class WalletService extends ApiService {
  WalletService({this.baseURL = ApiService.baseURL});

  final String baseURL;

  BaseResponse? baseResponse;

  // @GET("/v1/keygen") and @POST("v1/wallet")
  Future<Wallet> fetchWalletKeys() async {
    try {
      final keygenResponse = await http.get(Uri.parse('${baseURL}/v1/keygen')).timeout(Duration(milliseconds: 5000));

      // print('HEADERS: ${keygenResponse.headers}');

      if (keygenResponse.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        KeygenResponse keygen =
            KeygenResponse.fromJson(jsonDecode(keygenResponse.body));

        final walletResponse = await http.post(
          Uri.parse('${baseURL}/v1/wallet'),
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
          baseResponse = BaseResponse.fromJson(jsonDecode(keygenResponse.body));
          throw Exception('${baseResponse}');
        }
      } else {
        baseResponse = BaseResponse.fromJson(jsonDecode(keygenResponse.body));
        throw Exception('${baseResponse}');
      }
    } on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }
  }

  // @GET("/v1/balance")
  Future<int> fetchWalletBalance(String walletAddress) async {
    try {
      final balanceData = await http.post(
        Uri.parse('${baseURL}/v1/balance'),
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

        return balanceResponse.balance;
      } else {
        // If the server did not return a 200 OK response,
        baseResponse = BaseResponse.fromJson(jsonDecode(balanceData.body));
        throw Exception('ERROR: ${baseResponse!.error}.');
      }
    } on Exception catch (e) {
      throw Exception('${e.toString()}.');
    }
  }

  // @GET("/v1/transactions")
  Future<Transactions> fetchWalletTransactions(String walletAddress) async {
    try {
      final transactionsData = await http.post(
        Uri.parse('${baseURL}/v1/transactions'),
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
        baseResponse = BaseResponse.fromJson(jsonDecode(transactionsData.body));

        throw Exception('${baseResponse!.error}');
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  // @POST("/v1/recover") and @POST("/v1/wallet") and @POST("/v1/balance")
  Future<dynamic> recoverWallet(String phrase) async {
    try {
      final recoverKeyResponse = await http.post(
        Uri.parse('${baseURL}/v1/recover'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phrase': phrase,
        }),
      );

      print(
          'BODY: ${recoverKeyResponse.body} ${recoverKeyResponse.statusCode}');

      if (recoverKeyResponse.statusCode == 200) {
        KeygenResponse keygen =
            KeygenResponse.fromJson(jsonDecode(recoverKeyResponse.body));

        final getWalletResponse = await http.post(
          Uri.parse('${baseURL}/v1/wallet'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'public_key': keygen.publicKey,
            'fork': 'xch',
          }),
        );

        print(
            'BODY: ${getWalletResponse.body} ${getWalletResponse.statusCode}');

        if (getWalletResponse.statusCode == 200) {
          WalletResponse walletResponse =
              WalletResponse.fromJson(jsonDecode(getWalletResponse.body));

          final getWalletBalanceResponse = await http.post(
            Uri.parse('${baseURL}/v1/balance'),
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
            BaseResponse baseResponse = BaseResponse.fromJson(
                jsonDecode(getWalletBalanceResponse.body));
            return baseResponse.error;
          }
        } else {
          BaseResponse baseResponse =
              BaseResponse.fromJson(jsonDecode(getWalletResponse.body));
          return baseResponse.error;
        }
      } else {
        baseResponse =
            BaseResponse.fromJson(jsonDecode(recoverKeyResponse.body));
        return '${baseResponse!.error}';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // @POST("/v1/send")
  Future<dynamic> sendXCH(
      {required String privateKey,
      required var amount,
      required String address,var fee=1}) async {
    try {
      final responseData = await http.post(
        Uri.parse('${baseURL}/v1/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'private_key': privateKey,
          'amount': amount,
          'destination': address,
          'fee': fee
        }),
      );

      print(
          'RESPONSE: ${responseData.body.toString()}  ${responseData.statusCode}');
      if (responseData.statusCode == 200) {
        return 'success';
      } else {
        baseResponse = BaseResponse.fromJson(jsonDecode(responseData.body));
        return baseResponse;
      }
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
