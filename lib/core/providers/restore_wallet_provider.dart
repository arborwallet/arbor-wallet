import 'package:arbor/api/services.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:arbor/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../hive_constants.dart';

class RestoreWalletProvider extends ChangeNotifier {
  Box box = Hive.box(HiveConstants.walletBox);
  CrossFadeState currentState = CrossFadeState.showFirst;
  Status recoverWalletStatus = Status.IDLE;
  QRViewController? controller;
  final walletService = WalletService();

  String? firstPassword = '',
      secondPassword = '',
      thirdPassword = '',
      fourthPassword = '',
      fifthPassword = '',
      sixthPassword = '';
  String? seventhPassword = '',
      eighthPassword = '',
      ninthPassword = '',
      tenthPassword = '',
      eleventhPassword = '',
      twelfthPassword = '';

  String errorMessage1 = '',
      errorMessage2 = '',
      errorMessage3 = '',
      errorMessage4 = '',
      errorMessage5 = '',
      errorMessage6 = '',
      errorMessage7 = '',
      errorMessage8 = '',
      errorMessage9 = '',
      errorMessage10 = '',
      errorMessage11 = '',
      errorMessage12 = '';

  String _errorMessage = 'Password field cannot be empty';

  Wallet? recoveredWallet;
  String allPassword = '';

  setFirstPassword(String password) {
    firstPassword = password;
    errorMessage1 = '';
    notifyListeners();
  }

  setSecondPassword(String password) {
    secondPassword = password;
    errorMessage2 = '';
    notifyListeners();
  }

  setThirdPassword(String password) {
    thirdPassword = password;
    errorMessage3 = '';
    notifyListeners();
  }

  setFourthPassword(String password) {
    fourthPassword = password;
    errorMessage4 = '';
    notifyListeners();
  }

  setFifthPassword(String password) {
    fifthPassword = password;
    errorMessage5 = '';
    notifyListeners();
  }

  setSixthPassword(String password) {
    sixthPassword = password;
    errorMessage6 = '';
    notifyListeners();
  }

  setSeventhPassword(String password) {
    seventhPassword = password;
    errorMessage7 = '';
    notifyListeners();
  }

  setEighthPassword(String password) {
    eighthPassword = password;
    errorMessage8 = '';
    notifyListeners();
  }

  setNinthPassword(String password) {
    ninthPassword = password;
    errorMessage9 = '';
    notifyListeners();
  }

  setTenthPassword(String password) {
    tenthPassword = password;
    errorMessage10 = '';
    notifyListeners();
  }

  setEleventhPassword(String password) {
    eleventhPassword = password;
    errorMessage11 = '';
    notifyListeners();
  }

  setTwelfthPassword(String password) {
    twelfthPassword = password;
    errorMessage12 = '';
    notifyListeners();
  }

  concatenatePasswords() {
    allPassword =
        '${firstPassword!.trim()} ${secondPassword!.trim()} ${thirdPassword!.trim()} ${fourthPassword!.trim()} '
        '${fifthPassword!.trim()} ${sixthPassword!.trim()} ${seventhPassword!.trim()} ${eighthPassword!.trim()} '
        '${ninthPassword!.trim()} ${tenthPassword!.trim()} ${eleventhPassword!.trim()} ${twelfthPassword!.trim()}';
  }

  bool validateFirstBatch() {
    if (firstPassword!.trim() == '' ||
        secondPassword!.trim() == '' ||
        thirdPassword!.trim() == '' ||
        fourthPassword!.trim() == '') {
      if (firstPassword!.trim() == '') {
        errorMessage1 = _errorMessage;
      }

      if (secondPassword!.trim() == '') {
        errorMessage2 = _errorMessage;
      }

      if (thirdPassword!.trim() == '') {
        errorMessage3 = _errorMessage;
      }

      if (fourthPassword!.trim() == '') {
        errorMessage4 = _errorMessage;
      }
      notifyListeners();

      return false;
    } else {
      return true;
    }
  }

  bool validateSecondBatch() {
    if (fifthPassword!.trim() == '' ||
        sixthPassword!.trim() == '' ||
        seventhPassword!.trim() == '' ||
        eighthPassword!.trim() == '') {
      if (fifthPassword!.trim() == '') {
        errorMessage5 = _errorMessage;
      }

      if (sixthPassword!.trim() == '') {
        errorMessage6 = _errorMessage;
      }

      if (seventhPassword!.trim() == '') {
        errorMessage7 = _errorMessage;
      }

      if (eighthPassword!.trim() == '') {
        errorMessage8 = _errorMessage;
      }
      notifyListeners();

      return false;
    } else {
      return true;
    }
  }

  bool validateLastBatch() {
    if (ninthPassword!.trim() == '' ||
        tenthPassword!.trim() == '' ||
        eleventhPassword!.trim() == '' ||
        twelfthPassword!.trim() == '') {
      if (ninthPassword!.trim() == '') {
        errorMessage9 = _errorMessage;
      }

      if (tenthPassword!.trim() == '') {
        errorMessage10 = _errorMessage;
      }

      if (eleventhPassword!.trim() == '') {
        errorMessage11 = _errorMessage;
      }

      if (twelfthPassword!.trim() == '') {
        errorMessage12 = _errorMessage;
      }
      notifyListeners();

      return false;
    } else {
      return true;
    }
  }

  clearErrorMessages() {
    errorMessage1 = '';
    errorMessage2 = '';
    errorMessage3 = '';
    errorMessage4 = '';
    errorMessage5 = '';
    errorMessage6 = '';
    errorMessage7 = '';
    errorMessage8 = '';
    errorMessage9 = '';
    errorMessage10 = '';
    errorMessage11 = '';
    errorMessage12 = '';
  }

  void nextScreen() {
    if (currentState == CrossFadeState.showFirst) {
      currentState = CrossFadeState.showSecond;
      notifyListeners();
    } else {}
  }

  back() {
    currentState = CrossFadeState.showFirst;
    notifyListeners();
  }

  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      allPassword = scanData.code;
      recoverWallet();
    });
  }

  recoverWallet() async {
    recoverWalletStatus = Status.LOADING;
    notifyListeners();
    try {
      recoveredWallet = await walletService.recoverWallet(
        '$allPassword',
      );
      print('${recoveredWallet.toString()}');

      box.add(recoveredWallet);
    } on Exception catch (e) {
      print('Error');
      recoverWalletStatus = Status.ERROR;
      notifyListeners();
      throw Exception('${e.toString()}');
    }
    recoverWalletStatus = Status.SUCCESS;
    notifyListeners();
  }

  clearStatus() {
    recoverWalletStatus = Status.IDLE;
  }
}
