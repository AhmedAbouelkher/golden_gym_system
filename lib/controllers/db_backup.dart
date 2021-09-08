import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackUp {
  static const _key = '__backup__';

  void init() async {
    final connectionState = await Connectivity().checkConnectivity();
    if (connectionState == ConnectivityResult.ethernet || connectionState == ConnectivityResult.wifi) {
      _handleBackup();
    }
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // do something //
      // ignore: avoid_print
      print(result);
      _handleBackup();
    });
  }

  void _handleBackup() async {
    final _shouldBackup = await _shouldBackUp();
    if (!_shouldBackup) {
      log("Skipping backing up local db");
      return;
    }
    //* Get the db file
    final dbFile = await getDBFile();
    //* Upload db file
    try {
      await _uploadBackUp(dbFile);
      await _upadateBackupTime(DateTime.now());
      log("Uploaded new backup");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> _shouldBackUp() async {
    final db = await SharedPreferences.getInstance();
    final date = DateTime.tryParse(db.getString(_key) ?? '');
    if (date != null) {
      final diff = Duration(seconds: timeSubInSeconds(date));
      return diff.inDays >= 3;
    }
    return true;
  }

  Future<void> _upadateBackupTime(DateTime time) async {
    final db = await SharedPreferences.getInstance();
    await db.setString(_key, time.toIso8601String());
  }

  int timeSubInSeconds(DateTime startTime, {bool fromThis = false}) {
    final _currentTime = DateTime.now();
    //? Time Def in seconds
    final int _sub = (_currentTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) ~/ 1000;
    return _sub;
  }

  Future _uploadBackUp(File file) async {
    final multiPartFile = await MultipartFile.fromFile(file.path);
    final formData = FormData.fromMap({'file': multiPartFile});
    final res = await Dio().post('https://ahmed-golden-gym-system.herokuapp.com/upload_db', data: formData);
    if (res.statusCode != 200) throw Exception('Backing up db failed');
    return Future.value(res.data);
  }
}
