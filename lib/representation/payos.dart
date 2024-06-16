import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/dialog.dart';
import 'package:fptu_bike_parking_system/component/shadow_button.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/component/snackbar.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:fptu_bike_parking_system/core/helper/save_image.dart';
import 'package:fptu_bike_parking_system/representation/receipt.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../component/widget_to_image_template.dart';
import '../core/const/frondend/message.dart';

class PayOsScreen extends StatefulWidget {
  const PayOsScreen({super.key});

  static String routeName = '/payos_screen';

  @override
  State<PayOsScreen> createState() => _PayOsScreenState();
}

class _PayOsScreenState extends State<PayOsScreen> {
  late int selectedPage;
  late final PageController _pageController;

  final int save = 1;
  final int share = 2;

  late final WidgetsToImageController _controller;
  Uint8List? image;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
    _controller = WidgetsToImageController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Payment',
      ),
      body: SingleChildScrollView(
        child: Align(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShadowContainer(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          '45.000',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 45,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.7,
                              child: Center(
                                child: PageView(
                                  controller: _pageController,
                                  onPageChanged: (page) {
                                    setState(() {
                                      selectedPage = page;
                                    });
                                  },
                                  children: [
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(22),
                                        child: PrettyQrView.data(
                                          data: 'lorem ipsum dolor sit amet',
                                          decoration: const PrettyQrDecoration(
                                            image: PrettyQrDecorationImage(
                                              image: AssetImage(
                                                  AssetHelper.imgLogo),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // banking transfer information: Account number, amount, Message
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: const Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  FieldTransferInfo(
                                                    text: "ABC123456789",
                                                    // addPaymentResponse!.accountNumber,
                                                    label: "Account Number",
                                                  ),
                                                  FieldTransferInfo(
                                                    text: "45.000 vnd",
                                                    // addPaymentResponse!.amount,
                                                    label: "Amount",
                                                  ),
                                                  FieldTransferInfo(
                                                    text: "ABCDEF BUI HUU PHUC",
                                                    // addPaymentResponse!.message,
                                                    label: "Message",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Remember to accurately input 45.000 vnd',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondary,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width * 0.75,
                        margin: const EdgeInsets.only(bottom: 30),
                        child: Text.rich(
                          TextSpan(
                            text: 'Open any banking app to ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                            children: [
                              TextSpan(
                                text: 'scan this VietQR code ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              TextSpan(
                                text: 'or to ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                              ),
                              TextSpan(
                                text: 'accurately transfer',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              TextSpan(
                                text: ' the following content.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              dotIndicator(selectedPage),
                              const SizedBox(
                                width: 10,
                              ),
                              dotIndicator(selectedPage == 0 ? 1 : 0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Save and Share
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      button(() => _showImageDialog(_controller, save),
                          Icons.save_alt_rounded),
                      button(() {
                        //TODO
                      }, Icons.share_rounded)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_circle,
                      color: Theme.of(context).colorScheme.outline,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Service is provided by PayOS',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReceiptScreen.routeName),
                  child: const ShadowButton(
                    buttonTitle: 'CONFIRM',
                    margin: EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget button(void Function()? onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.background,
          size: 30,
        ),
      ),
    );
  }

  Widget dotIndicator(int selectedPage) {
    return Container(
      width: selectedPage == 0 ? 15 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: selectedPage == 0
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
        borderRadius: selectedPage == 0
            ? BorderRadius.circular(10)
            : BorderRadius.circular(10),
      ),
    );
  }

  // save image dialog to preview image
  void _showImageDialog(WidgetsToImageController controller, int action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color backgroundColor = Theme.of(context).colorScheme.background;
        Color onSuccessful = Theme.of(context).colorScheme.onError;
        Color onUnsuccessful = Theme.of(context).colorScheme.error;

        return ConfirmDialog(
          title: "Preview",
          content: toImageWidget(controller, context),
          onConfirm: () async {
            var image = await controller.capture();
            await saveImage(ImageName.imageName(prefix: "BankingInfo"), image)
                ? showCustomSnackBar(MySnackBar(
                    prefix: Icon(
                      Icons.check_circle_rounded,
                      color: backgroundColor,
                    ),
                    message: Message.saveImageSuccessfully,
                    backgroundColor: onSuccessful,
                  ))
                : showCustomSnackBar(
                    MySnackBar(
                      prefix: Icon(
                        Icons.cancel_rounded,
                        color: backgroundColor,
                      ),
                      message: Message.saveImageUnSuccessfully,
                      backgroundColor: onUnsuccessful,
                    ),
                  );
            backToPage();
          },
          onCancel: () => backToPage(),
        );
      },
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

  // dialog widget to preview image
  Column toImageWidget(
      WidgetsToImageController controller, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WidgetsToImage(
          controller: controller,
          child: WidgetToImageTemplate(
            widget: Center(
              child: Container(
                padding: const EdgeInsets.all(22),
                child: PrettyQrView.data(
                  data: 'lorem ipsum dolor sit amet',
                  decoration: const PrettyQrDecoration(
                    image: PrettyQrDecorationImage(
                      image: AssetImage(AssetHelper.imgLogo),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // banking information
  Widget bankingInfo(String text, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
        ),
        const SizedBox(height: 4),
        // ignore: unnecessary_string_interpolations
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }

  // back to previous page
  void backToPage({String? routeName}) => routeName != null
      ? Navigator.of(context).pop(routeName)
      : Navigator.of(context).pop();
}

class FieldTransferInfo extends StatefulWidget {
  const FieldTransferInfo({
    super.key,
    required this.label,
    required this.text,
  });

  final String label;
  final String text;

  @override
  State<StatefulWidget> createState() {
    return _FieldTransferInfo();
  }
}

class _FieldTransferInfo extends State<FieldTransferInfo> {
  var isClick = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color.fromARGB(255, 168, 161, 161), width: 0.5))),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                // ignore: unnecessary_string_interpolations
                Text(
                  widget.text,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                setState(() => isClick = true);
                await Clipboard.setData(ClipboardData(text: widget.text));
                await Future.delayed(const Duration(seconds: 2));
                setState(() => isClick = false);
              },
              icon: isClick
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Icon(
                      Icons.copy,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
