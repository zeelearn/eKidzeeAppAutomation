import 'dart:collection';

import 'package:ekidzee/api/request/attendance_request.dart';
import 'package:ekidzee/api/response/AttendanceInfo.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../api/APIService.dart';

class TableEventsExample extends StatefulWidget {
  String userId;
  TableEventsExample({super.key, required this.userId});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String userType = '';

  Map<DateTime, List<Event>> attendanceEvent = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => getUserInfo());
    } catch (e) {
      //debugPrint(e.toString());
    }
    //loadAttendanceInfo(2022, 7);
  }

  Future<void> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    widget.userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    //debugPrint('uid  is ${widget.userId}');

    loadAttendanceInfo(_focusedDay.year, _focusedDay.month);
  }

  void loadAttendanceInfo(int year, int month) {
    //Utility.showLoaderDialog(context);
    attendanceEvent.clear();
    AttendanceRequest request = AttendanceRequest(
        ParentId: widget.userId, Year: '$year', Month: '$month');
    APIService apiService = APIService();
    // debugPrint(request.toJson());
    apiService.getAttendanceInfo(request).then((value) {
      if (value != null) {
        //Navigator.of(context).pop('dialog');
        AttendanceInfo? attendanceList = value;
        ////debugPrint('value sisnklasdnklasndkanskldnl ${attendanceList.data[0].CalendarDate}');
        for (int index = 0; index < attendanceList.data.length; index++) {
          if (attendanceList.data[index].IsPresent != null) {
            //add event
//             debugPrint('======Present ${attendanceList.data[index].IsPresent}');
            DateTime dt = DateFormat('dd MMM yyyy')
                .parse(attendanceList.data[index].CalendarDate);
            String message = '';
            List<Event> list = [];
            if (attendanceList.data[index].IsPresent == 0) {
//               debugPrint('Present ${attendanceList.data[index].TeacherName}');
              list.add(const Event('Absent'));
            } else if (attendanceList.data[index].IsPresent == 1) {
              //debugPrint('Present ${attendanceList.data[index].TeacherName}');
              list.add(const Event('Present'));
            } else if (attendanceList.data[index].IsHoliday == 1) {
              //debugPrint('Holiday ${attendanceList.data[index].TeacherName}');
              list.add(const Event('Holiday'));
            } else if (attendanceList.data[index].IsLateMark == 1) {
              //debugPrint('LateMark ${attendanceList.data[index].TeacherName}');
              list.add(const Event('LateMark'));
            }
            if (list.isNotEmpty) {
//               debugPrint('list added');
              attendanceEvent.putIfAbsent(dt, () => list);
            }
          }
        }
        //debugPrint('completed --=');

        kEvents.clear();
        kEvents.addAll(attendanceEvent);
        setState(() {});
      } else {
        //Navigator.pop(context);
        Utility.showMessage(context, "Attendance not Avaliable ");
        //debugPrint("null value");
      }
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  BoxDecoration _getEventDecoration(DateTime day) {
    // Implementation example
    //return kEvents[day] ?? [];
    var list = attendanceEvent[day]?.toList();
    BoxDecoration decoration = const BoxDecoration(
      color: Colors.indigo,
      shape: BoxShape.circle,
    );
    String todaysDate = DateFormat('dd MMM yyyy').format(day);
    //if(attendanceEvent.containsKey(todaysDate)){
    //var list = attendanceEvent[day]?.toList();
    if (list?[0].title == 'Absent') {
      decoration = const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.rectangle,
      );
    } else if (list?[0].title == 'Present') {
      decoration = const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.rectangle,
      );
    } else if (list?[0].title == 'Holiday') {
      decoration = const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.rectangle,
      );
    }
    //}
    return decoration;
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    loadAttendanceInfo(_focusedDay.year, _focusedDay.month);
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
      loadAttendanceInfo(_focusedDay.year, _focusedDay.month);
    });
    //debugPrint('_onRangeSelected');
    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekStyle: const DaysOfWeekStyle(
              // Weekend days color (Sat,Sun)
              weekendStyle: TextStyle(color: Colors.deepOrangeAccent),
            ),
            // Calendar Dates styling
            calendarStyle: CalendarStyle(
              // Weekend dates color (Sat & Sun Column)
              weekendTextStyle: const TextStyle(color: Colors.red),
              // highlighted color for today
              todayDecoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.rectangle,
              ),
              // highlighted color for selected day
              selectedDecoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.rectangle,
              ),
              markerDecoration: _getEventDecoration(_focusedDay),
            ),

            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              //debugPrint('page changes');

              loadAttendanceInfo(_focusedDay.year, _focusedDay.month);
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return value.isEmpty
                    ? Utility.emptyData(
                        context, 'Attendance data not avaliable')
                    : ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => debugPrint('${value[index]}'),
                              title: Text('${value[index]}'),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

_getHolidays(day) {
  return day == DateTime.utc(2022, 20, 07);
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
}..addAll({
    kToday: [
      const Event('Today\'s Event 1'),
      const Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month, kToday.day);
