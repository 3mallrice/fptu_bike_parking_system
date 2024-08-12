import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/history_model.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/feedback_service.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/history_service.dart';
import 'package:fptu_bike_parking_system/component/dialog.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:fptu_bike_parking_system/representation/feedback.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/feedback_model.dart';
import '../component/empty_box.dart';
import '../component/loading_component.dart';
import '../component/shadow_container.dart';
import '../core/const/frondend/message.dart';
import '../core/helper/return_login_dialog.dart';

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
  // APIResponse apiResponse = APIResponse();

  List<HistoryModel> histories = [];

  Future<void> getCustomerHistories() async {
    try {
      final APIResponse<List<HistoryModel>> result =
          await callHistoryAPI.getCustomerHistories();

      if (result.isTokenValid == false &&
          result.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show login dialog
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      if (mounted) {
        setState(() {
          if (result.data != null) {
            histories = result.data ?? [];
          } else {
            log.e('Failed to get customer histories: ${result.message}');
          }
        });
      }
    } catch (e) {
      log.e('Error during get customer histories: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
      body: RefreshIndicator(
        onRefresh: () async {
          await getCustomerHistories();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    //History list
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: isLoading
                          ? const LoadingCircle()
                          : (histories.isEmpty)
                              ? EmptyBox(
                                  message: EmptyBoxMessage.emptyList(
                                      label: ListName.history))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: histories.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final history = histories[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!history.isFeedback) {
                                            addFeedbackDialog(history.id);
                                          } else {
                                            log.i('Feedback already added');
                                          }
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
                                                history.parkingArea,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: DottedLine(
                                                  direction: Axis.horizontal,
                                                  alignment:
                                                      WrapAlignment.center,
                                                  lineLength: double.infinity,
                                                  lineThickness: 1.0,
                                                  dashColor: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                ),
                                              ),
                                              Text(
                                                history.plateNumber,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        historyInfo(
                                                          'Time in',
                                                          UltilHelper
                                                              .formatDateTime(
                                                                  history
                                                                      .timeIn),
                                                          isTime: true,
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        historyInfo(
                                                          'Time out',
                                                          history.timeOut !=
                                                                  null
                                                              ? UltilHelper
                                                                  .formatDateTime(
                                                                      history
                                                                          .timeOut!)
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
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        historyInfo(
                                                          'Gate in',
                                                          history.gateIn
                                                              .toString(),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        historyInfo(
                                                          'Gate out',
                                                          history.gateOut !=
                                                                  null
                                                              ? history.gateOut
                                                                  .toString()
                                                              : "",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: DottedLine(
                                                  direction: Axis.horizontal,
                                                  alignment:
                                                      WrapAlignment.center,
                                                  lineLength: double.infinity,
                                                  lineThickness: 1.0,
                                                  dashColor: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                  (!history.isFeedback)
                                                      ? Icon(
                                                          Icons
                                                              .rate_review_rounded,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline)
                                                      : const SizedBox(),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          history.paymentMethod !=
                                                                  null
                                                              ? history
                                                                  .paymentMethod
                                                                  .toString()
                                                              : "",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .outline,
                                                                  ),
                                                        ),
                                                        history.amount != null
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    AssetHelper
                                                                        .bic,
                                                                    width: 25,
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  Text(
                                                                    history.amount !=
                                                                            null
                                                                        ? '${UltilHelper.formatMoney(history.amount!)} bic'
                                                                        : '',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displayMedium,
                                                                  )
                                                                ],
                                                              )
                                                            : Text(
                                                                history.status,
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

  //dialog add feedback
  void addFeedbackDialog(String sessionId) {
    final callFeedback = FeedbackApi();

    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    //send feedback to Bai Be
    Future<void> sendFeedback(SendFeedbackModel sendFeedbackModel) async {
      try {
        log.i('Send feedback: $sendFeedbackModel');
        callFeedback.sendFeedback(sendFeedbackModel);
      } catch (e) {
        log.e('Error during send feedback: $e');
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: 'Add feedback',
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.only(top: 25),
                    width: MediaQuery.of(context).size.width * 0.9,
                    // height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        feedbackItem(
                          'Title',
                          TextField(
                            controller: titleController,
                            maxLength: 50,
                            maxLengthEnforcement: MaxLengthEnforcement.none,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your title here',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        feedbackItem(
                          'Description',
                          TextField(
                            keyboardType: TextInputType.multiline,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                            maxLines: 6,
                            minLines: 6,
                            maxLength: 100,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your feedback here',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
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
          onConfirm: () async {
            log.i('Feedback submitted');

            if (titleController.text.trim().isEmpty ||
                descriptionController.text.trim().isEmpty) {
              log.e('Title or description is empty');
              return;
            }

            await sendFeedback(SendFeedbackModel(
              title: titleController.text.trim(),
              description: descriptionController.text.trim(),
              sessionId: sessionId,
            ));

            //refresh history list
            await getCustomerHistories();

            //close dialog
            gotoFeedbackScreen();
          },
          onCancel: () {
            log.i('Feedback canceled');
            Navigator.of(context).pop();
          },
          positiveLabel: 'Submit',
        );
      },
    );
  }

  // goto feedback screen
  void gotoFeedbackScreen() {
    Navigator.of(context).pushReplacementNamed(FeedbackScreen.routeName);
  }

  // feedback item
  Widget feedbackItem(String label, Widget textField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: textField,
        )
      ],
    );
  }
}
