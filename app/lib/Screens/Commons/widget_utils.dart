import 'package:flutter/material.dart';

typedef OnDOBChange = Function(DateTime datetime);

class WidgetUtils{

  static InputDecoration dobDecoration(
      context, title, initialDate, OnDOBChange onDOBChange, [DateTime? maxDateTime,DateTime? minDateTime]) {
    return InputDecoration(
      hintText: "$title",
      contentPadding: const EdgeInsets.all(8),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      suffixIcon: IconButton(
          onPressed: () async {
            DateTime? date =
            await _selectDate(context, initialDate is DateTime ? initialDate : DateTime.parse(initialDate),maxDateTime,minDateTime);
            if (date != null) {
              onDOBChange(date);
            }
          },
          icon: const Icon(Icons.calendar_month_outlined)),
    );
  }

  static Future<DateTime?> _selectDate(context, DateTime? initialDate, [DateTime? maxDate, DateTime? minDate]) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: minDate??DateTime(1900),
      lastDate: maxDate??DateTime.now(),
    );
    return date;
  }
}