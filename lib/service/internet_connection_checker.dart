import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionService {
  final StreamController<bool> _connectionController =
  StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;

  InternetConnectionService() {
    InternetConnection().onStatusChange.listen((status) {
      // bool isConnected = (status == InternetStatus.connected);
      bool isConnected = true;
      _connectionController.add(isConnected);
    });
  }

  void dispose() {
    _connectionController.close();
  }
}
