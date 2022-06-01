import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:flutter/material.dart';


Future<DateTime?> pickDate(context) async {
  final pickedDate = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.white,
            onPrimary: primaryColor,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      );
    },
    lastDate: DateTime(DateTime.now().year + 5),
    initialDate: DateTime.now(),
  );

  return pickedDate;
}

Future<TimeOfDay?> pickTime(context) async {
  final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
  );
  return pickedTime;
}

Future<DateTime> pickDateTime(context) async {
  final pickedDate = await pickDate(context);

  if (pickedDate == null) {
    return DateTime.now();
  }

  final pickedTime = await pickTime(context);

  if (pickedTime == null) {
    return DateTime.now();
  }

  DateTime dateTime = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );

  return dateTime;
}