import 'package:arbor/bls/ec.dart';
import 'package:arbor/bls/private_key.dart';
import 'package:arbor/clvm/program.dart';
import 'package:arbor/core/utils/puzzles.dart';
import 'package:bech32m/bech32m.dart';
import 'package:bip39/bip39.dart';

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
}

class WalletKeysAndAddress {
  final String address;
  final PrivateKey privateKey;
  final JacobianPoint publicKey;

  WalletKeysAndAddress(this.address, this.privateKey, this.publicKey);
}
