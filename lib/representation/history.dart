import 'package:bai_system/core/helper/loading_overlay_helper.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../api/model/bai_model/api_response.dart';
import '../api/model/bai_model/feedback_model.dart';
import '../api/model/bai_model/history_model.dart';
import '../api/service/bai_be/feedback_service.dart';
import '../api/service/bai_be/history_service.dart';
import '../component/date_picker.dart';
import '../component/dialog.dart';
import '../component/empty_box.dart';
import '../component/loading_component.dart';
import '../component/response_handler.dart';
import '../component/shadow_container.dart';
import '../component/snackbar.dart';
import '../component/widget_to_image_template.dart';
import '../core/const/frontend/message.dart';
import '../core/const/utilities/util_helper.dart';
import '../core/helper/asset_helper.dart';
import '../core/helper/local_storage_helper.dart';
import '../representation/feedback.dart';
import 'login.dart';

class HistoryScreen extends StatefulWidget {
  static String routeName = '/history_screen';

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with ApiResponseHandler {
  final ScrollController _scrollController = ScrollController();
  late final WidgetsToImageController _controller;
  final LoadingOverlayHelper _loadingOverlayHelper = LoadingOverlayHelper();
  late final _currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
  late final int _pageSize = GetLocalHelper.getPageSize(_currentEmail);
  int pageIndex = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  DateTime? from;
  DateTime? to;
  bool isFilted = false;

  var log = Logger();
  CallHistoryAPI callHistoryAPI = CallHistoryAPI();
  bool isLoading = false;

  String _errorMessage = '';

  List<HistoryModel> histories = [];

  Future<String?> _catchError(APIResponse response) async {
    final String? errorMessage = await handleApiResponse(
      context: context,
      response: response,
    );

    if (errorMessage == ApiResponseHandler.invalidToken) {
      _goToPage(routeName: LoginScreen.routeName);
      showErrorSnackBar(ErrorMessage.tokenInvalid);
    }

    return errorMessage;
  }

  Future<void> getCustomerHistories(
      {bool isRefresh = false, DateTime? startDate, DateTime? endDate}) async {
    setState(() {
      isLoading = true;
    });

    if (isRefresh) {
      pageIndex = 1;
    }

    try {
      final APIResponse<List<HistoryModel>> result =
          await callHistoryAPI.getCustomerHistories(_pageSize, pageIndex,
              startDate: startDate, endDate: endDate);

      if (!mounted) return;

      final error = await _catchError(result);
      if (error != null) {
        if (error == ApiResponseHandler.invalidToken) {
          _goToPage(routeName: LoginScreen.routeName);
          showErrorSnackBar(ErrorMessage.tokenInvalid);
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        isLoading = false;
        histories = result.data ?? [];
        _hasNextPage = result.data!.length == _pageSize;
      });
      log.f('Histories: $histories', time: DateTime.now());
    } catch (e) {
      log.e('Error during get customer histories: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        _showErrorDialog('An error occurred while fetching histories.');
      }
    }
  }

  @override
  void initState() {
    _controller = WidgetsToImageController();
    super.initState();
    getCustomerHistories();
    _scrollController.addListener(_loadMore);
    isLoading = true;
    pageIndex = 1;
  }

  @override
  void dispose() {
    log.i('Dispose history screen');
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    _loadingOverlayHelper.dispose();
    super.dispose();
  }

  void _loadMore() async {
    if (_hasNextPage &&
        !_isLoadMoreRunning &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      try {
        if (!mounted) return;

        final result =
            await callHistoryAPI.getCustomerHistories(_pageSize, pageIndex + 1);

        final error = await _catchError(result);
        if (error != null) {
          if (error == ApiResponseHandler.invalidToken) {
            _goToPage(routeName: LoginScreen.routeName);
            showErrorSnackBar(ErrorMessage.tokenInvalid);
          }
          setState(() {
            _hasNextPage = false;
          });
          return;
        }

        if (result.data!.isNotEmpty && mounted) {
          setState(() {
            pageIndex += 1;
            histories.addAll(result.data!);
            _hasNextPage = result.data!.length == _pageSize;
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (e) {
        log.e('Error during get more histories: $e');
        if (mounted) {
          _showErrorDialog('Failed to load more histories. Please try again.');
        }
      } finally {
        setState(() {
          _isLoadMoreRunning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await getCustomerHistories(isRefresh: true);
        },
        child: Column(
          children: [
            _buildTotalHistoryContainer(context),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: LoadingCircle(),
                    )
                  : histories.isEmpty
                      ? EmptyBox(
                          message: EmptyBoxMessage.emptyList(
                              label: ListName.history),
                        )
                      : Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: histories.length + 1,
                            itemBuilder: (context, index) {
                              if (index < histories.length) {
                                final history = histories[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (!history.isFeedback) {
                                      addFeedbackDialog(history.id);
                                    } else {
                                      viewFeedbackDialog(
                                          history.title, history.description);
                                    }
                                  },
                                  child: historyCard(history),
                                );
                              } else if (_hasNextPage) {
                                return _isLoadMoreRunning
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: LoadingCircle(
                                              size: 30,
                                              isHeight: false,
                                            )),
                                      )
                                    : const SizedBox();
                              } else if (_hasNextPage == false) {
                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  child: Text(
                                    Message.noMore(message: ListName.history),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget historyCard(HistoryModel history, {double? horinzontal, margin}) =>
      Container(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: horinzontal ?? 40,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: margin ?? 10),
        child: Column(
          children: [
            Text(
              history.parkingArea,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: DottedLine(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                lineLength: double.infinity,
                lineThickness: 1.0,
                dashColor: Theme.of(context).colorScheme.outline,
              ),
            ),
            Text(
              UltilHelper.formatPlateNumber(history.plateNumber),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      historyInfo(
                        'Time in',
                        UltilHelper.formatDateTime(history.timeIn),
                        isTime: true,
                      ),
                      const SizedBox(height: 10),
                      historyInfo(
                        'Time out',
                        history.timeOut != null
                            ? UltilHelper.formatDateTime(history.timeOut!)
                            : "",
                        isTime: true,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      historyInfo(
                        'Gate in',
                        history.gateIn.toString(),
                      ),
                      const SizedBox(height: 10),
                      historyInfo(
                        'Gate out',
                        history.gateOut != null
                            ? history.gateOut.toString()
                            : "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: DottedLine(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                lineLength: double.infinity,
                lineThickness: 1.0,
                dashColor: Theme.of(context).colorScheme.outline,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _showImageDialog(_controller, history),
                  icon: const Icon(Icons.share_rounded),
                  color: Theme.of(context).colorScheme.outline,
                ),
                (!history.isFeedback && history.timeOut != null)
                    ? Icon(Icons.rate_review_outlined,
                        color: Theme.of(context).colorScheme.outline)
                    : Icon(Icons.rate_review_rounded,
                        color: Theme.of(context).colorScheme.outline),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        history.paymentMethod != null
                            ? history.paymentMethod.toString()
                            : "",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      history.amount != null
                          ? history.paymentMethod == 'CASH'
                              ? Text(
                                  '${UltilHelper.formatMoney(history.amount!)} VND',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AssetHelper.bic,
                                      width: 25,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${UltilHelper.formatMoney(history.amount!)} bic',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            fontSize: 14,
                                          ),
                                    )
                                  ],
                                )
                          : history.moneyEstimated != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Estimated: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                    ),
                                    const SizedBox(width: 5),
                                    Image.asset(
                                      AssetHelper.bic,
                                      width: 25,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${UltilHelper.formatMoney(history.moneyEstimated!)} bic',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );

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

  void _goToPage({String? routeName}) {
    routeName != null
        ? Navigator.of(context).pushNamed(routeName)
        : Navigator.of(context).pop();
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: MySnackBar(
          prefix: Icon(
            Icons.cancel_rounded,
            color: Theme.of(context).colorScheme.surface,
          ),
          message: message,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildTotalHistoryContainer(BuildContext context) {
    return ShadowContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 100,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total History',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${histories.length}',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _showFilterDialog(),
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  Visibility(
                    visible: isFilted,
                    child: GestureDetector(
                      onTap: () => _clearFilter(),
                      child: Text(
                        'Clear',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'Filter by period',
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DatePicker(
                    fromDate: from ??
                        DateTime.now().subtract(const Duration(days: 7)),
                    toDate: to ?? DateTime.now(),
                    onDateSelected: (startDate, endDate) {
                      setState(() {
                        if (startDate.isAfter(endDate)) {
                          _errorMessage = 'From date cannot be after to date!';
                        } else {
                          _errorMessage = '';
                          from = startDate;
                          to = endDate;
                        }
                      });
                    },
                  ),
                  Visibility(
                    visible: _errorMessage.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _errorMessage,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          onConfirm: () {
            if (_errorMessage.isEmpty) {
              Navigator.of(context).pop();
              setState(() {
                isFilted = true;
              });

              getCustomerHistories(
                  isRefresh: true, startDate: from, endDate: to);
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _clearFilter() {
    setState(() {
      from = null;
      to = null;
      isFilted = !isFilted;
    });
    getCustomerHistories(isRefresh: true);
  }

  //dialog add feedback
  void addFeedbackDialog(String sessionId) {
    final callFeedback = FeedbackApi();

    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    //send feedback to Bai Be
    Future<void> sendFeedback(SendFeedbackModel sendFeedbackModel) async {
      try {
        log.i('Sending feedback: $sendFeedbackModel');

        APIResponse response =
            await callFeedback.sendFeedback(sendFeedbackModel);

        if (!mounted) return;

        final error = await _catchError(response);
        if (error != null) {
          if (error == ApiResponseHandler.invalidToken) {
            _goToPage(routeName: LoginScreen.routeName);
            showErrorSnackBar(ErrorMessage.tokenInvalid);
          }
          return;
        }

        log.i('Feedback sent successfully');
      } catch (e) {
        log.e('Error during sending feedback: $e');
        showErrorSnackBar(ErrorMessage.somethingWentWrong);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: LabelMessage.add(message: ListName.feedback),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 25),
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.center,
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onConfirm: () async {
            _loadingOverlayHelper.show(context);

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
            _loadingOverlayHelper.hide();
            gotoScreen(routeName: FeedbackScreen.routeName);
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

  void viewFeedbackDialog(String? title, String? description) {
    showDialog(
      context: context,
      builder: (context) {
        return OKDialog(
          title: title ?? '',
          titleStyle: Theme.of(context).textTheme.titleMedium,
          content: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * 0.8,
                  minWidth: constraints.minWidth * 0.9,
                ),
                child: Text(
                  description ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                ),
              );
            },
          ),
        );
      },
    );
  }

  // goto feedback screen
  void gotoScreen({String? routeName}) {
    routeName != null
        ? Navigator.of(context).pushReplacementNamed(routeName)
        : Navigator.of(context).pop();
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
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: textField,
        )
      ],
    );
  }

  // dialog widget to preview image
  Widget toImageWidget(WidgetsToImageController controller,
      HistoryModel history, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: WidgetsToImage(
        controller: controller,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: Theme.of(context).colorScheme.surface,
          alignment: Alignment.center,
          child: WidgetToImageTemplate(
            child: historyCard(history, horinzontal: 20, margin: 0.0),
          ),
        ),
      ),
    );
  }

  void _showImageDialog(
      WidgetsToImageController controller, HistoryModel history) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: 'Share your history',
          content: toImageWidget(controller, history, context),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          positiveLabel: LabelMessage.share,
          onConfirm: () async {
            var image = await controller.capture();
            if (image != null) {
              XFile xImageFile = XFile.fromData(
                image,
                mimeType: 'image/png',
                name: 'History_${DateTime.now().millisecondsSinceEpoch}.png',
              );

              // Sử dụng share_plus để chia sẻ hình ảnh
              await Share.shareXFiles(
                [xImageFile],
                text: 'Check out my history!',
              );

              log.i('Share triggered');
            }
          },
          onCancel: () {
            log.i('Share canceled');
            Navigator.of(context).pop();
          },
        );
      },
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
          onClick: () {
            Navigator.of(context).pop();
            setState(() {
              isLoading = false;
            });
          },
        );
      },
    );
  }
}
