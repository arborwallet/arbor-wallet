import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/info_screen.dart';
import 'package:arbor/hive_constants.dart';
import 'package:arbor/models/models.dart';


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
    return MaterialApp(
      title: 'Arbor',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: InfoScreen(),
    );
  }
}
