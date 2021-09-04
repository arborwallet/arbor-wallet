// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:gallery/rally/app.dart';
import 'package:gallery/themes/arbor_theme_data.dart';
import 'package:gallery/themes/gallery_theme_data.dart';
import 'package:gallery/views/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/hive_constants.dart';
import 'core/models/fork.dart';
import 'core/models/wallet.dart';

void main()async{
  await Hive.initFlutter();
  // Registering the adapter
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(ForkAdapter());
  // Opening the box
  await Hive.openBox(HiveConstants.walletBox);
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const GalleryApp());
}

class GalleryApp extends StatefulWidget {
  const GalleryApp({
    Key? key,
    this.initialRoute,
    this.isTestMode = false,
  }) : super(key: key);

  final bool isTestMode;
  final String? initialRoute;

  @override
  _GalleryAppState createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {


  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: systemLocaleOption,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTestMode: widget.isTestMode,
      ),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            scrollBehavior:
                const MaterialScrollBehavior().copyWith(scrollbars: false),
            restorationScopeId: 'rootGallery',
            title: 'Flutter Gallery',
            debugShowCheckedModeBanner: false,
            themeMode: GalleryOptions.of(context).themeMode,
            /*theme: GalleryThemeData.lightThemeData.copyWith(
              platform: GalleryOptions.of(context).platform,
            ),*/
            theme: ArborThemeData.lightTheme.copyWith(
              platform: GalleryOptions.of(context).platform,
            ),
            darkTheme: GalleryThemeData.darkThemeData.copyWith(
              platform: GalleryOptions.of(context).platform,
            ),
            localizationsDelegates: const [
              ...GalleryLocalizations.localizationsDelegates,
              LocaleNamesLocalizationsDelegate()
            ],
            routes: {
              '/':(context)=> SplashScreen(),
            },
            initialRoute: '/',
            supportedLocales: GalleryLocalizations.supportedLocales,
            locale: GalleryOptions.of(context).locale,
            localeResolutionCallback: (locale, supportedLocales) {
              deviceLocale = locale;
              return locale;
            },
            //onGenerateRoute: RouteConfiguration.onGenerateRoute,
          );
        },
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({
    Key? key,
  }) ;

  @override
  Widget build(BuildContext context) {
    // return const ApplyTextOptions(
    //   child: SplashPage(
    //     child: Backdrop(),
    //   ),
    // );
    return const RallyApp();
  }
}

