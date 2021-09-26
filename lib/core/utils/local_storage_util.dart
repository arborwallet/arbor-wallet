import 'package:arbor/core/constants/arbor_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomSharedPreference {
  static SharedPreferences? _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  bool get pinIsSet => _sharedPrefs!.getBool(ArborConstants.IS_PIN_ENABLED_KEY) ??false;
  bool get biometricsIsSet => _sharedPrefs!.getBool(ArborConstants.IS_BIOMETRICS_ENABLED_KEY) ??false;

  String get pin => _sharedPrefs!.getString(ArborConstants.PIN_KEY) ??"";

  setPin(String pin){
    _sharedPrefs!.setString(ArborConstants.PIN_KEY, pin);
  }

  setUsePin(bool value) {
    _sharedPrefs!.setBool(ArborConstants.IS_PIN_ENABLED_KEY, value);
  }

  setUseBiometrics(bool value) {
    _sharedPrefs!.setBool(ArborConstants.IS_BIOMETRICS_ENABLED_KEY, value);
  }
}

final customSharedPreference = CustomSharedPreference();



