import 'dart:convert';
import 'dart:typed_data';

import 'package:arbor/api/responses/record_response.dart';
import 'package:arbor/api/responses/records_response.dart';
import 'package:arbor/api/responses/transaction_response.dart';
import 'package:arbor/bls/ec.dart';
import 'package:arbor/bls/private_key.dart';
import 'package:arbor/bls/schemes.dart';
import 'package:arbor/clvm/program.dart';
import 'package:arbor/core/utils/local_signer.dart';
import 'package:arbor/core/utils/puzzles.dart';
import 'package:arbor/models/transaction.dart';
import 'package:bech32m/bech32m.dart';
import 'package:bip39/bip39.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;

import '/models/models.dart';
import '../responses.dart';
import 'api_service.dart';

class WalletService extends ApiService {
  WalletService({this.baseURL = ApiService.baseURL});

  final String baseURL;

  Future<Wallet> createNewWallet() async {

    String mnemonic="";
    WalletKeysAndAddress? walletKeysAndAddress;

    try{
      mnemonic = LocalSigner.generateWalletMnemonic();
      walletKeysAndAddress=LocalSigner.convertMnemonicToKeysAndAddress(mnemonic);
    }on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }

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
          privateKey: const HexEncoder().convert(walletKeysAndAddress.privateKey.toBytes()),
          publicKey: const HexEncoder().convert(walletKeysAndAddress.publicKey.toBytes()),
          address: walletKeysAndAddress.address,
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


    WalletKeysAndAddress? walletKeysAndAddress;

    try{

      walletKeysAndAddress=LocalSigner.convertMnemonicToKeysAndAddress(phrase);
    }on Exception catch (e) {
      throw Exception('ERROR : ${e.toString()}');
    }

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
            'address': walletKeysAndAddress.address,
          }),
        );

        if (balanceResponse.statusCode == 200) {
          BalanceResponse balance =
              BalanceResponse.fromJson(jsonDecode(balanceResponse.body));

          Wallet wallet = Wallet(
            name: '',
            phrase: phrase,
            privateKey: const HexEncoder().convert(walletKeysAndAddress.privateKey.toBytes()),
            publicKey: const HexEncoder().convert(walletKeysAndAddress.publicKey.toBytes()),
            address: walletKeysAndAddress.address,
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

  Future<dynamic> sendXCH(
      {required String privateKey,
      required String address,
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
      final responseData = await http.post(Uri.parse('$baseURL/v2/records'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'address': address,
          }));
      if (responseData.statusCode == 200) {
        RecordsResponse recordsResponse =
            RecordsResponse.fromJson(jsonDecode(responseData.body));
        var records = recordsResponse.records;
        records.sort((a, b) => b.coin.amount - a.coin.amount);
        List<RecordResponse> spendRecords = [];
        var spendAmount = 0;
        calculator:
        while (records.isNotEmpty && spendAmount < totalAmount) {
          for (var i = 0; i < records.length; i++) {
            if (spendAmount + records[i].coin.amount <= totalAmount) {
              var record = records.removeAt(i--);
              spendRecords.add(record);
              spendAmount += record.coin.amount;
              continue calculator;
            }
          }
          var record = records.removeAt(0);
          spendRecords.add(record);
          spendAmount += record.coin.amount;
        }
        if (spendAmount < totalAmount) {
          return 'Insufficient funds.';
        }
        List<JacobianPoint> signatures = [];
        List<Map<String, dynamic>> spends = [];
        var target = true;
        var destinationHash = segwit.decode(address).program;
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
          var coinId = Program.list([
            Program.int(11),
            Program.cons(Program.int(1),
                Program.hex(record.coin.parentCoinInfo.substring(2))),
            Program.cons(Program.int(1),
                Program.hex(record.coin.puzzleHash.substring(2))),
            Program.cons(Program.int(1), Program.int(record.coin.amount))
          ]).run(Program.nil()).program.atom;
          signatures.add(AugSchemeMPL.sign(
              privateKeyObject,
              Uint8List.fromList(conditions.hash() +
                  coinId +
                  const HexDecoder().convert(
                      'ccd5bb71183532bff220ba46c268991a3ff07eb358e8255a65c30a2dce0e5fbb'))));
          spends.add({
            'coin': record.coin.toJson(),
            'puzzle_reveal': const HexEncoder().convert(wallet.serialize()),
            'solution': const HexEncoder().convert(solution.serialize())
          });
        }
        var aggregate = AugSchemeMPL.aggregate(signatures);
        try {
          final responseData =
              await http.post(Uri.parse('$baseURL/v2/transaction'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'spend_bundle': {
                      'coin_spends': spends,
                      'aggregated_signature':
                          const HexEncoder().convert(aggregate.toBytes())
                    },
                    'blockchain': 'xch'
                  }));
          if (responseData.statusCode == 200) {
            return 'success';
          } else {
            return responseData.body;
          }
        } on Exception catch (e) {
          return e.toString();
        }
      } else {
        return responseData.body;
      }
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
