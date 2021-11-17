import 'dart:typed_data';

import 'package:arbor/bls/ec.dart';
import 'package:arbor/bls/private_key.dart';
import 'package:arbor/clvm/program.dart';
import 'package:arbor/core/utils/wallet_utils.dart';
import 'package:bech32m/bech32m.dart';
import 'package:bip39/bip39.dart';
import 'package:hex/hex.dart';

class LocalSigner {
  static String generateWalletMnemonic() {
    String mnemonic = generateMnemonic();
    return mnemonic;
  }

  static WalletKeysAndAddress convertMnemonicToKeysAndAddress(String mnemonic) {
    var seed = mnemonicToSeed(mnemonic);
    var privateKey = PrivateKey.fromSeed(seed);
    var publicKey = privateKey.getG1();
    var puzzle = walletPuzzle.curry([Program.atom(publicKey.toBytes())]);
    var puzzleHash = puzzle.hash();
    var address = segwit.encode(Segwit('xch', puzzleHash));

    return WalletKeysAndAddress(address, privateKey, publicKey);
  }
  
  static SignedTransactionResponse usePrivateKeyToGenerateHash(String privateKey){
    var privateKeyObject = PrivateKey.fromBytes(
        Uint8List.fromList(const HexDecoder().convert(privateKey)));
    var publicKeyObject = privateKeyObject.getG1();
    var wallet = walletPuzzle.curry([Program.atom(publicKeyObject.toBytes())]);
    var puzzleHash = wallet.hash();
    var address = segwit.encode(Segwit('xch', puzzleHash));

    return SignedTransactionResponse(wallet, privateKeyObject, puzzleHash,address);
  }

  // static dynamic generateSpendsAndSignature(SignedTransactionResponse signedTransactionResponse,var amount,var change,String receiversAddress){
  //   List<JacobianPoint> signatures = [];
  //   List<Map<String, dynamic>> spends = [];
  //   var target = true;
  //   var destinationHash = segwit.decode(receiversAddress).program;
  //
  //   for (var record in spendRecords) {
  //     var conditions = Program.list(target
  //     ? [
  //     Program.list([
  //       Program.int(51),
  //       Program.atom(Uint8List.fromList(destinationHash)),
  //       Program.int(amount)
  //     ])
  //     ] +
  //         (change > 0
  //         ? [
  //         Program.list([
  //           Program.int(51),
  //           Program.atom(signedTransactionResponse.puzzleHash),
  //           Program.int(change)
  //         ])
  //         ]
  //                 : [])
  //             : []);
  //     var solution = Program.list([conditions]);
  //     target = false;
  //     var coinId = Program.list([
  //       Program.int(11),
  //       Program.cons(Program.int(1),
  //           Program.hex(record.coin.parentCoinInfo.substring(2))),
  //       Program.cons(Program.int(1),
  //           Program.hex(record.coin.puzzleHash.substring(2))),
  //       Program.cons(Program.int(1), Program.int(record.coin.amount))
  //     ]).run(Program.nil()).program.atom;
  //     signatures.add(AugSchemeMPL.sign(
  //         signedTransactionResponse.privateKeyObject,
  //         Uint8List.fromList(conditions.hash() +
  //             coinId +
  //             const HexDecoder().convert(
  //                 'ccd5bb71183532bff220ba46c268991a3ff07eb358e8255a65c30a2dce0e5fbb'))));
  //     spends.add({
  //       'coin': record.coin.toJson(),
  //       'puzzle_reveal': const HexEncoder().convert(signedTransactionResponse.wallet.serialize()),
  //       'solution': const HexEncoder().convert(solution.serialize())
  //     });
  //   }
  //
  //   return [spends,signatures];
  // }
}

class WalletKeysAndAddress {
  final String address;
  final PrivateKey privateKey;
  final JacobianPoint publicKey;

  WalletKeysAndAddress(this.address, this.privateKey, this.publicKey);
}

class SignedTransactionResponse{
  Program wallet;
  PrivateKey privateKeyObject;
  Uint8List puzzleHash;
  String address;

  SignedTransactionResponse(this.wallet, this.privateKeyObject, this.puzzleHash,this.address);
}
