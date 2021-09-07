import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RestoreWalletProvider extends ChangeNotifier{

  CrossFadeState currentState = CrossFadeState.showFirst;

  String? firstPassword,secondPassword,thirdPassword,fourthPassword,fifthPassword,sixthPassword;
  String? seventhPassword,eighthPassword,ninthPassword,tenthPassword,eleventhPassword,twelfthPassword;

  setFirstPassword(String password){
    firstPassword=password;
    notifyListeners();
  }

  setSecondPassword(String password){
    secondPassword=password;
    notifyListeners();
  }

  setThirdPassword(String password){
    thirdPassword=password;
    notifyListeners();
  }

  setFourthPassword(String password){
    fourthPassword=password;
    notifyListeners();
  }

  setFifthPassword(String password){
    fifthPassword=password;
    notifyListeners();
  }

  setSixthPassword(String password){
    sixthPassword=password;
    notifyListeners();
  }

  setSeventhPassword(String password){
    seventhPassword=password;
    notifyListeners();
  }

  setEighthPassword(String password){
    eighthPassword=password;
    notifyListeners();
  }

  setNinthPassword(String password){
    ninthPassword=password;
    notifyListeners();
  }

  setTenthPassword(String password){
    tenthPassword=password;
    notifyListeners();
  }

  setEleventhPassword(String password){
    eleventhPassword=password;
    notifyListeners();
  }

  setTwelfthPassword(String password){
    twelfthPassword=password;
    notifyListeners();
  }

  void nextScreen() {
    if (currentState == CrossFadeState.showFirst) {
      currentState=CrossFadeState.showSecond;
      notifyListeners();
    } else {}
  }

  back(){
    currentState=CrossFadeState.showFirst;
    notifyListeners();
  }



}