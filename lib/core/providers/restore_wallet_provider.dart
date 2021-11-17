import 'package:arbor/api/services.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:arbor/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../constants/hive_constants.dart';

class RestoreWalletProvider extends ChangeNotifier {
  Box box = Hive.box(HiveConstants.walletBox);
  CrossFadeState currentState = CrossFadeState.showFirst;
  Status recoverWalletStatus = Status.SUCCESS;
  QRViewController? controller;
  final walletService = WalletService();
  String bip39words = '';
  List<String> bipList = [];

  bool get firstBatchButtonIsDisabled =>
      _password1IsCorrect &&
      _password2IsCorrect &&
      _password3IsCorrect &&
      _password4IsCorrect;

  bool get secondBatchButtonIsDisabled =>
      _password5IsCorrect &&
      _password6IsCorrect &&
      _password7IsCorrect &&
      _password8IsCorrect;

  bool get lastBatchButtonIsDisabled =>
      _password9IsCorrect &&
      _password10IsCorrect &&
      _password11IsCorrect &&
      _password12IsCorrect;
  resetLastButton() {
    _password9IsCorrect = false;
    _password10IsCorrect = false;
    _password11IsCorrect = false;
    _password12IsCorrect = false;
  }

  RegExp passwordRegex = new RegExp(
    r"(?<![\w\d])abc(?![\w\d])",
    caseSensitive: false,
    multiLine: false,
  );

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

  bool _password1IsCorrect = false,
      _password2IsCorrect = false,
      _password3IsCorrect = false,
      _password4IsCorrect = false,
      _password5IsCorrect = false,
      _password6IsCorrect = false,
      _password7IsCorrect = false,
      _password8IsCorrect = false,
      _password9IsCorrect = false,
      _password10IsCorrect = false,
      _password11IsCorrect = false,
      _password12IsCorrect = false;

  String _errorMessage = 'Invalid phrase';

  Wallet? recoveredWallet;
  String allPassword = '';

  bool validatePassword(String word) {

    try {
      if (word.length >= 3 &&
          (word.trim() ==
              bipList.firstWhere((e) => e == word.trim(), orElse: () => ''))) {
        return true;
      } else if (word.trim().length < 3) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      debugPrint('ERROR: ${e.toString()}');
      return false;
    }
  }

  setFirstPassword(String password) {
    firstPassword = password;
    if (validatePassword(password)) {
      errorMessage1 = '';
      if (password.length < 3) {
        _password1IsCorrect = false;
      } else {
        _password1IsCorrect = true;
      }
    } else {
      _password1IsCorrect = false;
      errorMessage1 = _errorMessage;
    }
    notifyListeners();
  }

  setSecondPassword(String password) {
    secondPassword = password;
    if (validatePassword(password)) {
      errorMessage2 = '';
      if (password.length < 3) {
        _password2IsCorrect = false;
      } else {
        _password2IsCorrect = true;
      }
    } else {
      _password2IsCorrect = false;
      errorMessage2 = _errorMessage;
    }
    notifyListeners();
  }

  setThirdPassword(String password) {
    thirdPassword = password;
    if (validatePassword(password)) {
      errorMessage3 = '';
      if (password.length < 3) {
        _password3IsCorrect = false;
      } else {
        _password3IsCorrect = true;
      }
    } else {
      _password3IsCorrect = false;
      errorMessage3 = _errorMessage;
    }
    notifyListeners();
  }

  setFourthPassword(String password) {
    fourthPassword = password;
    if (validatePassword(password)) {
      errorMessage4 = '';
      if (password.length < 3) {
        _password4IsCorrect = false;
      } else {
        _password4IsCorrect = true;
      }
    } else {
      _password4IsCorrect = false;
      errorMessage4 = _errorMessage;
    }
    notifyListeners();
  }

  setFifthPassword(String password) {
    fifthPassword = password;
    if (validatePassword(password)) {
      errorMessage5 = '';
      if (password.length < 3) {
        _password5IsCorrect = false;
      } else {
        _password5IsCorrect = true;
      }
    } else {
      _password5IsCorrect = false;
      errorMessage5 = _errorMessage;
    }
    notifyListeners();
  }

  setSixthPassword(String password) {
    sixthPassword = password;
    if (validatePassword(password)) {
      errorMessage6 = '';
      if (password.length < 3) {
        _password6IsCorrect = false;
      } else {
        _password6IsCorrect = true;
      }
    } else {
      _password6IsCorrect = false;
      errorMessage6 = _errorMessage;
    }
    notifyListeners();
  }

  setSeventhPassword(String password) {
    seventhPassword = password;
    if (validatePassword(password)) {
      errorMessage7 = '';
      if (password.length < 3) {
        _password7IsCorrect = false;
      } else {
        _password7IsCorrect = true;
      }
    } else {
      _password7IsCorrect = false;
      errorMessage7 = _errorMessage;
    }
    notifyListeners();
  }

  setEighthPassword(String password) {
    eighthPassword = password;
    if (validatePassword(password)) {
      errorMessage8 = '';
      if (password.length < 3) {
        _password8IsCorrect = false;
      } else {
        _password8IsCorrect = true;
      }
    } else {
      _password8IsCorrect = false;
      errorMessage8 = _errorMessage;
    }
    notifyListeners();
  }

  setNinthPassword(String password) {
    ninthPassword = password;
    if (validatePassword(password)) {
      errorMessage9 = '';
      if (password.length < 3) {
        _password9IsCorrect = false;
      } else {
        _password9IsCorrect = true;
      }
    } else {
      _password9IsCorrect = false;
      errorMessage9 = _errorMessage;
    }
    notifyListeners();
  }

  setTenthPassword(String password) {
    tenthPassword = password;
    if (validatePassword(password)) {
      errorMessage10 = '';
      if (password.length < 3) {
        _password10IsCorrect = false;
      } else {
        _password10IsCorrect = true;
      }
    } else {
      _password10IsCorrect = false;
      errorMessage10 = _errorMessage;
    }
    notifyListeners();
  }

  setEleventhPassword(String password) {
    eleventhPassword = password;
    if (validatePassword(password)) {
      errorMessage11 = '';
      if (password.length < 3) {
        _password11IsCorrect = false;
      } else {
        _password11IsCorrect = true;
      }
    } else {
      _password11IsCorrect = false;
      errorMessage11 = _errorMessage;
    }
    notifyListeners();
  }

  setTwelfthPassword(String password) {
    twelfthPassword = password;
    if (validatePassword(password)) {
      errorMessage12 = '';
      if (password.length < 3) {
        _password12IsCorrect = false;
      } else {
        _password12IsCorrect = true;
      }
    } else {
      _password12IsCorrect = false;
      errorMessage12 = _errorMessage;
    }
    notifyListeners();
  }

  concatenatePasswords() {
    allPassword =
        '${firstPassword!.trim()} ${secondPassword!.trim()} ${thirdPassword!.trim()} ${fourthPassword!.trim()} '
        '${fifthPassword!.trim()} ${sixthPassword!.trim()} ${seventhPassword!.trim()} ${eighthPassword!.trim()} '
        '${ninthPassword!.trim()} ${tenthPassword!.trim()} ${eleventhPassword!.trim()} ${twelfthPassword!.trim()}';
  }

  bool validateFirstBatch() {
    if (_password1IsCorrect == false ||
        _password2IsCorrect == false ||
        _password3IsCorrect == false ||
        _password4IsCorrect == false) {
      if (_password1IsCorrect == false) {
        errorMessage1 = _errorMessage;
      }

      if (_password2IsCorrect == false) {
        errorMessage2 = _errorMessage;
      }

      if (_password3IsCorrect == false) {
        errorMessage3 = _errorMessage;
      }

      if (_password4IsCorrect == false) {
        errorMessage4 = _errorMessage;
      }
      notifyListeners();
      return false;
    } else {
      return true;
    }
  }

  bool validateSecondBatch() {
    if (_password5IsCorrect == false ||
        _password6IsCorrect == false ||
        _password7IsCorrect == false ||
        _password8IsCorrect == false) {
      if (_password5IsCorrect == false) {
        errorMessage5 = _errorMessage;
      }

      if (_password6IsCorrect == false) {
        errorMessage6 = _errorMessage;
      }

      if (_password7IsCorrect == false) {
        errorMessage7 = _errorMessage;
      }

      if (_password8IsCorrect == false) {
        errorMessage8 = _errorMessage;
      }
      notifyListeners();
      return false;
    } else {
      return true;
    }
  }

  bool validateLastBatch() {
    if (_password9IsCorrect == false ||
        _password10IsCorrect == false ||
        _password11IsCorrect == false ||
        _password12IsCorrect == false) {
      if (_password9IsCorrect == false) {
        errorMessage9 = _errorMessage;
      }

      if (_password10IsCorrect == false) {
        errorMessage10 = _errorMessage;
      }

      if (_password11IsCorrect == false) {
        errorMessage11 = _errorMessage;
      }

      if (_password12IsCorrect == false) {
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
        '${allPassword.toLowerCase()}',
      );
      print('${recoveredWallet.toString()}');
      box.add(recoveredWallet);
    } on Exception catch (e) {
      print('Recover Wallet Error: ${e.toString()}');
      recoverWalletStatus = Status.ERROR;
      notifyListeners();
      return;
    }
    recoverWalletStatus = Status.SUCCESS;
    notifyListeners();
  }

  clearStatus() {
    currentState = CrossFadeState.showFirst;

    _password1IsCorrect = false;
    _password2IsCorrect = false;
    _password3IsCorrect = false;
    _password4IsCorrect = false;
    _password5IsCorrect = false;
    _password6IsCorrect = false;
    _password7IsCorrect = false;
    _password8IsCorrect = false;
    _password9IsCorrect = false;
    _password10IsCorrect = false;
    _password11IsCorrect = false;
    _password12IsCorrect = false;

    allPassword = '';
    firstPassword = '';
    secondPassword = '';
    thirdPassword = '';
    fourthPassword = '';
    fifthPassword = '';
    sixthPassword = '';
    seventhPassword = '';
    eighthPassword = '';
    ninthPassword = '';
    tenthPassword = '';
    eleventhPassword = '';
    twelfthPassword = '';
    recoverWalletStatus = Status.IDLE;
  }

  setBip39Words() async {
    try {
      bip39words = await loadAsset();
      bipList = bip39words.trim().split('\n').map((e) => e).toList();
      recoverWalletStatus = Status.IDLE;
      notifyListeners();
    } on Exception catch (e) {
      debugPrint('ERROR: ${e.toString()}');
    }
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString(AssetPaths.bip39);
  }
}
