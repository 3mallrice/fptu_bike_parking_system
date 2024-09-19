import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/model/bai_model/coin_package_model.dart';
import 'package:bai_system/api/service/bai_be/payment_service.dart';
import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/my_radio_button.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:bai_system/representation/receipt.dart';
import 'package:bai_system/representation/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:logger/logger.dart';
import 'package:vnpay_client/vnpay_client.dart';

import '../api/model/bai_model/payment_model.dart';
import '../component/dialog.dart';
import '../component/internet_connection_wrapper.dart';
import '../component/snackbar.dart';
import '../core/const/utilities/util_helper.dart';
import '../core/helper/asset_helper.dart';
import '../core/helper/loading_overlay_helper.dart';

class PaymentScreen extends StatefulWidget {
  final CoinPackage package;

  const PaymentScreen({
    super.key,
    required this.package,
  });

  static const String routeName = '/payment_screen';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with ApiResponseHandler {
  int selectedPaymentOption = 0;
  late final CoinPackage _package = widget.package;
  final log = Logger();
  final CallPaymentApi paymentApi = CallPaymentApi();
  final _overlayHelper = LoadingOverlayHelper();
  late ZaloPayModel zaloPayModel;
  String payResult = "";
  int type = 0;
  bool isOverload = false;
  String paymentUrl = '';
  bool isCanPop = true;

  @override
  void dispose() {
    super.dispose();
    _overlayHelper.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionWrapper(
      child: Scaffold(
        appBar: const MyAppBar(
          automaticallyImplyLeading: true,
          title: 'Payment',
        ),
        body: PopScope(
          onPopInvoked: (didPop) {
            if (isOverload) {
              _overlayHelper.hide();
            }
            if (!isCanPop) {
              return;
            }
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTransactionDetails(),
                        const SizedBox(height: 30),
                        Text(
                          'Select your payment options',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 10),
                        _buildPaymentOptions(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return ShadowContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(5)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pending,
                    color: Theme.of(context).colorScheme.surface),
                const SizedBox(width: 10),
                Text(
                  'Transaction Details',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.background,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  'Move Money',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UltilHelper.formatMoney(_package.price),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                    Text(
                      ' ₫',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                              ),
                    ),
                  ],
                ),
                Divider(
                  height: 30,
                  indent: MediaQuery.of(context).size.width * 0.05,
                  endIndent: MediaQuery.of(context).size.width * 0.05,
                ),
                _buildTransactionInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Table(
        columnWidths: const {0: FractionColumnWidth(0.25)},
        children: [
          _buildTableRow('Type', 'Deposit'),
          _buildTableRow('Message', 'Buy ${_package.packageName}'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRadioButton(
          1,
          AssetHelper.zaloPayLogo,
          'ZaloPay E-Wallet',
          isImage: true,
        ),
        _buildRadioButton(
          2,
          Icons.account_balance_rounded,
          'Domestic Bank',
          subtitle: 'ATM, Internet Banking',
        ),
        _buildRadioButton(
          3,
          Icons.credit_card_rounded,
          'International Card',
          subtitle: 'Visa, MasterCard, ...',
        ),
        _buildRadioButton(
          4,
          AssetHelper.vnpay,
          'VNPAY E-Wallet',
          subtitle: 'Not supported yet',
          isSvg: true,
          isDisabled: true,
        ),
        _buildRadioButton(
          5,
          AssetHelper.vnpayQR,
          'VNPAY QR',
          subtitle: 'Not supported yet',
          isSvg: true,
          isDisabled: true,
        ),
      ],
    );
  }

  Widget _buildRadioButton(
    int value,
    dynamic icon,
    String title, {
    String? subtitle,
    bool isImage = false,
    bool isSvg = false,
    bool isDisabled = false,
  }) {
    Widget prefixWidget;
    if (isImage) {
      prefixWidget = Image.asset(icon, height: 30, fit: BoxFit.contain);
    } else if (isSvg) {
      prefixWidget = SvgPicture.asset(icon, height: 30, fit: BoxFit.fitHeight);
    } else {
      prefixWidget =
          Icon(icon, size: 25, color: Theme.of(context).colorScheme.outline);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: RadioButtonCustom(
        color: isDisabled ? Theme.of(context).colorScheme.outlineVariant : null,
        prefixWidget: prefixWidget,
        contentWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 15),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        isSelected: selectedPaymentOption == value,
        onTap: isDisabled
            ? null
            : () {
                setState(() => selectedPaymentOption = value);
              },
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              LabelMessage.close,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ElevatedButton(
            onPressed: () => btnPay(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            ),
            child: Text(
              LabelMessage.pay,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void btnPay(BuildContext context) async {
    if (selectedPaymentOption == 0) {
      showSnackBar(ErrorMessage.paymentMethod);
      return;
    }

    _overlayHelper.show(context);
    setState(() => isOverload = true);

    try {
      if (selectedPaymentOption == 1) {
        await _handleZaloPayPayment();
      } else {
        await _handleVNPayPayment();
      }
    } catch (e) {
      log.e('Error during payment: $e');
      showSnackBar('An error occurred during payment. Please try again.');
    } finally {
      if (isOverload) {
        _overlayHelper.hide();
        setState(() => isOverload = false);
      }
    }
  }

  Future<void> _handleZaloPayPayment() async {
    await openZaloPayApp(_package);
    showSnackBar(payResult, type: type);
    if (type == 1) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(ReceiptScreen.routeName);
    }
  }

  Future<void> _handleVNPayPayment() async {
    String vnpBankCode = selectedPaymentOption == 3 ? 'INTCARD' : 'VNBANK';
    await getPaymentUrl(_package.id, vnpBankCode);

    if (isOverload) {
      _overlayHelper.hide();
      setState(() => isOverload = false);
    }

    bool? isPaymentSuccess;
    dynamic vnPayData;

    if (paymentUrl.isNotEmpty) {
      if (!mounted) return;
      await showVNPayScreen(
        context,
        paymentUrl: paymentUrl,
        onPaymentSuccess: (value) {
          log.i('Payment success: $value');
          isPaymentSuccess = true;
          vnPayData = value;
        },
        onPaymentError: (error) {
          log.e('Payment error: $error');
          isPaymentSuccess = false;
          vnPayData = error;
        },
      );

      _handlePaymentResult(isPaymentSuccess!, vnpayData: vnPayData);
      showSnackBar(isPaymentSuccess! ? 'Payment success!' : 'Payment failed!',
          type: isPaymentSuccess! ? 1 : 2);
    }
  }

  void _handlePaymentResult(bool result, {Map<String, dynamic>? vnpayData}) =>
      showReceiptDialog(
        context,
        result,
        _package,
        selectedPaymentOption,
        vnpayData: vnpayData,
      );

  Future<void> openZaloPayApp(CoinPackage package) async {
    await buyNow(package.id);
    final event =
        await FlutterZaloPaySdk.payOrder(zpToken: zaloPayModel.zpTransToken);
    setState(() {
      switch (event) {
        case FlutterZaloPayStatus.success:
          payResult = ZaloPayMessage.success;
          type = 1;
          break;
        case FlutterZaloPayStatus.failed:
          payResult = ZaloPayMessage.failed;
          type = 2;
          break;
        case FlutterZaloPayStatus.cancelled:
          payResult = ZaloPayMessage.cancelled;
          type = 0;
          break;
        default:
          payResult = ZaloPayMessage.failed;
          type = 2;
      }
    });
  }

  Future<void> buyNow(String packageId) async {
    try {
      final APIResponse<ZaloPayModel> response =
          await paymentApi.depositCoinZaloPay(packageId);

      if (!mounted) return;

      final bool isResponseValid = await handleApiResponseBool(
        context: context,
        response: response,
        showErrorDialog: _showErrorDialog,
      );

      if (!isResponseValid) return;

      setState(() => zaloPayModel = response.data!);
    } catch (e) {
      log.e('Error during buy now: $e');
      showSnackBar('An error occurred. Please try again.');
    }
  }

  Future<void> getPaymentUrl(String packageId, String bankCode) async {
    try {
      final APIResponse<VnPayResponse> response =
          await paymentApi.depositCoinVnPay(packageId, bankCode);

      if (!mounted) return;

      final bool isResponseValid = await handleApiResponseBool(
        context: context,
        response: response,
        showErrorDialog: _showErrorDialog,
      );

      if (!isResponseValid) return;

      if (response.data != null) {
        setState(() => paymentUrl = response.data!.paymentUrl);
      }
    } catch (e) {
      log.e('Error during get payment url: $e');
      showSnackBar('An error occurred. Please try again.');
    }
  }

  void showReceiptDialog(
    BuildContext context,
    bool isSuccess,
    CoinPackage package,
    int selectedPaymentOption, {
    Map<String, dynamic>? vnpayData,
  }) {
    log.i('Payment ${isSuccess ? 'success' : 'failure'}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: 'Payment ${isSuccess ? 'Success' : 'Failure'}',
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: _buildReceiptContent(
                context, isSuccess, package, selectedPaymentOption,
                vnpayData: vnpayData),
          ),
          onClick: () {
            isSuccess
                ? Navigator.of(context)
                    .pushReplacementNamed(WalletScreen.routeName)
                : Navigator.of(context).pop();
          },
          contentPadding: const EdgeInsets.all(20),
        );
      },
    );
  }

  Widget _buildReceiptContent(BuildContext context, bool isSuccess,
      CoinPackage package, int selectedPaymentOption,
      {Map<String, dynamic>? vnpayData}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Icon(
            isSuccess ? Icons.check_circle : Icons.cancel,
            color: isSuccess
                ? Theme.of(context).colorScheme.onError
                : Theme.of(context).colorScheme.error,
            size: 50,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          isSuccess
              ? 'Your payment was successful!'
              : 'Payment failed. Please try again.',
          style: Theme.of(context).textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Text(
              'Package Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            tilePadding: const EdgeInsets.all(0),
            visualDensity: VisualDensity.comfortable,
            childrenPadding: const EdgeInsets.only(bottom: 10),
            children: [
              _buildReceiptInfoRow('Package', package.packageName),
              _buildReceiptInfoRow('Amount',
                  '${UltilHelper.formatMoney(int.parse(package.amount))} coins'),
              _buildReceiptInfoRow(
                'Extra',
                package.extraCoin != null
                    ? '${UltilHelper.formatMoney(package.extraCoin ?? 0)} coins'
                    : null,
              ),
              _buildReceiptInfoRow('EXP Date', '${package.extraEXP} days'),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Divider(),
        const SizedBox(height: 5),
        _buildReceiptInfoRow('Payment Method',
            selectedPaymentOption == 1 ? 'ZaloPay' : 'VNPAY Gateway'),
        _buildReceiptInfoRow('Transaction Date',
            UltilHelper.formatVnPayDate(vnpayData?['vnp_PayDate'])),
        _buildReceiptInfoRow(
            'Transaction No', vnpayData?['vnp_TransactionNo'] ?? ''),
        _buildReceiptInfoRow('Bank', vnpayData?['vnp_BankCode'] ?? ''),
        _buildReceiptInfoRow(
            'Order Info', Uri.decodeFull(vnpayData?['vnp_OrderInfo'] ?? '')),
      ],
    );
  }

  Widget _buildReceiptInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Tooltip(
              message: value ?? '-',
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1),
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
              triggerMode: TooltipTriggerMode.tap,
              waitDuration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  value ?? '-',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackBar(String message, {int type = 0}) {
    Color backgroundColor = type == 0
        ? Theme.of(context).colorScheme.outline
        : (type == 1
            ? Theme.of(context).colorScheme.onError
            : Theme.of(context).colorScheme.error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MySnackBar(
          message: message,
          prefix: Icon(
            Icons.info,
            color: Theme.of(context).colorScheme.surface,
          ),
          backgroundColor: backgroundColor,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: ErrorMessage.error,
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.justify,
          ),
        );
      },
    );
  }
}
