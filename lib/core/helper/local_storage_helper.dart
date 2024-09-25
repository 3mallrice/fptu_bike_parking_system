import 'package:bai_system/api/model/bai_model/login_model.dart';
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
      _shared.hiveBox = await Hive.openBox('Bai System');
    } catch (e) {
      _shared.log.e('Failed to open hive box: $e');
    }
  }

  // Create a namespaced key for each user
  static String _getNamespacedKey(String key, String email) {
    return '${email}_$key';
  }

  // Get value from local storage
  static dynamic getValue(String key, String email) {
    String namespacedKey = _getNamespacedKey(key, email);
    dynamic value = _shared.hiveBox?.get(namespacedKey);
    _shared.log.i('Get value for key: $namespacedKey -> $value');
    return value;
  }

  // Set value to local storage
  static setValue(String key, dynamic val, String email) {
    String namespacedKey = _getNamespacedKey(key, email);
    _shared.hiveBox?.put(namespacedKey, val);
    _shared.log.i('Set value for key: $namespacedKey -> $val');
  }

  static Future<void> setFCMTokenValue(String fcmToken) async {
    await _shared.hiveBox?.put(LocalStorageKey.fcmToken, fcmToken);
    _shared.log.i('Set FCM token: $fcmToken');
  }

  static String? getFCMTokenValue() {
    String? fcmToken = _shared.hiveBox?.get(LocalStorageKey.fcmToken);
    _shared.log.i('Get FCM token: $fcmToken');
    return fcmToken;
  }

  // get ignore intro screen from local storage
  static bool? getIgnoreIntroScreen() {
    bool? ignoreIntroScreen =
        _shared.hiveBox?.get(LocalStorageKey.ignoreIntroScreen);
    _shared.log.i('Get ignore intro screen: $ignoreIntroScreen');
    return ignoreIntroScreen;
  }

  // save ignore intro screen to local storage
  static Future<void> setIgnoreIntroScreen() async {
    await _shared.hiveBox?.put(LocalStorageKey.ignoreIntroScreen, true);
    _shared.log.i('Set ignore intro screen');
  }

  // save current email to local storage
  static Future<void> setCurrentUserEmail(String email) async {
    await _shared.hiveBox?.put(LocalStorageKey.currentUserEmailKey, email);
    _shared.log.i('Set current user email: $email');
  }

  // get current email from local storage
  static String? getCurrentUserEmail() {
    String? email = _shared.hiveBox?.get(LocalStorageKey.currentUserEmailKey);
    _shared.log.i('Get current user email: $email');
    return email;
  }

  static Future<void> clearCurrentUser() async {
    await _shared.hiveBox?.delete(LocalStorageKey.currentUserEmailKey);
    await _shared.hiveBox?.delete(LocalStorageKey.userData);
    await _shared.hiveBox?.delete(LocalStorageKey.fcmToken);
    _shared.log.i('Clear current user data');
  }
}

class LocalStorageKey {
  static const String userData = 'userData';
  static const String ignoreIntroScreen = 'ignoreIntroScreen';
  static const String isHiddenBalance = 'isHiddenBalance';
  static const String fcmToken = 'fcmToken';
  static const String pageSize = 'pageSize';
  static const String storageKey = 'notifications';
  static const String currentUserEmailKey = 'currentUserEmail';
  static const String currentCustomerType = 'currentCustomerType';
}

class GetLocalHelper {
  static UserData? getUserData(String email) {
    return LocalStorageHelper.getValue(LocalStorageKey.userData, email) != null
        ? UserData.fromJson(
            LocalStorageHelper.getValue(LocalStorageKey.userData, email))
        : null;
  }

  static String? getBearerToken(String email) {
    UserData? userData = getUserData(email);
    return userData != null ? 'Bearer ${userData.bearerToken}' : null;
  }

  static int getPageSize(String email) =>
      LocalStorageHelper.getValue(LocalStorageKey.pageSize, email) ?? 10;

  static bool getHideBalance(String email) =>
      LocalStorageHelper.getValue(LocalStorageKey.isHiddenBalance, email) ??
      false;

  static String? getCurrentCustomerType(String email) {
    UserData? userData = getUserData(email);
    return userData?.customerType;
  }
}

class SetLocalHelper {
  static Future<void> setUserData(String email, String username) async {
    UserData? userData = GetLocalHelper.getUserData(email);

    userData?.name = username;
    await LocalStorageHelper.setValue(
        LocalStorageKey.userData, userData?.toJson(), email);
  }

  static Future<void> setPageSize(String email, int pageSize) async {
    await LocalStorageHelper.setValue(
        LocalStorageKey.pageSize, pageSize, email);
  }

  static Future<void> setHideBalance(String email, bool isHidden) async {
    await LocalStorageHelper.setValue(
        LocalStorageKey.isHiddenBalance, isHidden, email);
  }

  static Future<void> setCurrentCustomerType(
      String email, String customerType) async {
    await LocalStorageHelper.setValue(
        LocalStorageKey.isHiddenBalance, customerType, email);
  }
}
