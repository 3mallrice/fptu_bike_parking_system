import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/history_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/history_service.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:fptu_bike_parking_system/core/helper/util_helper.dart';
import 'package:fptu_bike_parking_system/representation/add_feedback.dart';
import 'package:logger/logger.dart';

import '../component/empty_box.dart';
import '../component/shadow_container.dart';
import '../core/const/frondend/message.dart';

class HistoryScreen extends StatefulWidget {
  static String routeName = '/history_screen';

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var log = Logger();
  CallHistoryAPI callHistoryAPI = CallHistoryAPI();
  bool isLoading = true;
  APIResponse apiResponse = APIResponse();

  Future<void> getCustomerHistories() async {
    try {
      final APIResponse<List<HistoryModel>?>? result =
          await callHistoryAPI.getCustomerHistories();
      setState(() {
        if (result != null && result.data != null) {
          apiResponse = result;
        } else {
          log.e('Failed to get customer histories: ${result?.message}');
        }
      });
    } catch (e) {
      log.e('Error during get customer histories: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCustomerHistories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                //History list
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: (isLoading)
                      ? const Center(child: CircularProgressIndicator())
                      : (apiResponse.data == null || apiResponse.data.isEmpty)
                          ? EmptyBox(message: StaticMessage.emptyHistory)
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: apiResponse.data.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        AddFeedbackScreen.routeName,
                                        arguments: apiResponse.data[index].id,
                                      );
                                    },
                                    child: ShadowContainer(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 40,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            apiResponse.data[index].parkingArea,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: DottedLine(
                                              direction: Axis.horizontal,
                                              alignment: WrapAlignment.center,
                                              lineLength: double.infinity,
                                              lineThickness: 1.0,
                                              dashColor: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ),
                                          Text(
                                            apiResponse.data[index].plateNumber,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    historyInfo(
                                                      'Time in',
                                                      UltilHelper
                                                          .formatDateTime(
                                                              apiResponse
                                                                  .data[index]
                                                                  .timeIn),
                                                      isTime: true,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    historyInfo(
                                                      'Time out',
                                                      apiResponse.data[index]
                                                                  .timeOut !=
                                                              null
                                                          ? UltilHelper
                                                              .formatDateTime(
                                                                  apiResponse
                                                                      .data[
                                                                          index]
                                                                      .timeOut)
                                                          : "",
                                                      isTime: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    historyInfo(
                                                      'Gate in',
                                                      apiResponse
                                                          .data[index].gateIn
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    historyInfo(
                                                      'Gate out',
                                                      apiResponse.data[index]
                                                                  .gateOut !=
                                                              null
                                                          ? apiResponse
                                                              .data[index]
                                                              .gateOut
                                                              .toString()
                                                          : "",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: DottedLine(
                                              direction: Axis.horizontal,
                                              alignment: WrapAlignment.center,
                                              lineLength: double.infinity,
                                              lineThickness: 1.0,
                                              dashColor: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  //TODO: Share
                                                },
                                                icon: const Icon(
                                                    Icons.share_rounded),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      apiResponse.data[index]
                                                                  .paymentMethod !=
                                                              null
                                                          ? apiResponse
                                                              .data[index]
                                                              .paymentMethod
                                                              .toString()
                                                          : "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outline,
                                                          ),
                                                    ),
                                                    apiResponse.data[index]
                                                                .amount !=
                                                            null
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                AssetHelper.bic,
                                                                width: 25,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                '${UltilHelper.formatNumber(apiResponse.data[index].amount)} bic',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayMedium,
                                                              )
                                                            ],
                                                          )
                                                        : Text(
                                                            apiResponse
                                                                .data[index]
                                                                .status,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium,
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget historyInfo(String title, String value, {bool isTime = false}) {
    return Column(
      crossAxisAlignment:
          !isTime ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 14,
              ),
          textAlign: TextAlign.end,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}
