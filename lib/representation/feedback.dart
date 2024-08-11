import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/feedback_model.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/loading_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:logger/logger.dart';

import '../api/service/bai_be/feedback_service.dart';
import '../component/return_login_component.dart';
import '../core/const/frondend/message.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  static String routeName = '/feedback_screen';

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final callFeedbackApi = FeedbackApi();
  bool isLoading = false;
  List<FeedbackModel> feedbacks = [];

  var log = Logger();

  @override
  void initState() {
    super.initState();
    getFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Feedback',
      ),
      body: SingleChildScrollView(
        child: Align(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: isLoading
                ? const Center(
                    child: LoadingCircle(),
                  )
                : RefreshIndicator(
                    onRefresh: getFeedbacks,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: feedbacks.length,
                        itemBuilder: (context, index) {
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
                                  Text(
                                    feedback.description,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> getFeedbacks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await callFeedbackApi.getFeedbacks();
      if (response.isTokenValid) {
        if (response.data != null) {
          setState(() {
            feedbacks = response.data!;
          });
        }
      } else if (response.message == ErrorMessage.tokenInvalid &&
          !response.isTokenValid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show error dialog
        returnLoginDialog();
        return;
      } else {
        log.e('Failed to get feedbacks: ${response.message}');
      }
    } catch (e) {
      // Handle error
      log.e('Error during get feedbacks: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //return login dialog
  void returnLoginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const InvalidTokenDialog();
      },
    );
  }
}
