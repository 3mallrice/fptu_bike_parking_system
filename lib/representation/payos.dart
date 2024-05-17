import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';

class PayOsScreen extends StatefulWidget {
  const PayOsScreen({super.key});

  static String routeName = '/payos_screen';

  @override
  State<PayOsScreen> createState() => _PayOsScreenState();
}

class _PayOsScreenState extends State<PayOsScreen> {
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
                        padding: const EdgeInsets.all(20),
                        color: Theme.of(context).colorScheme.secondary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage(AssetHelper.bic),
                              fit: BoxFit.fitWidth,
                              width: 35,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '45.000',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(50),
                        child: PrettyQrView.data(
                          data: 'lorem ipsum dolor sit amet',
                          decoration: const PrettyQrDecoration(
                            image: PrettyQrDecorationImage(
                              image: AssetImage(AssetHelper.imgLogo),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        margin: const EdgeInsets.only(bottom: 30),
                        child: Text.rich(
                          TextSpan(
                            text: 'Open any banking app to ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'scan this VietQR code ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'or to ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text:
                                    'accurately transfer the following content.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
