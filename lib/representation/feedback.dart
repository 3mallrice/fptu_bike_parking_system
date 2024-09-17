import 'package:bai_system/api/model/bai_model/feedback_model.dart';
import 'package:bai_system/api/service/bai_be/feedback_service.dart';
import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/dialog.dart';
import 'package:bai_system/component/empty_box.dart';
import 'package:bai_system/component/loading_component.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../core/helper/local_storage_helper.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  static const String routeName = '/feedback_screen';

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with ApiResponseHandler {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late int _pageSize = 10;
  int _pageIndex = 1;
  bool _hasNextPage = true;
  bool _isLoading = true;

  final FeedbackApi _feedbackApi = FeedbackApi();
  final List<FeedbackModel> _feedbacks = [];
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _pageSize = GetLocalHelper.getPageSize();
    _getFeedbacks();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _getFeedbacks({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _pageIndex = 1;
        _feedbacks.clear();
      }

      final response = await _feedbackApi.getFeedbacks(_pageIndex, _pageSize);
      if (!mounted) return;

      final bool isResponseValid = await handleApiResponse(
        context: context,
        response: response,
        showErrorDialog: _showErrorDialog,
      );

      if (!isResponseValid) {
        _refreshController.refreshFailed();
        _refreshController.loadFailed();
        return;
      }

      setState(() {
        _feedbacks.addAll(response.data ?? []);
        _hasNextPage = (response.data?.length ?? 0) == _pageSize;
        _isLoading = false;
      });
      _logger.i('Total feedbacks: ${response.totalRecord}');

      if (isRefresh) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
    } catch (e) {
      _logger.e('Error during get feedbacks: $e');
      _showErrorDialog(ErrorMessage.somethingWentWrong);
      setState(() => _isLoading = false);
      _refreshController.refreshFailed();
      _refreshController.loadFailed();
    }
  }

  void _onRefresh() async {
    await _getFeedbacks(isRefresh: true);
  }

  void _onLoading() async {
    if (_hasNextPage) {
      _pageIndex += 1;
      await _getFeedbacks();
    } else {
      _refreshController.loadNoData();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: ErrorMessage.error,
          content: Text(message, style: Theme.of(context).textTheme.bodySmall),
        );
      },
    );
  }

  Widget _buildFeedbackItem(FeedbackModel feedback) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ShadowContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              feedback.title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            _buildInfoRow(
                Icons.local_parking_rounded, feedback.parkingAreaName),
            _buildInfoRow(Icons.calendar_month_rounded,
                UltilHelper.formatDateMMMddyyyy(feedback.createdDate)),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                feedback.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onSecondary),
        const SizedBox(width: 10),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        automaticallyImplyLeading: true,
        title: 'Feedback',
      ),
      body: _isLoading
          ? const Center(child: LoadingCircle())
          : _feedbacks.isEmpty
              ? EmptyBox(
                  message: EmptyBoxMessage.emptyList(label: ListName.feedback))
              : SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: const ClassicHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle && !_hasNextPage) {
                        body = const Text("Pull up to load");
                      } else if (mode == LoadStatus.loading) {
                        body = const LoadingCircle(size: 30, isHeight: false);
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("Load Failed! Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = const Text("Release to load more");
                      } else {
                        body = const Text("No more Data");
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _feedbacks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _buildFeedbackItem(_feedbacks[index]);
                    },
                  ),
                ),
    );
  }
}
