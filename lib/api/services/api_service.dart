import 'package:flutter/foundation.dart';

abstract class ApiService {
  //abstract String baseURL;
  static const String baseURL = kDebugMode?'https://dev.arborwallet.com/api' : 'https://arborwallet.com/api';
}