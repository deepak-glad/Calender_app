import 'package:calendar_test_app/provider/calender_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'editing.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<CalendarProvider>(context, listen: false).eventDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataEvent = Provider.of<CalendarProvider>(context).events;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text(
          'Calendar',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 7, 36, 0.8),
        bottomOpacity: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SfCalendarTheme(
        data: SfCalendarThemeData(
          activeDatesTextStyle:
              const TextStyle(fontSize: 16, color: Colors.white),
        ),
        child: SfCalendar(
          backgroundColor: const Color.fromRGBO(0, 7, 36, 0.8),
          cellBorderColor: Colors.white,
          todayHighlightColor: Colors.red,
          firstDayOfWeek: 1,
          viewHeaderHeight: 40,
          headerStyle: const CalendarHeaderStyle(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          viewHeaderStyle: const ViewHeaderStyle(
              dayTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              dateTextStyle: TextStyle(color: Colors.white, fontSize: 25)),
          todayTextStyle: const TextStyle(color: Colors.white),
          cellEndPadding: 4,
          view: CalendarView.month,
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          dataSource: MeetingDataSource(dataEvent),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EventEditingPage())),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).backgroundColor;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }
    return meetingData;
  }
}

class Meeting {
  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Meeting({
    required this.eventName,
    required this.from,
    required this.to,
    required this.backgroundColor,
    this.isAllDay = false,
  });
}
