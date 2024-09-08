import 'package:bai_system/api/model/bai_model/payment_model.dart';
import 'package:bai_system/api/service/bai_be/payment_service.dart';
import 'package:bai_system/component/loading_component.dart';
import 'package:bai_system/representation/payment.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api/model/bai_model/api_response.dart';
import '../component/snackbar.dart';
import '../core/const/frontend/message.dart';
import '../core/helper/return_login_dialog.dart';

class VnPayWebView extends StatefulWidget {
  final String vnpBankCode;
  final String packageId;
  final Function(bool) onPaymentCompleted;
  const VnPayWebView({
    super.key,
    required this.vnpBankCode,
    required this.packageId, // Nhận packageId
    required this.onPaymentCompleted,
  });

  static String routeName = '/vnpay';

  @override
  State<VnPayWebView> createState() => _VnPayWebViewState();
}

class _VnPayWebViewState extends State<VnPayWebView> {
  late WebViewController _controller;
  var log = Logger();
  String paymentUrl = '';
  bool isLoading = true;
  final paymetApi = CallPaymentApi();

  Function(bool) _onPaymentCompleted = (bool isCompleted) {
    return isCompleted;
  };

  @override
  void initState() {
    super.initState();
    _onPaymentCompleted = widget.onPaymentCompleted;
    getPaymentUrl(widget.packageId, widget.vnpBankCode);
  }

  void _initializeWebView(String paymentUrl) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            if (url.contains('callback/vnpay')) {
              // Payment return
              VnPayReturn vnPayReturn = VnPayReturn.fromUrl(url);
              log.d('VnPayReturn: ${vnPayReturn.toString()}');
              _handlePayment(vnPayReturn);
            }
          },
          onWebResourceError: (WebResourceError error) {
            log.e(
                "WebResourceError: ${error.errorCode}, ${error.description}, ${error.url}");
            // _handlePaymentFailure();
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.contains('callback/vnpay')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (paymentUrl.isNotEmpty) WebViewWidget(controller: _controller),
          if (isLoading) const LoadingCircle(),
        ],
      ),
    );
  }

  void _handlePayment(VnPayReturn vnPayReturn) {
    log.d('_handlePayment called with: $vnPayReturn');
    if (vnPayReturn.vnpResponseCode == '00' &&
        vnPayReturn.vnpTransactionStatus == '00') {
      _handlePaymentSuccess();
    } else {
      _handlePaymentFailure();
    }
  }

  void _handlePaymentSuccess() {
    log.d('_handlePaymentSuccess called');
    _onPaymentCompleted(true);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      PaymentScreen.routeName,
      (route) => false,
    );
  }

  void _handlePaymentFailure() {
    log.d('_handlePaymentFailure called');
    _onPaymentCompleted(false);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  // Gọi API để lấy URL thanh toán
  void getPaymentUrl(String packageId, String bankCode) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      final APIResponse<VnPayResponse> paymentMd =
          await paymetApi.depositCoinVnPay(packageId, bankCode);

      if (paymentMd.isTokenValid == false &&
          paymentMd.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        // Hiển thị dialog login
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      // Kiểm tra nếu có lỗi
      if (paymentMd.message == ErrorMessage.somethingWentWrong) {
        showSnackBar(ErrorMessage.somethingWentWrong);
        return;
      }

      if (paymentMd.data != null) {
        setState(() {
          paymentUrl = paymentMd.data!.paymentUrl;
          _initializeWebView(paymentUrl);
        });
      }
    } catch (e) {
      log.e('Error during get payment url: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hiển thị snackbar
  void showSnackBar(String message, {int type = 0}) {
    Color backgroundColor = type == 0
        ? Theme.of(context).colorScheme.outline
        : (type == 1
            ? Theme.of(context).colorScheme.onError
            : Theme.of(context).colorScheme.error);
    showCustomSnackBar(
      MySnackBar(
        message: message,
        prefix: Icon(
          Icons.info,
          color: Theme.of(context).colorScheme.surface,
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Hiển thị custom snackbar
  void showCustomSnackBar(MySnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBar,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
