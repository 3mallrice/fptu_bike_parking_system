import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/wallet_model.dart';

class ReceiptScreen extends StatefulWidget {
  final WalletModel transaction;
  const ReceiptScreen({
    super.key,
    required this.transaction,
  });

  static const String routeName = '/receipt_screen';

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  late WalletModel transaction = widget.transaction;
  late String status = transaction.status;
  Color? statusColor;
  String? statusText;
  IconData? statusIcon;

  bool isCopied = false;

  var log = Logger();

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case "PENDING":
        statusColor = Theme.of(context).colorScheme.error;
        statusText = "Fail transaction";
        statusIcon = Icons.pending;
        break;
      case "SUCCEED":
        statusColor = Theme.of(context).colorScheme.onError;
        statusText = "Successful transaction";
        statusIcon = Icons.check_circle;
        break;
      case "FAILED":
        statusColor = Theme.of(context).colorScheme.error;
        statusText = "Fail transaction";
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Theme.of(context).colorScheme.outline;
        statusText = "Pending transaction";
        statusIcon = Icons.cancel;
        break;
    }

    return Scaffold(
      body: Column(
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
              GestureDetector(
                onTap: () {
                  //save to clipboard
                  Clipboard.setData(
                    ClipboardData(text: transaction.id),
                  );

                  setState(() {
                    isCopied = true;
                  });
                },
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    'ID: ${isCopied ? 'Copied' : 'Copy'}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
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
                    color: statusColor,
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
                        statusIcon,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        statusText ?? "N/A",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.background,
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
                        'Transaction Details',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        UltilHelper.formatDateTime(transaction.date),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            // if transactionType == 'IN' then '+' else '-' before amount
                            transaction.type == 'IN'
                                ? '+ ${UltilHelper.formatMoney(transaction.amount)}'
                                : '- ${UltilHelper.formatMoney(transaction.amount)}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'bic',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          lineLength: double.infinity,
                          lineThickness: 1.0,
                          dashColor: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Table(
                          columnWidths: const {
                            0: FractionColumnWidth(0.25)
                            // Cột đầu tiên
                          },
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  'Type',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  transaction.type == 'IN'
                                      ? 'Deposit'
                                      : 'Parking Fee',
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
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  transaction.description ?? "N/A",
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
        ],
      ),
    );
  }
}
