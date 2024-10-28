  import 'package:flutter/material.dart';
  import 'package:prestige_vender/models/getShopModel.dart';
  import 'package:intl/intl.dart';

  class WeeksProvider extends ChangeNotifier {
    Map<String, Map<String, String>> timings = {
      'Monday': { "day"'openTime': '', 'closeTime': ''},
      'Tuesday': {'openTime': '', 'closeTime': ''},
      'Wednesday': {'openTime': '', 'closeTime': ''},
      'Thursday': {'openTime': '', 'closeTime': ''},
      'Friday': {'openTime': '', 'closeTime': ''},
      'Saturday': {'openTime': '', 'closeTime': ''},
      'Sunday': {'openTime': '', 'closeTime': ''}
    };
  //   List<Map<String, dynamic>> weeks = [
  //   {
  //     "day": "Monday",
  //     "openTime": "",
  //     "closeTime": "",
  //   },
  //   {
  //     "day": "Tuesday",
  //     "openTime": "",
  //     "closeTime": "",
  //   },
  //   {
  //     "day": "Wednesday",
  //     "openTime": "",
  //     "closeTime": "",
  //   },
  //   {
  //     "day": "Thursday",
  //     "openTime": "",
  //     "closeTime": "",
  //   },
  //   {
  //     "day": "Friday",
  //     "openTime": "",
  //     "closeTime": "",
  //   },
  //   {
  //     "day": "Saturday",
  //     "openTime": "",
  //     "closeTime": "",
  //   },
  //   {
  //     "day": "Sunday",
  //     "openTime": "",
  //     "closeTime": "",
  //   }
  // ];

    

    // Convert 24-hour time format to 12-hour format with AM/PM
    String convertTo12HourFormat(String time24) {
      final DateTime parsedTime = DateFormat.Hm().parse(time24);
      return DateFormat.jm().format(parsedTime);
    }
    

    void initializeTimings(List<Week> weeks) {
      for (var week in weeks) {
        timings[week.day!] = {
          'openTime': convertTo12HourFormat(week.openTime!),
          'closeTime': convertTo12HourFormat(week.closeTime!)
        };
      }
      notifyListeners();
    }

   
    void setTiming(String day, String openTime, String closeTime) {
  timings[day] = {
    'openTime': openTime,
    'closeTime': closeTime
  };
  notifyListeners(); // Notify listeners after updating the map
}
  }
