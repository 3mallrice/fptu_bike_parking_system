import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/model/bai_model/coin_package_model.dart';
import 'package:bai_system/api/service/bai_be/payment_service.dart';
import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/my_radio_button.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:bai_system/representation/receipt.dart';
import 'package:bai_system/representation/wallet_screen.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:logger/logger.dart';
import 'package:vnpay_client/vnpay_client.dart';

import '../api/model/bai_model/payment_model.dart';
import '../component/dialog.dart';
import '../component/snackbar.dart';
import '../core/const/utilities/util_helper.dart';
import '../core/helper/asset_helper.dart';
import '../core/helper/loading_overlay_helper.dart';
import '../core/helper/return_login_dialog.dart';

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

class _PaymentScreenState extends State<PaymentScreen> {
  // State variable to track the selected payment option
  int selectedPaymentOption = 0;
  late final CoinPackage _package = widget.package;
  var log = Logger();

  bool isLoading = true;
  final CallPaymentApi paymentApi = CallPaymentApi();
  late ZaloPayModel zaloPayModel;
  String payResult = "";
  int type = 0;
  bool isOverload = false;

  String paymentUrl = '';

  @override
  initState() {
    super.initState();
  }

  // BUY NOW
  Future<void> buyNow(String packageId) async {
    if (!mounted) return;
    setState(() {
      isLoading = true; // Đặt isLoading thành true khi bắt đầu
    });

    try {
      final APIResponse<ZaloPayModel> zaloPayMd =
          await paymentApi.depositCoinZaloPay(packageId);

      if (zaloPayMd.isTokenValid == false &&
          zaloPayMd.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show login dialog
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      // check if message contain Error message
      if (zaloPayMd.data == null ||
          zaloPayMd.message == ErrorMessage.somethingWentWrong) {
        showSnackBar(ErrorMessage.somethingWentWrong);
      } else {
        setState(() {
          zaloPayModel = zaloPayMd.data!;
          isLoading = false;
        });
      }
    } catch (e) {
      log.e('Error during buy now: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openZaloPayApp(CoinPackage package) async {
    await buyNow(package.id);

    await FlutterZaloPaySdk.payOrder(zpToken: zaloPayModel.zpTransToken)
        .then((event) {
      setState(() {
        switch (event) {
          case FlutterZaloPayStatus.processing:
            payResult = ZaloPayMessage.processing;
            type = 0;
            break;
          case FlutterZaloPayStatus.cancelled:
            payResult = ZaloPayMessage.cancelled;
            type = 0;
            break;
          case FlutterZaloPayStatus.success:
            payResult = ZaloPayMessage.success;
            type = 1;
            break;
          case FlutterZaloPayStatus.failed:
            payResult = ZaloPayMessage.failed;
            type = 2;
            break;
          default:
            payResult = ZaloPayMessage.failed;
            type = 2;
            break;
        }
        log.i('Pay result: $payResult');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Payment',
      ),
      body: PopScope(
        onPopInvoked: (didPop) {
          if (!mounted) return;
          if (isOverload) {
            LoadingOverlayHelper.hide();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShadowContainer(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.outline,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pending,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Transaction Details',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Move Money',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                        ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        UltilHelper.formatMoney(_package.price),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '₫',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: DottedLine(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      lineLength: double.infinity,
                                      lineThickness: 1.0,
                                      dashColor:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Table(
                                      columnWidths: const {
                                        0: FractionColumnWidth(0.25)
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Text(
                                              'Type',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              'Deposit',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Text(
                                              'Message',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              // Message show that buy package name
                                              'Buy ${_package.packageName} to get ${UltilHelper.formatMoney(int.parse(_package.amount))} bic coins',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select your payment options',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),

                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),

                      // ZaloPay
                      RadioButtonCustom(
                        //bank icon
                        prefixWidget: Image.asset(
                          AssetHelper.zaloLogo,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                        contentWidget: Text(
                          'ZaloPay E-Wallet',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 15,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        isSelected: selectedPaymentOption == 1,
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              selectedPaymentOption = 1;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 15),
                      RadioButtonCustom(
                        //bank icon
                        prefixWidget: Icon(
                          Icons.account_balance_rounded,
                          size: 25,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        contentWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Domestic Bank',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              'ATM, Internet Banking, ...',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        isSelected: selectedPaymentOption == 2,
                        onTap: () {
                          setState(() {
                            selectedPaymentOption = 2;
                          });
                        },
                      ),

                      const SizedBox(height: 15),
                      RadioButtonCustom(
                        //bank icon
                        prefixWidget: Icon(
                          Icons.credit_card_rounded,
                          size: 25,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        contentWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'International Card',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              'Visa, MasterCard, ...',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        isSelected: selectedPaymentOption == 3,
                        onTap: () {
                          setState(() {
                            selectedPaymentOption = 3;
                          });
                        },
                      ),

                      const SizedBox(height: 15),
                      RadioButtonCustom(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        //bank icon
                        prefixWidget: SvgPicture.asset(
                          AssetHelper.vnpay,
                          height: 30,
                          fit: BoxFit.fitHeight,
                        ),
                        contentWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VNPAY E-Wallet',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              // not supported yet
                              'Not supported yet',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        // isSelected: selectedPaymentOption == 4,
                        isSelected: false,
                        onTap: () {
                          if (!mounted) return;
                          setState(() {
                            // selectedPaymentOption = 4;
                            selectedPaymentOption = selectedPaymentOption;
                          });
                        },
                      ),

                      const SizedBox(height: 15),
                      RadioButtonCustom(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        //bank icon
                        prefixWidget: SvgPicture.asset(
                          AssetHelper.vnpayQR,
                          height: 30,
                          fit: BoxFit.fitHeight,
                        ),
                        contentWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VNPAY QR',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              'Not supported yet',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        // isSelected: selectedPaymentOption == 5,
                        isSelected: false,
                        onTap: () {
                          if (!mounted) return;
                          setState(() {
                            // selectedPaymentOption = 5;
                            selectedPaymentOption = selectedPaymentOption;
                          });
                        },
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 10),
              // margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      //close payment screen
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      LabelMessage.close,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selectedPaymentOption == 0) {
                        showSnackBar(ErrorMessage.paymentMethod);
                        return;
                      }
                      btnPay(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          LabelMessage.pay,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }

  void btnPay(BuildContext context) {
    LoadingOverlayHelper.show(context);
    if (mounted) {
      setState(() {
        isOverload = true;
      });
    }
    if (selectedPaymentOption == 1) {
      //open ZaloPay app
      openZaloPayApp(_package).then((_) {
        LoadingOverlayHelper.hide();
        showSnackBar(payResult, type: type);

        //redirect to home screen if payment success
        if (type == 1) {
          //close payment screen
          Navigator.of(context).pushReplacementNamed(ReceiptScreen.routeName);
        }
      });
    } else {
      // call payment api to get payment url
      String vnpBankCode = 'VNBANK';

      if (selectedPaymentOption == 3) {
        vnpBankCode = 'INTCARD';
      }

      getPaymentUrl(_package.id, vnpBankCode);
      LoadingOverlayHelper.hide();

      if (paymentUrl.isNotEmpty && paymentUrl != '') {
        showVNPayScreen(
          context,
          paymentUrl: paymentUrl,
          onPaymentSuccess: (value) {
            log.i('Payment success: $value');
            showReceiptDialog(context, true, _package, selectedPaymentOption);
          },
          onPaymentError: (error) {
            log.e('Payment error: $error');
            showReceiptDialog(context, false, _package, selectedPaymentOption);
          },
        );
      }
    }
  }

  void showReceiptDialog(BuildContext context, bool isSuccess,
      CoinPackage package, int selectedPaymentOption) {
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
            child: dialogContent(
                context, isSuccess, package, selectedPaymentOption),
          ),
          onClick: () {
            isSuccess
                ? Navigator.of(context).pushReplacementNamed(MyWallet.routeName)
                : Navigator.of(context).pop();
          },
          contentPadding: const EdgeInsets.all(20),
        );
      },
    );
  }

  // show snackbar
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

  // show custom snackbar
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

  // #region VnPay
  // Call API to get payment url
  void getPaymentUrl(String packageId, String bankCode) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      final APIResponse<VnPayResponse> paymentMd =
          await paymentApi.depositCoinVnPay(packageId, bankCode);

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

  // Show receipt dialog
  Widget dialogContent(BuildContext context, bool isSuccess,
      CoinPackage package, int selectedPaymentOption) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSuccess ? Icons.check_circle : Icons.cancel,
          color: isSuccess
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.error,
          size: 50,
        ),
        const SizedBox(height: 15),
        Text(
          isSuccess
              ? 'Your payment was successful!'
              : 'Payment failed. Please try again.',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Text(
          'Package: ${package.packageName}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 5),
        Text(
          'Amount: ${package.amount} coins',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 5),
        Text(
          'Extra: ${package.extraCoin} coins',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 5),
        Text(
          'EXP Date: ${package.extraEXP} days',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 15),
        DottedLine(
          dashColor: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 15),
        Text(
          'Payment Method: ${selectedPaymentOption == 1 ? 'ZaloPay' : 'VNPAY Gateway'}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
  // #endregion
}
