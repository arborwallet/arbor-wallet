import 'package:arbor/api/responses/wallet_address_response.dart';
import 'package:arbor/models/transaction.dart';

import '/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../responses.dart';
import 'api_service.dart';

class WalletService extends ApiService {
  WalletService({this.baseURL = ApiService.baseURL});

  final String baseURL;

  BaseResponse? baseResponse;

  // @GET("/v1/keygen") and @POST("v1/address") and @POST("v1/blockchain")
  Future<Wallet> createNewWallet()async{
    try{

      final keygenResponse = await http.get(Uri.parse('${baseURL}/v1/keygen')).timeout(Duration(milliseconds: 5000));
      if(keygenResponse.statusCode==200){
        KeygenResponse keygen =
        KeygenResponse.fromJson(jsonDecode(keygenResponse.body));

        final addressResponse = await http.post(
          Uri.parse('${baseURL}/v1/address'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'public_key': keygen.publicKey,
            'blockchain': 'xch',
          }),
        );

        if(addressResponse.statusCode==200){
          WalletAddressResponse walletAddressResponse =
          WalletAddressResponse.fromJson(jsonDecode(addressResponse.body));


          final blockchainResponse = await http.post(
            Uri.parse('${baseURL}/v1/blockchain'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'blockchain': 'xch',
            }),
          );

          if(blockchainResponse.statusCode==200){
            BlockchainResponse blockchainResponseModel =
            BlockchainResponse.fromJson(jsonDecode(blockchainResponse.body));

            Wallet wallet = Wallet(
              name: '',
              phrase: keygen.phrase,
              privateKey: keygen.privateKey,
              publicKey: keygen.publicKey,
              address: walletAddressResponse.address!,
              blockchain: Blockchain(
                  name: blockchainResponseModel.blockchainData!.name!,
                  ticker: blockchainResponseModel.blockchainData!.ticker!,
                  unit: blockchainResponseModel.blockchainData!.unit!,
                  precision: blockchainResponseModel.blockchainData!.precision!,
                  logo: blockchainResponseModel.blockchainData!.logo!,
                  network_fee: blockchainResponseModel.blockchainData!.blockchainFee!
              ),
              balance: 0,
            );

            return wallet;


          }else{
            throw Exception('${blockchainResponse.body}');
          }


        }else{
          throw Exception('${addressResponse.body}');
        }

      }else {
        throw Exception('${keygenResponse.body}');
      }

    }on Exception catch (e){
      throw Exception('ERROR : ${e.toString()}');
    }

  }

  // @POST("/v1/recover") and @POST("/v1/wallet") and @POST("v1/blockchain") and @POST("/v1/balance")
  Future<Wallet> recoverWallet(String phrase)async{
    try{

      final recoverKeyResponse = await http.post(
        Uri.parse('${baseURL}/v1/recover'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phrase': phrase,
        }),
      );
      if(recoverKeyResponse.statusCode==200){
        KeygenResponse keygen =
        KeygenResponse.fromJson(jsonDecode(recoverKeyResponse.body));

        final addressResponse = await http.post(
          Uri.parse('${baseURL}/v1/address'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'public_key': keygen.publicKey,
            'blockchain': 'xch',
          }),
        );

        if(addressResponse.statusCode==200){
          WalletAddressResponse walletAddressResponse =
          WalletAddressResponse.fromJson(jsonDecode(addressResponse.body));


          final blockchainResponse = await http.post(
            Uri.parse('${baseURL}/v1/blockchain'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'blockchain': 'xch',
            }),
          );

          if(blockchainResponse.statusCode==200){



            BlockchainResponse blockchainResponseModel =
            BlockchainResponse.fromJson(jsonDecode(blockchainResponse.body));

            final balanceResponse = await http.post(
              Uri.parse('${baseURL}/v1/balance'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'address': walletAddressResponse.address!,
              }),
            );

            if(balanceResponse.statusCode==200){
              BalanceResponse balance =
              BalanceResponse.fromJson(jsonDecode(balanceResponse.body));

              Wallet wallet = Wallet(
                name: '',
                phrase: keygen.phrase,
                privateKey: keygen.privateKey,
                publicKey: keygen.publicKey,
                address: walletAddressResponse.address!,
                blockchain: Blockchain(
                    name: blockchainResponseModel.blockchainData!.name!,
                    ticker: blockchainResponseModel.blockchainData!.ticker!,
                    unit: blockchainResponseModel.blockchainData!.unit!,
                    precision: blockchainResponseModel.blockchainData!.precision!,
                    logo: blockchainResponseModel.blockchainData!.logo!,
                    network_fee: blockchainResponseModel.blockchainData!.blockchainFee!
                ),
                balance: balance.balance!,
              );

              return wallet;
            }else{
              throw Exception('${balanceResponse.body}');
            }


          }else{
            throw Exception('${blockchainResponse.body}');
          }


        }else{
          throw Exception('${addressResponse.body}');
        }

      }else {
        throw Exception('${recoverKeyResponse.body}');
      }

    }on Exception catch (e){
      throw Exception('ERROR : ${e.toString()}');
    }

  }

  // @POST("/v1/balance")
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

        return balanceResponse.balance!;
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
  Future<List<Transaction>> fetchWalletTransactions(String walletAddress) async {
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
        TransactionListResponse transactionListResponse =
        TransactionListResponse.fromJson(jsonDecode(transactionsData.body));


          List<Transaction> transactionList = [];
          for (Transactions transactions in transactionListResponse.transactions!) {

            for(TransactionsResponse t in transactions.transactions!){
              Transaction transaction = Transaction(
                  type: transactions.type!,
                  timestamp: transactions.timestamp!,
                  block: transactions.block!,
                  address: ((t.sender != null) ? t.sender! : t.destination!),
                  amount: t.amount!, fee:transactions.fee!);
              transactionList.add(transaction);
            }


          }

          return transactionList;

      } else {

        throw Exception('${transactionsData.body}');
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }



  // @POST("/v1/send")
  Future<dynamic> sendXCH(
      {required String privateKey,
      required var amount,
      required String address,required int fee}) async {
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
        return "${responseData.body}";
      }
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
