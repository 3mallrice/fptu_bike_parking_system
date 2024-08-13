import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/feedback_model.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/empty_box.dart';
import 'package:fptu_bike_parking_system/component/loading_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:logger/logger.dart';

import '../api/service/bai_be/feedback_service.dart';
import '../core/const/frondend/message.dart';
import '../core/helper/return_login_dialog.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  static String routeName = '/feedback_screen';

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  //pagination
  ScrollController _scrollController = ScrollController();
  int pageSize = 10;
  int pageIndex = 1;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  final callFeedbackApi = FeedbackApi();
  bool isLoading = false;
  List<FeedbackModel> feedbacks = [];

  var log = Logger();

  @override
  void initState() {
    super.initState();
    getFeedbacks();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Feedback',
      ),
      body: _isFirstLoadRunning
          ? const Center(child: LoadingCircle())
          : RefreshIndicator(
              onRefresh: getFeedbacks,
              child: feedbacks.isEmpty
                  ? EmptyBox(
                      message:
                          EmptyBoxMessage.emptyList(label: ListName.feedback))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      controller: _scrollController,
                      itemCount: feedbacks.length + 1,
                      itemBuilder: (context, index) {
                        if (index < feedbacks.length) {
                          final feedback = feedbacks[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ShadowContainer(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    feedback.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.local_parking_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        feedback.parkingAreaName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_month_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        UltilHelper.formatDateMMMddyyyy(
                                            feedback.createdDate),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Text(
                                      feedback.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (_hasNextPage) {
                          return _isLoadMoreRunning
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: LoadingCircle(
                                        size: 30,
                                      )),
                                )
                              : const SizedBox();
                        } else if (_hasNextPage == false) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                child: Text(
                                  'No more feedbacks',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
            ),
    );
  }

  Future<void> getFeedbacks() async {
    setState(() {
      _isFirstLoadRunning = true;
      pageIndex = 1; // Reset page index when refreshing
    });
    try {
      final response = await callFeedbackApi.getFeedbacks(pageIndex, pageSize);
      if (response.isTokenValid) {
        if (response.data != null) {
          setState(() {
            feedbacks = response.data!;
            _hasNextPage = response.data!.length == pageSize;
            log.e('total: ${response.totalRecord}');
          });
        }
      } else if (response.message == ErrorMessage.tokenInvalid &&
          !response.isTokenValid) {
        log.e('Token is invalid');
        if (!mounted) return;
        ReturnLoginDialog.returnLogin(context);
        return;
      } else {
        log.e('Failed to get feedbacks: ${response.message}');
      }
    } catch (e) {
      log.e('Error during get feedbacks: $e');
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      pageIndex += 1;
      try {
        final res = await callFeedbackApi.getFeedbacks(pageIndex, pageSize);
        if (res.data != null && res.data!.isNotEmpty) {
          setState(() {
            feedbacks.addAll(res.data!);
            _hasNextPage = res.data!.length == pageSize;
            log.e('total: ${res.totalRecord}');
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (e) {
        log.e('Error during get more feedbacks: $e');
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }
}
