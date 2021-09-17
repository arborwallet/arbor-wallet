import 'dart:convert';

import 'package:arbor/constants.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:arbor/screens/info_screen.dart';
import 'package:arbor/views/screens/no_encryption_available_sccreen.dart';
import 'package:arbor/core/providers/send_crypto_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/hive_constants.dart';
import 'core/providers/create_wallet_provider.dart';
import 'models/fork.dart';
import 'models/transaction.dart';
import 'models/transactions.dart';
import 'models/wallet.dart';
import 'themes/arbor_theme_data.dart';
import 'views/screens/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  try {
    final String hiveEncryptionKeyKey = 'arbor_hive_key';
    final String hiveEncryptionSchemaKey = 'arbor_hive_version_key';

    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var containsEncryptionKey =
        await secureStorage.containsKey(key: hiveEncryptionKeyKey);
    if (!containsEncryptionKey) {
      var newEncryptionKey = Hive.generateSecureKey();
      await secureStorage.write(
          key: hiveEncryptionKeyKey, value: base64UrlEncode(newEncryptionKey));
      await secureStorage.write(key: hiveEncryptionSchemaKey, value: "1");
    }
    await secureStorage.readAll();

    String? keyFromSecureStorage =
        await secureStorage.read(key: hiveEncryptionKeyKey);
    if (keyFromSecureStorage != null && keyFromSecureStorage != '') {
      var encryptionKey = base64Url.decode(keyFromSecureStorage);

      _hiveAdaptersRegistration();
      // Opening the box
      try {
        await Hive.openBox(HiveConstants.walletBox,
            encryptionCipher: HiveAesCipher(encryptionKey));
        await Hive.openBox(HiveConstants.transactionsBox,
            encryptionCipher: HiveAesCipher(encryptionKey));
      } on Exception catch (e) {
        print("Error: ${e.toString()}");
      }

      runApp(MyApp());
    } else {
      // _showEncryptionErrorView();
      return runApp(NoEncryptionAvailableScreen(
          message:
              'We were unable to retrieve the encrypted keys to open your wallets. Please contact us.'));
    }
  } catch (error) {
    return runApp(NoEncryptionAvailableScreen(
        message:
            'We were unable to use the encrypted storage for your wallets. Please contact us. Error: $error'));
  }
}

void _hiveAdaptersRegistration() {
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(ForkAdapter());
  Hive.registerAdapter(TransactionsAdapter());
  Hive.registerAdapter(TransactionAdapter());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> _isFirstTimeUser() async {
    bool _isFirstTime;
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime =
        (prefs.getBool(ArborConstants.IS_FIRST_TIME_USER_KEY) ?? true);
    return Future<bool>.value(_isFirstTime);
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreateWalletProvider()),
        ChangeNotifierProvider(create: (_) => RestoreWalletProvider()),
        ChangeNotifierProvider(create: (_) => SendCryptoProvider()),
      ],
      child: ScreenUtilInit(
        builder:()=> MaterialApp(
            title: 'Arbor',
            theme: ArborThemeData.lightTheme,
            debugShowCheckedModeBanner: false,
            home: FutureBuilder<bool>(
                future: _isFirstTimeUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bool _isFirstTime = snapshot.data as bool;
                    if (_isFirstTime) {
                      return SplashScreen();
                    } else {
                      return InfoScreen();
                    }
                  } else {
                    return Container(
                      color: ArborColors.green,
                    );
                  }
                })),
      ),
    );
  }
}
