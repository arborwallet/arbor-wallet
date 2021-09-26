import 'package:arbor/core/enums/status.dart';
import 'package:arbor/core/utils/local_storage_util.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier{

  String _firstPin = "";
  String _currentPin = "";
  int _currentStep = 1;
  bool _invalidPin = false;
  final int _pinLength = 6;

  bool unlock=true;

  Status setPinStatus=Status.IDLE;

  get firstPin => _firstPin;
  get currentPin => _currentPin;
  get currentStep => _currentStep;
  get invalidPin => _invalidPin;
  get pinLength => _pinLength;

  void clear() {
    if (_currentPin.length > 0) {
      _currentPin = _currentPin.substring(0, _currentPin.length - 1);
      notifyListeners();
    }
  }

  unlockWithPin(String key){
    if (_currentPin.length <= _pinLength) {
      _currentPin = _currentPin + key;
      notifyListeners();
    }
    Future.delayed(
      const Duration(milliseconds: 200),
          () {
        if (_currentPin.length == _pinLength) {
          unlock=true;
          String _savedPin=customSharedPreference.pin;


            if (_currentPin != _savedPin) {
              _invalidPin = true;
              notifyListeners();
              resetInvalidPin();
            } else {
              _currentPin = "";
              setPinStatus=Status.SUCCESS;
              notifyListeners();
            }
        }
      },
    );
  }

  disablePin(String key){
    if (_currentPin.length <= _pinLength) {
      _currentPin = _currentPin + key;
      notifyListeners();
    }
    Future.delayed(
      const Duration(milliseconds: 200),
          () {
        if (_currentPin.length == _pinLength) {
          unlock=false;
          String _savedPin=customSharedPreference.pin;


          if (_currentPin != _savedPin) {
            _invalidPin = true;
            notifyListeners();
            resetInvalidPin();
          } else {
            customSharedPreference.setUsePin(false);
            debugPrint("Unlock with pin: ${customSharedPreference.pinIsSet}");
            _currentPin = "";
            setPinStatus=Status.SUCCESS;
            notifyListeners();
          }
        }
      },
    );
  }

  void handleKeyPressed(String key) {
    if (_currentPin.length <= _pinLength) {
      _currentPin = _currentPin + key;
      notifyListeners();
    }
    Future.delayed(
      const Duration(milliseconds: 200),
          () {
        if (_currentPin.length == _pinLength) {
          if (_currentStep == 1) {
            _firstPin = currentPin;
            _currentStep = 2;
            _currentPin = "";
            notifyListeners();
            return;
          }

          if (_currentStep == 2) {
            if (_firstPin != _currentPin) {
              _invalidPin = true;
              notifyListeners();
              resetInvalidPin();
            } else {
              customSharedPreference.setPin(_currentPin);
              customSharedPreference.setUsePin(true);
              debugPrint("Unlock with pin: ${customSharedPreference.pinIsSet}");
              _currentPin = "";
              setPinStatus=Status.SUCCESS;
              notifyListeners();
            }
          }
        }
      },
    );
  }


  void goBack() async {
    _currentStep = 1;
    _currentPin = "";
    notifyListeners();
  }

  void resetInvalidPin() {
    Future.delayed(
      const Duration(milliseconds: 200),
          () {
        _invalidPin = false;
        _currentPin = "";
        notifyListeners();
      },
    );
  }

  clearStatus(){
    setPinStatus=Status.IDLE;
  }



}