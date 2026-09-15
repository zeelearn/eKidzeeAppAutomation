/*
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class StudentAttendance extends StatefulWidget {
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {

  @override
  Widget build(BuildContext context) {
    final _sampleEvents = sampleEvents();
    final cellCalendarPageController = CellCalendarPageController();

    return Scaffold(

      body: CellCalendar(
        cellCalendarPageController: cellCalendarPageController,
        todayMarkColor: Colors.blue,
        events: _sampleEvents,
        daysOfTheWeekBuilder: (dayIndex) {
          final labels = ["S", "M", "T", "W", "T", "F", "S"];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              labels[dayIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        monthYearLabelBuilder: (datetime) {
          final year = datetime?.year.toString();
          final month = datetime?.month.monthName;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  "$month  $year",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    cellCalendarPageController.animateToDate(
                      DateTime.now(),
                      curve: Curves.linear,
                      duration: Duration(milliseconds: 300),
                    );
                  },
                )
              ],
            ),
          );
        },
        onCellTapped: (date) {
          final eventsOnTheDate = _sampleEvents.where((event) {
            final eventDate = event.eventDate;
            return eventDate.year == date.year &&
                eventDate.month == date.month &&
                eventDate.day == date.day;
          }).toList();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title:
                Text(date.month.monthName + " " + date.day.toString()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: eventsOnTheDate
                      .map(
                        (event) => Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.only(bottom: 12),
                      color: event.eventBackgroundColor,
                      child: Text(
                        event.eventName,
                        style: TextStyle(color: event.eventTextColor),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ));
        },
        onPageChanged: (firstDate, lastDate) {
          /// Called when the page was changed
          /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
        },
      ),
    );
  }

  List<CalendarEvent> sampleEvents() {
    final today = DateTime.now();
    final sampleEvents = [
      CalendarEvent(
          eventName: "Absent",
          eventDate: today.add(Duration(days: -42)),
          eventBackgroundColor: Colors.red),
      CalendarEvent(
          eventName: "Holiday",
          eventDate: today.add(Duration(days: -30)),
          eventBackgroundColor: Colors.deepOrange),
      CalendarEvent(
          eventName: "independence day",
          eventDate: today.add(Duration(days: -7)),
          eventBackgroundColor: Colors.greenAccent),
      CalendarEvent(
          eventName: "Makar Sankranti",
          eventDate: today.add(Duration(days: -7))),
      CalendarEvent(
          eventName: "Holi",
          eventDate: today.add(Duration(days: -7))),
      CalendarEvent(
          eventName: "Gudi Padwa",
          eventDate: today.add(Duration(days: -7)),
          eventBackgroundColor: Colors.deepOrange),

    ];
    return sampleEvents;
  }
}*/
