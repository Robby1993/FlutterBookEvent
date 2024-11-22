import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateConverter {
  static String getTime(DateTime dt) {
    try {
      final String dtHour =
          dt.hour.toString().length == 1 ? "0${dt.hour}" : dt.hour.toString();
      final String dtMinute = dt.minute.toString().length == 1
          ? "0${dt.minute}"
          : dt.minute.toString();
      final String time = "$dtHour:$dtMinute";
      return time;
    } catch (e) {
      return "";
    }
  }

  static String getFormatedDate(inputDate, {String outputFor = "yyyy-MM-dd"}) {
    /// 2023-11-07 00:00:00.000 //2020-10-10
    // var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    // var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat(outputFor);
    return outputFormat.format(inputDate);
  }

  static String convertDateSpecificFormat({
    required String inputDateFormat,
    required String date,
    required String outputDateFormat,
    bool isDateUtc = false,
  }) {
    debugPrint("convertDateSpecificFormat ----$date");
    if(date.isEmpty){
      return "";
    }
    // date 2023-11-17T13:43:43.147Z fomat yyyy-MM-dd'T'HH:mm:ss
    /// 2023-11-07 00:00:00.000 //2020-10-10
    //var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    var inputFormat = DateFormat(inputDateFormat);
    var inputDate = inputFormat.parse(date, isDateUtc).toLocal();
    var outputFormat = DateFormat(outputDateFormat);
    return outputFormat.format(inputDate);
  }


  static String convertDateToRelativeTime({
    required String inputDateFormat,
    required String date,
    bool isDateUtc = false,
  }) {
    debugPrint("convertDateSpecificFormat ----$date");
    if (date.isEmpty) {
      return "";
    }

    // Parse the input date
    var inputFormat = DateFormat(inputDateFormat);
    DateTime inputDate = inputFormat.parse(date, isDateUtc).toLocal();

    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the difference between the current time and the input date
    Duration difference = now.difference(inputDate);

    if (difference.inSeconds < 60) {
      return "Just Now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks week${weeks > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return "$months month${months > 1 ? 's' : ''} ago";
    } else {
      int years = (difference.inDays / 365).floor();
      return "$years year${years > 1 ? 's' : ''} ago";
    }
  }


  static String convertDateFormat({
    required String inputDateFormat,
    required String date,
    required String outputDateFormat,
    bool isDateUtc = false,
  }) {
    debugPrint("convertDateSpecificFormat ----$date");
    if(date.isEmpty){
      return "";
    }
    // Parsing the time string
    DateFormat inputFormat = DateFormat(inputDateFormat);
    DateTime dateTime = inputFormat.parse(date);

    // Formatting to hh:mm:ss
    DateFormat outputFormat = DateFormat(outputDateFormat);
    String formattedTime = outputFormat.format(dateTime);

    // Output the formatted time
    debugPrint("Formatted Time: $formattedTime");
    return formattedTime;
  }



  static String formatDate({
    required String date,
    required String inputDateFormat,
    required String outputDateFormat,
  }) {
    // Parse the input date string
    DateFormat inputFormat = DateFormat(inputDateFormat);
    DateTime parsedDate = inputFormat.parse(date);

    // Format the day with the ordinal suffix
    String dayWithSuffix = _getDayWithSuffix(parsedDate.day);

    // Format the entire date
   // DateFormat outputFormat = DateFormat('MMMM EEEE');
    DateFormat outputFormat = DateFormat(outputDateFormat);
    String formattedDate = outputFormat.format(parsedDate);

    return '$dayWithSuffix $formattedDate';
  }

  static String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  static String convertDateSpecificFormat1(
      String date, String outputDateFormat) {
    String returnDate;
    // date 2023-11-17T13:43:43.147Z fomat yyyy-MM-dd'T'HH:mm:ss
    /// 2023-11-07 00:00:00.000 //2020-10-10
    //var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    // var inputFormat = DateFormat(inputDateFormat);
    // var inputDate = inputFormat.parse(date);
    // var outputFormat = DateFormat('yyyy-MM-dd');
    var outputFormat = DateFormat(outputDateFormat);
    //return outputFormat.format(inputDate);
    // var finalFormat= outputFormat.format(inputDate);
    DateTime dateToCheck = DateFormat(outputDateFormat).parse(date);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    // final dateToCheck = finalFormat;
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (aDate == today) {
      returnDate = "Today";
    } else if (aDate == yesterday) {
      returnDate = "Yesterday";
    } else if (aDate == tomorrow) {
      returnDate = "Tomorrow";
    } else {
      returnDate = date;
    }

    return returnDate;
  }

  static String getTimeString(String dt) {
    try {
      DateTime dt0 = DateTime.parse(dt);
      final String dtHour = dt0.hour.toString().length == 1
          ? "0${dt0.hour}"
          : dt0.hour.toString();
      final String dtMinute = dt0.minute.toString().length == 1
          ? "0${dt0.minute}"
          : dt0.minute.toString();
      final String time = "$dtHour:$dtMinute";
      return time;
    } catch (e) {
      return "";
    }
  }

  static String getDateTimeWithMonth(DateTime dt) {
    try {
      String monthName = "";
      if (dt.month == 1) {
        monthName = "January";
      } else if (dt.month == 2) {
        monthName = "February";
      } else if (dt.month == 3) {
        monthName = "March";
      } else if (dt.month == 4) {
        monthName = "April";
      } else if (dt.month == 5) {
        monthName = "May";
      } else if (dt.month == 6) {
        monthName = "June";
      } else if (dt.month == 7) {
        monthName = "July";
      } else if (dt.month == 8) {
        monthName = "August";
      } else if (dt.month == 9) {
        monthName = "September";
      } else if (dt.month == 10) {
        monthName = "October";
      } else if (dt.month == 11) {
        monthName = "November";
      } else if (dt.month == 12) {
        monthName = "December";
      }

      return "${dt.day} $monthName ${dt.year}, ${getTime(dt)}";
    } catch (e) {
      return "";
    }
  }

  static String todayDate({String format = "yyyy-MM-dd"}) {
    final outputFormat = DateFormat(format);
    var outputDate = outputFormat.format(DateTime.now());
    return outputDate;
  }

  static DateTime convertStrToDatetime(String dateString,{String format = "yyyy-MM-dd"}) {
    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(dateString);
    return dateTime;
  }
}
