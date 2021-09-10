import 'package:arbor/api/responses.dart';
import 'package:arbor/api/services/wallet_service.dart';
import 'package:arbor/core/constants/ui_constants.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:flutter/foundation.dart';

class SendCryptoProvider extends ChangeNotifier {
  Status sendCryptoStatus = Status.IDLE;

  Status _walletBalanceStatus = Status.IDLE;
  Status get walletBalanceStatus => _walletBalanceStatus;

  final walletService = WalletService();

  String _appBarTitle = '';
  String get appBarTitle => _appBarTitle;

  String _receiverAddress = '';
  String get receiverAddress => _receiverAddress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _addressErrorMessage = '';
  String get addressErrorMessage => _addressErrorMessage;

  String privateKey = '';
  String currentUserAddress = '';
  var transactionResponse;

  int _walletBalance = 0;
  int get walletBalance => _walletBalance;

  String _transactionValue = '0';
  String get transactionValue => _transactionValue;

  bool get enableButton => _validAddress && double.parse(_transactionValue) > 0;

  double get convertedBalance => _walletBalance / chiaPrecision;
  String get readableBalance=>convertedBalance.toStringAsFixed(8);

  double _amount = 0;
  double get amount => _amount;

  bool _validAddress = false;

  RegExp amountRegex = new RegExp(
    r"(^[+-]?\d*\.\d{1,8}$)",
  );

  RegExp addressRegex =
      new RegExp("(?:[^qpzry9x8gf2tvdw0s3jn54khce6mua7l]{58})");

  bool validAddress(String address) {
    _validAddress = address.startsWith('xch1');
    notifyListeners();
    return _validAddress;
  }

  setWalletBalance(int v) {
    _walletBalance = v;
    notifyListeners();
  }

  setTransactionValue(v) {
    if (_transactionValue == '0' && v != '.') {
      _transactionValue = v;
      notifyListeners();
      return;
    }

    if (_transactionValue == '0' && v == '.') {
      _transactionValue = '0.';
      notifyListeners();
      return;
    }

    if (_transactionValue.contains('.') && v == '.') {
      return;
    }

    if (_transactionValue.contains('.') &&
        _transactionValue.split('.').last.length == 8) {
      return;
    }

    _transactionValue += v;
    notifyListeners();
  }

  deleteCharacter() {
    if (_transactionValue == '0') {
    } else if (_transactionValue != '0' && _transactionValue.length == 1) {
      _transactionValue = '0';
    } else {
      _transactionValue = removeLastCharacter(_transactionValue);
    }
    notifyListeners();
  }

  useMax(){
    _transactionValue=readableBalance;
    notifyListeners();
  }

  setReceiverAddress(String value) {
    _receiverAddress = value;
    if (value.length >= 62) {
      bool addressIsValid = validAddress(value);
      if (addressIsValid) {
        _addressErrorMessage = '';
      } else {
        _addressErrorMessage = 'Invalid address';
      }
    } else {
      _addressErrorMessage = '';
      _validAddress = false;
    }
    notifyListeners();
  }

  void authoriseTransaction() async {
    sendCryptoStatus = Status.LOADING;
    _appBarTitle = 'Sending';
    notifyListeners();
    await send();
  }

  send() async {
    sendCryptoStatus = Status.LOADING;
    notifyListeners();
    try {
      transactionResponse = await walletService.sendXCH(
        privateKey: privateKey,
        amount: double.parse(_transactionValue) * chiaPrecision,
        address: _receiverAddress,
      );

      if (transactionResponse == 'success') {
        sendCryptoStatus = Status.SUCCESS;
        _walletBalanceStatus = Status.IDLE;
        _transactionValue = '0';
        _receiverAddress = '';
        _appBarTitle = 'All Done';
      } else if (transactionResponse.runtimeType == BaseResponse) {
        _errorMessage = transactionResponse.error;
        sendCryptoStatus = Status.ERROR;
      } else {
        _errorMessage = 'An error occurred';
        sendCryptoStatus = Status.ERROR;
      }
      notifyListeners();
    } on Exception catch (e) {
      _errorMessage = e.toString();
      sendCryptoStatus = Status.ERROR;
      notifyListeners();
    }
  }

  getBalance() async {
    _walletBalanceStatus = Status.LOADING;
    notifyListeners();
    try {
      _walletBalance =
          await walletService.fetchWalletBalance(currentUserAddress);
      _walletBalanceStatus = Status.SUCCESS;
      notifyListeners();
    } on Exception catch (e) {
      _walletBalance = 0;
      _walletBalanceStatus = Status.ERROR;
      notifyListeners();
      throw Exception('${e.toString()}');
    }
  }

  clearStatus() {
    sendCryptoStatus = Status.IDLE;
  }

  close() {
    sendCryptoStatus = Status.CLOSE;
    notifyListeners();
  }

  String removeLastCharacter(String str) {
    if (str.length > 1) {
      str = str.substring(0, str.length - 1);
    } else {
      str = '0';
    }
    return str;
  }
}
