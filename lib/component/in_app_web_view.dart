import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/dialog.dart';
import 'package:fptu_bike_parking_system/core/const/frondend/message.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'app_bar_component.dart';

class InAppWebView extends StatelessWidget {
  final String url;
  final String title;

  const InAppWebView({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // initialize the webview controller
    late final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(Theme.of(context).colorScheme.background)
      ..setNavigationDelegate(NavigationDelegate(
        //handle error
        onHttpError: (error) {
          //show error dialog
          OKDialog(
            title: ErrorMessage.error,
            content: Text(
              ErrorMessage.errorWhileLoading,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onClick: () => Navigator.of(context).pop(),
          );
        },
      ))
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBarCom(
        leading: false,
        appBarText: title,
        titleTextStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.background,
            ),
        backgroundColor: Theme.of(context).colorScheme.outline,
        action: [
          // share icon
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () => Share.shareUri(Uri.parse(url)),
              child: Icon(
                Icons.share,
                size: 20,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
