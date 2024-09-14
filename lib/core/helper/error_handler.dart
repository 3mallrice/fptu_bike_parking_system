import 'package:bai_system/core/const/frontend/message.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  bool _isShowingError = false;

  Future<void> handleError(BuildContext context, String errorMessage) async {
    if (!_isShowingError) {
      _isShowingError = true;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              GestureDetector(
                child: Text(LabelMessage.close),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      _isShowingError = false;
    }
  }

  Future<void> handleMultipleErrors(
      BuildContext context, List<String> errorMessages) async {
    if (!_isShowingError) {
      _isShowingError = true;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Errors Occurred'),
            content: SingleChildScrollView(
              child: ListBody(
                children:
                    errorMessages.map((error) => Text('- $error')).toList(),
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                child: Text(LabelMessage.close),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      _isShowingError = false;
    }
  }
}
