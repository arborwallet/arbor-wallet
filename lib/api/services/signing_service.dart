import 'dart:typed_data';

import 'package:arbor/core/utils/wallet_utils.dart';
import 'package:bech32m/bech32m.dart';
import 'package:bip39/bip39.dart';
import 'package:chia_utils/bls.dart';
import 'package:chia_utils/clvm.dart';
import 'package:hex/hex.dart';

class SigningService {
  static String _blockchain = "xch";

  static String generateWalletMnemonic() {
    String mnemonic = generateMnemonic();
    return mnemonic;
  }

  static WalletKeysAndAddress convertMnemonicToKeysAndAddress(String mnemonic) {
    var seed = mnemonicToSeed(mnemonic);
    var privateKey = PrivateKey.fromSeed(seed);
    var publicKey = privateKey.getG1();
    var puzzle = walletPuzzle.curry([Program.fromBytes(publicKey.toBytes())]);
    var puzzleHash = puzzle.hash();
    var address = segwit.encode(Segwit(_blockchain, puzzleHash));

    return WalletKeysAndAddress(address, privateKey, publicKey);
  }

  static SignedTransactionResponse usePrivateKeyToGenerateHash(
      String privateKey) {
    var privateKeyObject = PrivateKey.fromBytes(
        Uint8List.fromList(const HexDecoder().convert(privateKey)));
    var publicKeyObject = privateKeyObject.getG1();
    var wallet =
        walletPuzzle.curry([Program.fromBytes(publicKeyObject.toBytes())]);
    var puzzleHash = wallet.hash();
    var address = segwit.encode(Segwit(_blockchain, puzzleHash));

    return SignedTransactionResponse(
        wallet, privateKeyObject, puzzleHash, address);
  }
}

class WalletKeysAndAddress {
  final String address;
  final PrivateKey privateKey;
  final JacobianPoint publicKey;

  WalletKeysAndAddress(this.address, this.privateKey, this.publicKey);
}

class SignedTransactionResponse {
  Program wallet;
  PrivateKey privateKeyObject;
  Uint8List puzzleHash;
  String address;

  SignedTransactionResponse(
      this.wallet, this.privateKeyObject, this.puzzleHash, this.address);
}
