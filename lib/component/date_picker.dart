import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../core/const/utilities/util_helper.dart';

class DatePicker extends StatefulWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final Function(DateTime, DateTime) onDateSelected;

  const DatePicker({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onDateSelected,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime fromDate = widget.fromDate;
  late DateTime toDate = widget.toDate;
  bool isSelectingFromDate = true;

  void _updateDate() {
    log.d('From date: $fromDate, To date: $toDate');
    widget.onDateSelected(fromDate, toDate);
  }

  var log = Logger();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelectingFromDate = true;
                    _selectDate(context, true);
                  });
                },
                child: datePickerWidget(
                  'From date',
                  fromDate,
                  isSelected: isSelectingFromDate,
                ),
              ),
              // divider
              Container(
                width: 1,
                height: MediaQuery.of(context).size.height * 0.03,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelectingFromDate = false;
                    _selectDate(context, false);
                  });
                },
                child: datePickerWidget(
                  'To date',
                  toDate,
                  isSelected: !isSelectingFromDate,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            margin: const EdgeInsets.only(top: 5),
            child: Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              thickness: 1,
            ),
          ),
          // ListTile(
          //   title: const Text(
          //     'The date range you want to view, maximum 30 days.',
          //     textAlign: TextAlign.center,
          //   ),
          //   horizontalTitleGap: 5,
          //   titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //         color: Theme.of(context).colorScheme.onSecondary,
          //         fontSize: 12,
          //       ),
          //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          //   minVerticalPadding: 0,
          // )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime now = DateTime.now();
    DateTime initialDate = isFromDate ? fromDate : toDate;
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = now;

    if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: DatePickerMode.day,
      keyboardType: TextInputType.datetime,
      fieldLabelText: 'Select ${isFromDate ? 'from' : 'to'} date',
      currentDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.secondary,
              secondary: Theme.of(context).colorScheme.outlineVariant,
              onSecondary: Theme.of(context).colorScheme.outlineVariant,
              surfaceTint: Theme.of(context).colorScheme.surface,
            ),
            textTheme: Theme.of(context).textTheme,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Theme.of(context).colorScheme.primary,
              selectionColor: Theme.of(context).colorScheme.primary,
              selectionHandleColor: Theme.of(context).colorScheme.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: Builder(
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 500,
                  ),
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });

      _updateDate();
    }
  }

  // Date picker Widget
  Widget datePickerWidget(String title, DateTime date,
      {required bool isSelected}) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month_rounded,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSecondary,
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 11,
                  ),
            ),
            Text(
              UltilHelper.formatDateMMMddyyyy(date),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
            ),
          ],
        )
      ],
    );
  }
}
