import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class LocalStorageHelper {
  var log = Logger();
  LocalStorageHelper._internal();
  static final LocalStorageHelper _shared = LocalStorageHelper._internal();

  factory LocalStorageHelper() {
    return _shared;
  }

  Box<dynamic>? hiveBox;

  static initLocalStorageHelper() async {
    try {
      _shared.hiveBox = await Hive.openBox('Bai');
    } catch (e) {
      _shared.log.e('Failed to open hive box: $e');
    }
  }

  static dynamic getValue(String key) {
    dynamic value = _shared.hiveBox?.get(key);
    _shared.log.i(value);
    return value;
  }

  static setValue(String key, dynamic val) {
    _shared.hiveBox?.put(key, val);
  }
}

class LocalStorageKey {
  static const String userData = 'userData';
  static const String ignoreIntroScreen = 'ignoreIntroScreen';
  static const String isHiddenBalance = 'isHiddenBalance';
}
