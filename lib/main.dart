import 'package:arbor/core/providers/restore_wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'hive_constants.dart';
import 'models/fork.dart';
import 'models/transaction.dart';
import 'models/transactions.dart';
import 'models/wallet.dart';
import 'themes/arbor_theme_data.dart';
import 'views/screens/splash_screen.dart';


main() async {
  // Initialize hive
  await Hive.initFlutter();
  // Registering the adapter
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(ForkAdapter());
  Hive.registerAdapter(TransactionsAdapter());
  Hive.registerAdapter(TransactionAdapter());
  // Opening the box
  await Hive.openBox(HiveConstants.walletBox);
  await Hive.openBox(HiveConstants.transactionsBox);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        ChangeNotifierProvider(create: (_) => RestoreWalletProvider()),
      ],
      child: MaterialApp(
        title: 'Arbor',
        theme:ArborThemeData.lightTheme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        /*routes: {
          "/":(context) => ChangeNotifierProvider<LoginViewModel>(
              create: (_) => LoginViewModel(), child: LoginEmailScreen()),
        },*/
      ),
    );
  }
}
