import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/app_bar_component.dart';

class AddFeedbackScreen extends StatefulWidget {
  const AddFeedbackScreen({super.key});

  static String routeName = '/add_feedback_screen';

  @override
  State<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarCom(
          leading: true,
          appBarText: 'Add Feedback',
        ),
        body: SingleChildScrollView(
          child: Align(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            ),
          ),
        ));
  }
}
