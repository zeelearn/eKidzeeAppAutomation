import 'dart:collection';

import 'package:ekidzee/api/request/batch_request.dart';
import 'package:ekidzee/api/request/save_attendance_request.dart';
import 'package:ekidzee/api/response/academic_year.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../api/APIService.dart';
import '../../../api/request/stud_attendance_request.dart';
import '../../../api/response/BatchesInfo.dart';
import '../../../api/response/student_list.dart';
import '../../../constants.dart';
import '../../../widget/custom_switch.dart';

class ClasswiseAttendance extends StatefulWidget {
  String userId;
  ClasswiseAttendance({Key? key, required this.userId}) : super(key: key);

  @override
  _ClassWiseAttendanceState createState() => _ClassWiseAttendanceState();
}

class _ClassWiseAttendanceState extends State<ClasswiseAttendance> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final List<StudentAttendanceInfo> _attdendanceList = [];
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List<String> academicYearList = [''];
  List<String> batch = [''];

  Map<DateTime, List<Event>> attendanceEvent = {};
  String _currentAcademicYear = '';
  String _currentBatch = '';
  String frianchiseeId = '';
  late AcademicYearInfo academicYearInfo;
  late BatchInfo batchInfo;

  bool isPresent = false;
  bool isLate = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    loadPref();
    loadAcademicYears();
  }

  void loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    frianchiseeId = prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
  }

  void loadAcademicYears() {
    academicYearList.clear();
    APIService apiService = APIService();
    apiService.getAcademicYear().then((value) {
      if (value != null) {
        //Utility.showLoaderDialog(context);
        //Navigator.pop(context);
        academicYearList.clear();
        academicYearInfo = value;
        academicYearList.addAll(academicYearInfo.getArray());
        _currentAcademicYear = academicYearInfo
            .data[academicYearInfo.getArray().length - 1].AcademicYear_Name;
        //debugPrint(_currentAcademicYear);
        kEvents.clear();
        kEvents.addAll(attendanceEvent);
        loadBatches();
        //setState(() {});
      } else {
        //Navigator.pop(context);
        //Utility.showMessage(context, "Invalid User Name and Password");
        //debugPrint("null value");
      }
    });
  }

  void loadBatches() {
    int academicyear =
        academicYearInfo.getSelectedAcademicYearId(_currentAcademicYear);
    BatchRequest request = BatchRequest(
        franchisee_id: frianchiseeId.toString(),
        academicyear_id: academicyear.toString());
    APIService apiService = APIService();
    apiService.getBatches(request).then((value) {
      if (value != null) {
        batch.clear();
        batchInfo = value;
        batch.addAll(batchInfo.getArray());
        if (_currentBatch == '' && batchInfo.data.isNotEmpty) {
          _currentBatch = batchInfo.data[0].Program_Name;
        }
        //debugPrint(_currentAcademicYear);
        setState(() {});
        loadAttendanceInfo(_focusedDay.year, _focusedDay.month);
      } else {
        //Navigator.pop(context);
        //Utility.showMessage(context, "Batch Details are not found");
        //debugPrint("null value");
      }
    });
  }

  void loadAttendanceInfo(int year, int month) {
    //debugPrint('load attendance');
    _attdendanceList.clear();
    setState(() {});
    StudentAttendanceListRequest request = StudentAttendanceListRequest(
        YearID: _currentAcademicYear,
        BatchID: getCurrentBatchId().toString(),
        TeacherID: widget.userId,
        Date: DateFormat('dd-MM-yyyy').format(_selectedDay!),
        FranchiseeID: getFranBatchId().toString());
    //debugPrint(request.toJson());
    APIService apiService = APIService();
    apiService.getStudentAttendanceList(request).then((value) {
      if (value != null) {
        //Utility.showLoaderDialog(context);

        StudentAttendanceList? attendanceList = value;
        _attdendanceList.addAll(attendanceList.data);
        setState(() {});
      } else {
        //Navigator.pop(context);

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
    BoxDecoration decoration = const BoxDecoration(
      color: Colors.indigo,
      shape: BoxShape.circle,
    );
    String todaysDate = DateFormat('dd MMM yyyy').format(day);
    if (attendanceEvent.containsKey(todaysDate)) {
      var list = attendanceEvent[todaysDate]?.toList();
      if (list?[0].title == 'Present') {
        decoration = const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );
      } else if (list?[0].title == 'Holiday') {
        decoration = const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
        );
      }
    }
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
    loadAttendanceInfo(_focusedDay.year, _focusedDay.month);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
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

  bool isLoading = false;
  saveAttendance() {
    isLoading = true;
    setState(() {});

    List<AttendanceList> list = [];
    for (int index = 0; index < _attdendanceList.length; index++) {
      list.add(AttendanceList(
          id: 'null',
          studentID: _attdendanceList[index].studentID.toInt().toString(),
          studentName: _attdendanceList[index].studentName,
          isPresent: _attdendanceList[index].isPresent,
          isSMSSent: _attdendanceList[index].isSMSSent,
          isLateMark: _attdendanceList[index].isLateMark,
          parentID: _attdendanceList[index].parentID.toInt().toString(),
          parentName: _attdendanceList[index].parentName,
          phone1: _attdendanceList[index].phone1,
          phone2: _attdendanceList[index].phone2,
          date: 'null',
          batchYear: _currentAcademicYear.substring(2, 4),
          lastSMS: _attdendanceList[index].lastSMS));
    }
    SaveAttendanceRequest request = SaveAttendanceRequest(
        yearID: int.parse(_currentAcademicYear.substring(2, 4)),
        batchID: getCurrentBatchId(),
        teacherID: int.parse(widget.userId),
        date: DateFormat('dd-MM-yyyy').format(_selectedDay!),
        franchiseeID: getFranBatchId(),
        createdBy: widget.userId,
        attendanceList: list);
    //debugPrint(request.toJson());
    APIService apiService = APIService();
    apiService.saveAttendanceInfo(request).then((value) {
      ////debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
        String response = value;
        Utility.showMessage(context, 'Attendance saved successfully..');
        setState(() {});
      }
      //Navigator.of(context).pop();
      setState(() {});
    });
  }

  int getCurrentBatchId() {
    int batchId = 0;
    for (int index = 0; index < batchInfo.data.length; index++) {
      if (_currentBatch == batchInfo.data[index].Program_Name) {
        batchId = batchInfo.data[index].Program_ID.toInt();
      }
    }
    return batchId;
  }

  int getFranBatchId() {
    int francId = 0;
    for (int index = 0; index < batchInfo.data.length; index++) {
      if (_currentBatch == batchInfo.data[index].Program_Name) {
        francId = batchInfo.data[index].Franchisee_ID.toInt();
      }
    }
    return francId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isSameDay(_selectedDay, DateTime.now())
          ? FloatingActionButton(
              onPressed: () {
                saveAttendance();
              },
              backgroundColor: kPrimaryLightColor,
              child: const Icon(Icons.save),
            )
          : null,
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text('Select Academic Year'),
              const SizedBox(
                width: 20,
              ),
              DropdownButton<String>(
                value: _currentAcademicYear,
                items: academicYearList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  _currentAcademicYear = value!;
                  //debugPrint(_currentAcademicYear);
                  _currentBatch = '';
                  loadBatches();
                },
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text('Select Batch '),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 200,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _currentBatch,
                    items: batch.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _currentBatch = value!;
                        //debugPrint(_currentBatch);
                        loadAttendanceInfo(_focusedDay.year, _focusedDay.month);
                      });
                    },
                  )),
            ],
          ),
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
              loadAttendanceInfo(_focusedDay.year, _focusedDay.month);
              //debugPrint('page changespp');
            },
          ),
          const SizedBox(height: 8.0),
          _attdendanceList.isEmpty
              ? Utility.emptyData(context, 'Student List not valiable')
              : Expanded(
                  child: ListView.builder(
                    itemCount: _attdendanceList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              _attdendanceList[index].studentName,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            trailing: Container(
                              child: CustomSwitch(
                                value: _attdendanceList[index].isPresent,
                                onChanged: (bool val) {
                                  setState(() {
                                    _attdendanceList[index].isPresent = val;
                                  });
                                },
                                positiveValue: 'Present',
                                negativeValue: 'Absent',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          /*Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
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
                        onTap: () => //debugPrint('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),*/
        ],
      ),
    );
  }
}

Widget getSwitch(bool isSwitched) {
  return Switch(value: isSwitched, onChanged: (value) {});
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
