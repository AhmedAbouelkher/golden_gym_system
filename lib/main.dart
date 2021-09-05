import 'dart:ffi';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import './db/local_db.dart';
import 'package:sqlite3/open.dart';

//? https://moor.simonbinder.eu/docs/platforms/#desktop
//? https://github.com/simolus3/moor/issues/731

DynamicLibrary _openOnWindows() {
  final script = Directory.fromUri(Platform.script).parent;
  final libraryNextToScript = join(script.path, 'sqlite3.dll');
  return DynamicLibrary.open(libraryNextToScript);
}

void main() {
  open.overrideFor(OperatingSystem.windows, _openOnWindows);

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
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Provider(
      create: (_) => AppDatabase().memberDao,
      child: MaterialApp(
        title: 'Golden Gym',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const HomeScreen(),
      ),
    );
  }
}
