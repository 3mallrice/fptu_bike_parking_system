import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../representation/no_connection_screen.dart';
import '../service/internet_connection_checker.dart';

class InternetConnectionWrapper extends StatefulWidget {
  final String? goToPageRouteName;
  final Widget child;

  const InternetConnectionWrapper(
      {super.key, required this.child, this.goToPageRouteName});

  @override
  State<InternetConnectionWrapper> createState() =>
      _InternetConnectionWrapperState();
}

class _InternetConnectionWrapperState extends State<InternetConnectionWrapper>
    with WidgetsBindingObserver {
  final _log = Logger();
  late final StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    // Thêm observer để lắng nghe trạng thái của ứng dụng
    WidgetsBinding.instance.addObserver(this);

    // Đăng ký subscription để lắng nghe trạng thái kết nối
    _subscription = context
        .read<InternetConnectionService>()
        .connectionStream
        .listen((isConnected) {
      if (!isConnected) {
        _log.d('No internet connection');
      }
    });
  }

  @override
  void dispose() {
    // Xóa observer và huỷ đăng ký subscription
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    super.dispose();
  }

  // Call when the app's lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _log.d('App resumed');
      _subscription.resume();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _log.d('App paused or inactive');
      _subscription.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetConnectionService>(
      builder: (context, internetService, _) {
        return StreamBuilder<bool>(
          stream: internetService.connectionStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.data!) {
              // If there is no internet connection, show the NoInternetScreen
              return NoInternetScreen(
                goToPageRouteName: widget.goToPageRouteName,
              );
            }
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: widget.child,
            );
          },
        );
      },
    );
  }
}
