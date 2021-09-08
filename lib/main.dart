import 'dart:ffi';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqlite3/open.dart';

import './db/local_db.dart';
import 'controllers/provider.dart';
import 'screens/home.dart';

//? https://moor.simonbinder.eu/docs/platforms/#desktop
//? https://github.com/simolus3/moor/issues/731

class CColors {
  CColors._();
  static Color mainRed = Colors.red.shade300;
  static Color veryDarkGold = const Color(0xffdbaa08);
  static Color darkGold = const Color(0xffffc200);
  static Color gold = const Color(0xffffd700);
  static Color fancyBlack = const Color(0xff1a1a1a);
  static Color lightBlack = const Color(0xff3b3b3b);
  static Color darkerBlack = const Color(0xff3b3b3b);
}

class Constants {
  Constants._();
  static const logo = 'assets/images/logo.png';
  static const logo2 = 'assets/images/logo_2.png';
}

DynamicLibrary _openOnWindows() {
  final script = Directory.fromUri(Platform.script).parent;
  final libraryNextToScript = join(script.path, 'sqlite3.dll');
  return DynamicLibrary.open(libraryNextToScript);
}

void main() {
  if (Platform.isWindows) {
    open.overrideFor(OperatingSystem.windows, _openOnWindows);
  }

  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   // setWindowTitle("Golden Gym");
  //   setWindowMinSize(const Size(800, 500));
  //   setWindowMaxSize(Size.infinite);
  // }

  EasyLocalization.logger.enableLevels = <LevelMessages>[
    LevelMessages.error,
    LevelMessages.warning,
  ];
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('ar', 'EG'),
      Locale('en', 'US'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('ar', 'EG'),
    startLocale: const Locale('ar', 'EG'),
    child: Provider(
      create: (_) => AppDatabase().memberDao,
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MembersProvider(context.read<MemberDao>())),
        ChangeNotifierProvider(create: (_) => SearchMembersProvider(context.read<MemberDao>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Golden Gym',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: _renderAppTheme(),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _renderAppTheme() {
    return ThemeData.dark().copyWith(
      progressIndicatorTheme: ThemeData.dark().progressIndicatorTheme.copyWith(
            color: CColors.darkGold,
          ),
      inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
            focusColor: Colors.amber,
            fillColor: CColors.lightBlack,
            errorStyle: TextStyle(
              color: CColors.mainRed,
            ),
          ),
      toggleableActiveColor: CColors.darkGold,
      // primaryColor: CColors.darkGold,
      textSelectionTheme: ThemeData.dark().textSelectionTheme.copyWith(
            cursorColor: CColors.darkGold,
          ),
      dialogTheme: ThemeData.dark().dialogTheme.copyWith(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
      backgroundColor: CColors.lightBlack,
      accentColor: Colors.red,
      textTheme: TextTheme(
        headline6: ThemeData.dark().textTheme.headline6?.copyWith(
              fontWeight: FontWeight.normal,
            ),
      ),
      floatingActionButtonTheme: ThemeData.dark().floatingActionButtonTheme.copyWith(
            foregroundColor: CColors.gold,
            backgroundColor: CColors.fancyBlack,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
          primary: Colors.white,
        ),
      ),
    );
  }
}
