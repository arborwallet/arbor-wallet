import 'dart:convert';
import 'dart:typed_data';

import 'package:arbor/api/responses/record_response.dart';
import 'package:arbor/api/responses/records_response.dart';
import 'package:arbor/api/responses/transaction_response.dart';
import 'package:arbor/bls/ec.dart';
import 'package:arbor/bls/private_key.dart';
import 'package:arbor/bls/schemes.dart';
import 'package:arbor/clvm/program.dart';
import 'package:arbor/core/utils/wallet_utils.dart';
import 'package:arbor/models/transaction.dart';
import 'package:bech32m/bech32m.dart';
import 'package:bip39/bip39.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;

import '/models/models.dart';
import '../responses.dart';
import 'api_service.dart';

class WalletService extends ApiService {
  @override
  String baseURL = 'https://dev.arborwallet.com/api';

  Future<Wallet> createNewWallet() async {
    var mnemonic = generateMnemonic();
    var seed = mnemonicToSeed(mnemonic);
    var privateKey = PrivateKey.fromSeed(seed);
    var publicKey = privateKey.getG1();
    var puzzle = walletPuzzle.curry([Program.atom(publicKey.toBytes())]);
    var puzzleHash = puzzle.hash();
    var address = segwit.encode(Segwit('xch', puzzleHash));

    try {
      final blockchainResponse = await http.post(
        Uri.parse('$baseURL/v2/blockchain'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'blockchain': 'xch',
        }),
      );

      if (blockchainResponse.statusCode == 200) {
        BlockchainResponse blockchainResponseModel =
            BlockchainResponse.fromJson(jsonDecode(blockchainResponse.body));

        Wallet wallet = Wallet(
          name: '',
          phrase: mnemonic,
          privateKey: const HexEncoder().convert(privateKey.toBytes()),
          publicKey: const HexEncoder().convert(publicKey.toBytes()),
          address: address,
          blockchain: Blockchain(
              name: blockchainResponseModel.blockchainData.name,
              ticker: blockchainResponseModel.blockchainData.ticker,
              unit: blockchainResponseModel.blockchainData.unit,
              precision: blockchainResponseModel.blockchainData.precision,
              logo: blockchainResponseModel.blockchainData.logo,
              network_fee:
                  blockchainResponseModel.blockchainData.blockchainFee),
          balance: 0,
        );

        return wallet;
      } else {
        throw Exception(blockchainResponse.body);
      }
    } on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }
  }

  Future<Wallet> recoverWallet(String phrase) async {
    var seed = mnemonicToSeed(phrase);
    var privateKey = PrivateKey.fromSeed(seed);
    var publicKey = privateKey.getG1();
    var puzzle = walletPuzzle.curry([Program.atom(publicKey.toBytes())]);
    var puzzleHash = puzzle.hash();
    var address = segwit.encode(Segwit('xch', puzzleHash));

    try {
      final blockchainResponse = await http.post(
        Uri.parse('$baseURL/v2/blockchain'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'blockchain': 'xch',
        }),
      );

      if (blockchainResponse.statusCode == 200) {
        BlockchainResponse blockchainResponseModel =
            BlockchainResponse.fromJson(jsonDecode(blockchainResponse.body));

        final balanceResponse = await http.post(
          Uri.parse('$baseURL/v2/balance'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'address': address,
          }),
        );

        if (balanceResponse.statusCode == 200) {
          BalanceResponse balance =
              BalanceResponse.fromJson(jsonDecode(balanceResponse.body));

          Wallet wallet = Wallet(
            name: '',
            phrase: phrase,
            privateKey: const HexEncoder().convert(privateKey.toBytes()),
            publicKey: const HexEncoder().convert(publicKey.toBytes()),
            address: address,
            blockchain: Blockchain(
                name: blockchainResponseModel.blockchainData.name,
                ticker: blockchainResponseModel.blockchainData.ticker,
                unit: blockchainResponseModel.blockchainData.unit,
                precision: blockchainResponseModel.blockchainData.precision,
                logo: blockchainResponseModel.blockchainData.logo,
                network_fee:
                    blockchainResponseModel.blockchainData.blockchainFee),
            balance: balance.balance,
          );

          return wallet;
        } else {
          throw Exception(balanceResponse.body);
        }
      } else {
        throw Exception(blockchainResponse.body);
      }
    } on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }
  }

  // @POST("/v2/balance")
  Future<int> fetchWalletBalance(String walletAddress) async {
    try {
      final balanceData = await http.post(
        Uri.parse('$baseURL/v2/balance'),
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
        var baseResponse = BaseResponse.fromJson(jsonDecode(balanceData.body));
        throw Exception('ERROR: ${baseResponse.error}.');
      }
    } on Exception catch (e) {
      throw Exception('${e.toString()}.');
    }
  }

  // @GET("/v2/transactions")
  Future<TransactionsGroup> fetchWalletTransactions(
      String walletAddress) async {
    try {
      final transactionsData = await http.post(
        Uri.parse('$baseURL/v2/transactions'),
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

        List<Transaction> transactionsList = [];
        for (TransactionGroupResponse transactions
            in transactionListResponse.transactions) {
          for (TransactionsResponse t in transactions.transactions) {
            Transaction transaction = Transaction(
                type: transactions.type,
                timestamp: transactions.timestamp,
                block: transactions.block,
                address: ((t.sender != null) ? t.sender! : t.destination!),
                amount: t.amount,
                fee: transactions.fee,
                baseAddress: walletAddress);
            transactionsList.add(transaction);
          }
        }
        return TransactionsGroup(
            address: walletAddress, transactionsList: transactionsList);
      } else {
        throw Exception(transactionsData.body);
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<RecordsResponse> fetchRecords(String address) async {
    final responseData = await http.post(Uri.parse('$baseURL/v2/records'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'address': address,
        }));
    if (responseData.statusCode == 200) {
      return RecordsResponse.fromJson(jsonDecode(responseData.body));
    } else {
      throw StateError(responseData.body);
    }
  }

  Future<void> sendTransaction(Map<String, dynamic> spendBundle) async {
    final responseData = await http.post(Uri.parse('$baseURL/v2/transaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(spendBundle));
    if (responseData.statusCode != 200) {
      throw StateError(responseData.body);
    }
  }

  Future<String> sendXCH(
      {required String privateKey,
      required String destination,
      required int amount,
      required int fee}) async {
    var totalAmount = amount + fee;
    var privateKeyObject = PrivateKey.fromBytes(
        Uint8List.fromList(const HexDecoder().convert(privateKey)));
    var publicKeyObject = privateKeyObject.getG1();
    var wallet = walletPuzzle.curry([Program.atom(publicKeyObject.toBytes())]);
    var puzzleHash = wallet.hash();
    var address = segwit.encode(Segwit('xch', puzzleHash));
    try {
      var recordsResponse = await fetchRecords(address);
      var records = recordsResponse.records;
      records.sort((a, b) => b.coin.amount - a.coin.amount);
      List<RecordResponse> spendRecords =
          aggregateRecords(records, totalAmount);
      var spendAmount = spendRecords.fold<int>(
          0, (previousValue, element) => previousValue + element.coin.amount);
      List<JacobianPoint> signatures = [];
      List<Map<String, dynamic>> spends = [];
      var target = true;
      var destinationHash = segwit.decode(destination).program;
      var change = spendAmount - amount - fee;
      for (var record in spendRecords) {
        var conditions = Program.list(target
            ? [
                  Program.list([
                    Program.int(51),
                    Program.atom(Uint8List.fromList(destinationHash)),
                    Program.int(amount)
                  ])
                ] +
                (change > 0
                    ? [
                        Program.list([
                          Program.int(51),
                          Program.atom(puzzleHash),
                          Program.int(change)
                        ])
                      ]
                    : [])
            : []);
        var solution = Program.list([conditions]);
        target = false;
        var coinId = getCoinId(record);
        signatures.add(AugSchemeMPL.sign(
            privateKeyObject,
            Uint8List.fromList(conditions.hash() +
                coinId +
                const HexDecoder().convert(aggSigMeExtraData))));
        spends.add({
          'coin': record.coin.toJson(),
          'puzzle_reveal': const HexEncoder().convert(wallet.serialize()),
          'solution': const HexEncoder().convert(solution.serialize())
        });
      }
      var aggregate = AugSchemeMPL.aggregate(signatures);
      await sendTransaction({
        'spend_bundle': {
          'coin_spends': spends,
          'aggregated_signature':
              const HexEncoder().convert(aggregate.toBytes())
        },
        'blockchain': 'xch'
      });
      return 'success';
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
