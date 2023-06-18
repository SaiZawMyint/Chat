import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnDOBChange = Function(DateTime datetime);
typedef OnSearch = Function();
typedef OnScrollChange = Function(ScrollOptions direction);

class WidgetUtils {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xff1976d2),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: WidgetUtils.appColors),
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(
        color: WidgetUtils.appColors,
      ),
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: WidgetUtils.appColors,
        fontSize: 18,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xffbb86fc),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: WidgetUtils.appColors).copyWith(
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(
        color: WidgetUtils.appColors,
      ),
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: WidgetUtils.appColors,
        fontSize: 18,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      outlineBorder: const BorderSide(
        color: Colors.white,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.white,
        ),
      ),
    ),
  );

  static MaterialColor appColors = const MaterialColor(
    0xff1976d2,
    <int, Color>{
      50: Color(0xffe3f2fd),
      100: Color(0xffbbdefb),
      200: Color(0xff90caf9),
      300: Color(0xff64b5f6),
      400: Color(0xff42a5f5),
      500: Color(0xff1976d2),
      600: Color(0xff1565c0),
      700: Color(0xff0d47a1),
      800: Color(0xff0b3d91),
      900: Color(0xff072b69),
    },
  );

  static Color secondaryColor = const Color(0xFFE30158);

  static InputDecoration inputDecoration(String name) => InputDecoration(
        hintText: name,
        labelText: name,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      );

  static InputDecoration messageInputDecoration(String name) => InputDecoration(
        hintText: name,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      );

  static InputDecoration searchInputDecoration(String name, OnSearch search) =>
      InputDecoration(
        hintText: name,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: search,
        ),
      );

  static TextFormField dobTextFormField(
      context, title, initialDate, OnDOBChange onDOBChange,
      [DateTime? maxDateTime, DateTime? minDateTime]) {
    return TextFormField(
      decoration: dobDecoration(
          context, title, initialDate, onDOBChange, maxDateTime, minDateTime),
      onTap: () async {
        DateTime? date = await _selectDate(
            context,
            initialDate is DateTime ? initialDate : DateTime.parse(initialDate),
            maxDateTime,
            minDateTime);
        if (date != null) {
          onDOBChange(date);
        }
      },
    );
  }

  static InputDecoration dobDecoration(
      context, title, initialDate, OnDOBChange onDOBChange,
      [DateTime? maxDateTime, DateTime? minDateTime]) {
    return InputDecoration(
      hintText: "$title",
      contentPadding: const EdgeInsets.all(8),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      suffixIcon: IconButton(
          onPressed: () => onSelectDate(
              context, initialDate, onDOBChange, maxDateTime, minDateTime),
          icon: const Icon(Icons.calendar_month_outlined)),
    );
  }

  static onSelectDate(context, initialDate, OnDOBChange onDOBChange,
      [DateTime? maxDateTime, DateTime? minDateTime]) async {
    DateTime? date = await _selectDate(
        context,
        initialDate is DateTime
            ? initialDate
            : DateTime.parse(
                DateFormat("MM/dd/yyyy").parse(initialDate).toString()),
        maxDateTime,
        minDateTime);
    if (date != null) {
      onDOBChange(date);
    }
  }

  ///cancel elevated button decoration
  static ButtonStyle? cancelButtonStyle() =>
      ElevatedButton.styleFrom(elevation: 1, backgroundColor: Colors.black12);

  static ButtonStyle? defaultButtonStyle() => ElevatedButton.styleFrom(
      elevation: 5,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15));

  static Future<DateTime?> _selectDate(context, DateTime? initialDate,
      [DateTime? maxDate, DateTime? minDate]) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: minDate ?? DateTime(1900),
      lastDate: maxDate ?? DateTime.now(),
    );
    return date;
  }
}

enum ScrollOptions { top, left, right, bottom, reachBottom, reachTop }
