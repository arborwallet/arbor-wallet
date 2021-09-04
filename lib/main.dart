import 'package:flutter/material.dart';
import 'package:gallery/themes/arbor_theme_data.dart';
import 'package:gallery/views/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'hive_constants.dart';
import 'models/models.dart';


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
      /*theme: ThemeData(
        primarySwatch: Colors.green,
      ),*/
      theme:ArborThemeData.lightTheme,

      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
