import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/coin_package_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/payment_service.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/my_radio_button.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/const/frondend/message.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:fptu_bike_parking_system/representation/home.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/zalopay_model.dart';
import '../component/snackbar.dart';
import '../core/helper/loading_overlay_helper.dart';
import '../core/helper/util_helper.dart';

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
  int selectedPaymentOption = 1; // Default selection = ZaloPay
  late final CoinPackage _package = widget.package;
  var log = Logger();

  bool isLoading = true;
  final CallPaymentApi _paymentApi = CallPaymentApi();
  late ZaloPayModel zaloPayModel;
  String payResult = "";
  int type = 0;
  late Color btnColor = Theme.of(context).colorScheme.primary;
  late String txtPay = LabelMessage.pay.toUpperCase();

  @override
  initState() {
    super.initState();
  }

  // BUY NOW
  Future<void> buyNow(String packageId) async {
    setState(() {
      isLoading = true; // Đặt isLoading thành true khi bắt đầu
    });

    try {
      final ZaloPayModel? zaloPayMd = await _paymentApi.depositCoin(packageId);
      if (zaloPayMd != null) {
        setState(() {
          zaloPayModel = zaloPayMd;
          isLoading = false; // Đặt isLoading thành false khi hoàn thành
        });
      }
    } catch (e) {
      log.e('Error during buy now: $e');
      setState(() {
        isLoading =
            false; // Đảm bảo isLoading được đặt thành false ngay cả khi xảy ra lỗi
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
    return PopScope(
      onPopInvoked: (didPop) {
        dispose();
        LoadingOverlayHelper.hide();
      },
      child: Scaffold(
        appBar: const AppBarCom(
          leading: true,
          appBarText: 'Payment',
        ),
        body: Column(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage(AssetHelper.baiLogo),
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            'ID: Copy',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
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
                                  const SizedBox(height: 5),
                                  Text(
                                    UltilHelper.formatDateTime(DateTime.now()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        UltilHelper.formatNumber(
                                            _package.price),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        'VND',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w900,
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
                                              'Buy ${_package.packageName} to get ${UltilHelper.formatNumber(int.parse(_package.amount))} bic coins',
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
                          'ZaloPay',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 17,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        isSelected: selectedPaymentOption == 1,
                        onTap: () {
                          setState(() {
                            selectedPaymentOption = 1;
                            btnColor =
                                Theme.of(context).colorScheme.primaryContainer;
                            txtPay = ZaloPayMessage.openApp;
                          });
                        },
                      ),

                      // Internet Banking
                      const SizedBox(height: 15),
                      RadioButtonCustom(
                        //bank icon
                        prefixWidget: Icon(
                          Icons.account_balance,
                          size: 25,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        contentWidget: Text(
                          'Internet Banking',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 17,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        isSelected: selectedPaymentOption == 2,
                        onTap: () {
                          setState(() {
                            selectedPaymentOption = 2;
                            btnColor = Theme.of(context).colorScheme.primary;
                            txtPay = LabelMessage.pay.toUpperCase();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 10),
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
                      btnPay(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: btnColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          txtPay,
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
    if (selectedPaymentOption == 1) {
      LoadingOverlayHelper.show(context);
      //open ZaloPay app
      openZaloPayApp(_package).then((_) {
        LoadingOverlayHelper.hide();
        showSnackBar(payResult, type: type);

        //redirect to home screen if payment success
        if (type == 1) {
          //close payment screen
          Navigator.of(context).pushReplacementNamed(HomeAppScreen.routeName);
        }
      });
    } else {
      //show snackbar if user select internet banking: development
      showSnackBar(ErrorMessage.underDevelopment);
    }
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
      ),
    );
  }
}
