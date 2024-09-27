import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/core/helper/asset_helper.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              children: [
                // Header row
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: transaction.id));
                    setState(() {
                      isCopied = true;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage(AssetHelper.baiLogo),
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Session ID: ${isCopied ? 'Copied' : 'Copy'}',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Status header
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                statusIcon,
                                color: Theme.of(context).colorScheme.surface,
                                size: 13,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                statusText ?? "N/A",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
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
                        // Transaction details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Transaction Details',
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
                                  UltilHelper.formatDateTime(transaction.date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                ),
                                const SizedBox(height: 15),
                                // Amount display
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      transaction.type == 'IN'
                                          ? '+ ${UltilHelper.formatMoney(transaction.amount)}'
                                          : '- ${UltilHelper.formatMoney(transaction.amount)}',
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
                                      'bic',
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
                                // Dotted line
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 0.5,
                                    dashColor:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                // Transaction details table
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow(
                                        'Type',
                                        transaction.type == 'IN'
                                            ? 'Deposit'
                                            : 'Parking Fee'),
                                    _buildInfoRow('Message',
                                        transaction.description ?? "N/A"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80, // Fixed width for labels
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ),
      ],
    );
  }
}
