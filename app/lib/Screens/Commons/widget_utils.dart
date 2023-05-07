import 'package:flutter/material.dart';

typedef OnDOBChange = Function(DateTime datetime);
typedef OnSearch = Function();
class WidgetUtils{

  static MaterialColor appColors = const MaterialColor(
    0xfff11347,
    <int, Color>{
      50: Color(0xffFCE2E6),
      100: Color(0xffF9BFC7),
      200: Color(0xffF48DA0),
      300: Color(0xffF05B7A),
      400: Color(0xffEC345D),
      500: Color(0xfff11347),
      600: Color(0xffC90E3A),
      700: Color(0xff9C0A2D),
      800: Color(0xff6E0720),
      900: Color(0xff400314),
    },
  );

  static InputDecoration inputDecoration(String name) => InputDecoration(
    hintText: name,
    labelText: name,
    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  static InputDecoration searchInputDecoration(String name,OnSearch search) => InputDecoration(
    hintText: name,
    labelText: name,
    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    suffixIcon: IconButton(
      icon: const Icon(Icons.search),
      onPressed: search,
    ),
  );

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

  ///cancel elevated button decoration
  static ButtonStyle? cancelButtonStyle()=>ElevatedButton.styleFrom(
    elevation: 1,
    backgroundColor: Colors.black12
  );


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