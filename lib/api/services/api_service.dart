import 'package:flutter/foundation.dart';

abstract class ApiService {
  static const String baseURL = kDebugMode
      ? 'https://dev.arborwallet.com/api'
      : 'https://arborwallet.com/api';
}
