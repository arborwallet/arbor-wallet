import 'package:flutter/material.dart';
import 'package:arbor/models/wallet.dart';
import 'package:arbor/models/fork.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/info_screen.dart';
import 'package:arbor/hive_constants.dart';

main() async {
  // Initialize hive
  await Hive.initFlutter();
  // Registering the adapter
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(ForkAdapter());
  // Opening the box
  await Hive.openBox(HiveConstants.walletBox);

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
