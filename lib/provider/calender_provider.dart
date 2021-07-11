import 'package:calendar_test_app/model/calender_model.dart';
import 'package:calendar_test_app/screen/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CalendarProvider with ChangeNotifier {
  final List<Meeting> _events = <Meeting>[
    Meeting(
      eventName: 'eventName',
      backgroundColor: Colors.blue,
      from: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 9, 0, 0),
      to: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 11, 0, 0),
    )
  ];
  Future<void> eventDate() async {
    var url = Uri.parse(
        'https://www.googleapis.com/calendar/v3/calendars/1025deepakyadav@gmail.com/events?key=AIzaSyAZp6kN9OnhgJPnS6am_vBpXNaGC2_g3pY');
    http.Response reponse = await http.get(url);
    final jsonBody = reponse.body;
    final jsonMap = jsonDecode(jsonBody);
    var da = CalenderModel.fromJson(jsonMap);

    for (int i = 0; i < da.items.length; i++) {
      _events.add(Meeting(
          eventName: da.items[i].summary,
          from: DateTime(
              da.items[i].start.dateTime.year,
              da.items[i].start.dateTime.month,
              da.items[i].start.dateTime.day,
              da.items[i].start.dateTime.hour,
              0,
              0),
          to: DateTime(
              da.items[i].end.dateTime.year,
              da.items[i].end.dateTime.month,
              da.items[i].end.dateTime.day,
              da.items[i].end.dateTime.hour,
              0,
              0),
          backgroundColor: Colors.green));
    }
    notifyListeners();
  }

  void addEvent(Meeting meeting) {
    _events.add(meeting);
    notifyListeners();
  }

  List<Meeting> get events => _events;
}
