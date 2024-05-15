import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/representation/add_feedback.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  static String routeName = '/feedback_screen';

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Feedback List
  List<Feedback> feedbacks = [
    Feedback(
      feedbackId: '1',
      feedbackTitle: 'Increased Utilization at Central Plaza Parking Lot',
      parkingArea: 'FPTU',
      date: DateTime.now(),
      feedbackText:
          'We have observed a significant increase in the utilization of the Central Plaza Parking Lot over the past month. This trend indicates a growing demand for bike parking facilities in this area',
    ),
    Feedback(
      feedbackId: '2',
      feedbackTitle: 'Customer Preference for Green Park Bike Station',
      parkingArea: 'FPTU',
      date: DateTime.now(),
      feedbackText:
          'Our data analysis reveals a notable preference among customers for the Green Park Bike Station. With its convenient location and secure facilities, it continues to be a top choice for cyclists in the area.',
    ),
    Feedback(
      feedbackId: '3',
      feedbackTitle: 'Promoting Usage Diversity at Riverside Bike Dock',
      parkingArea: 'FPTU',
      date: DateTime.now(),
      feedbackText:
          'We have implementing strategies to encourage diverse usage patterns at the Riverside Bike Dock. By offering incentives and promotions, we aim to attract a broader range of users to this facility.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCom(
        leading: true,
        appBarText: 'Feedback',
        action: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddFeedbackScreen.routeName),
              icon: Icon(
                Icons.post_add_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              iconSize: 21,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: feedbacks.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ShadowContainer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            feedbacks[index].feedbackTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_parking_rounded,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                feedbacks[index].parkingArea,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat('MMMM dd, yyyy')
                                    .format(feedbacks[index].date),
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                          Text(
                            feedbacks[index].feedbackText!,
                            style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}

class Feedback {
  String feedbackId;
  String feedbackTitle;
  String parkingArea;
  DateTime date;
  String? feedbackText;

  Feedback({
    required this.feedbackId,
    required this.feedbackTitle,
    required this.parkingArea,
    required this.date,
    this.feedbackText,
  });
}
