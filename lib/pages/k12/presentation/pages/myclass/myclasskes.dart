import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LightColor.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/bpms/bpms_db.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/classmastermodel.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_calendar.dart';
import 'package:ekidzee/pages/k12/presentation/pages/myclass/kesstudentlist.dart';
import 'package:ekidzee/pages/k12/presentation/providers/myclass_provider.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saathi/widget/dropdown.dart';

import '../../../../pentemind/module/myclass/almanac_menu.dart';

class MyKesClassPage extends StatefulWidget {
  int sectinId;
  onClickListener listener;
  int classId;
  String userUID;
  String userName;

  MyKesClassPage(
      {super.key,
      required this.sectinId,
      required this.listener,
      required this.classId,
      required this.userUID,
      required this.userName});

  @override
  _MyKesClassPageState createState() => _MyKesClassPageState();
}

//class MyKesClassPage extends StatelessWidget {
class _MyKesClassPageState extends State<MyKesClassPage>
    with SingleTickerProviderStateMixin
    implements onClickListener {
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();

  bool isFloatingDay = false;

  TermMonthList? mSelectedTerm;
  Month? mSelectedMonth;
  final String _selectAllStatus = '';
  List<FloatingDayRemarks> mFloatingDayRemarks = [];
  late TabController _tabController;

  List<Term> mTerms = [];
  List<Month> mMonths = [];

  final List<AttandanceDays> _attandanceCalendar = [];
  final List<FloatingDay> _floatingDay = [];
  Future<ClassMasterModel>? _terms;
  final _selectedColor = Colors.white;
  final _indicatorColor = kPrimaryLightColor;
  final _unselectedColor = Colors.grey;
  final _tabs = [
    const Tab(text: 'Attendance '),
    const Tab(text: 'Almanac'),
  ];

  @override
  void initState() {
    super.initState();
    _terms = MyClassProvider.terms();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _selectedColor,
        title: TabBar(
          labelPadding: EdgeInsets.zero,
          controller: _tabController,
          tabs: _tabs,
          // isScrollable: true,
          tabAlignment: TabAlignment.fill,
          dividerColor: Colors.blueGrey,
          labelColor: _indicatorColor,
          indicatorColor: _indicatorColor,
          unselectedLabelColor: _unselectedColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: getAttandanceView(),
          ),
          Center(
            child: AlmanacMenu(
              listener: widget.listener,
            ),
          ),
        ],
      ),
    );
  }

  Widget getAttandanceView() {
    return Column(
      children: [
        FutureBuilder(
          future: _terms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.success != 200) {
              return Center(child: Text('No terms found.'));
            }

            mFloatingDayRemarks.clear();
            mFloatingDayRemarks
                .addAll(snapshot.data!.data![0].floatingDayRemarks!);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: defaultPadding,
                      right: defaultPadding,
                      top: 10,
                      bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 35,
                            width: _width(),
                            child: ZeeDropDown(
                              title: 'Term',
                              textController: _termController,
                              hintText: 'Select Term',
                              readOnly: true,
                              items: snapshot.data!.data![0].termMonthList!,
                              displayFunction: (value) => value.termName!,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _termController.text = value.termName!;
                                    mSelectedTerm = value;
                                    _monthController.text = '';

                                    updateMonths();
                                  });
                                } else {
//                                   debugPrint('in else terms');
                                  _floatingDay.clear();
                                  updateMonths();
//                                   debugPrint('in else terms updatemonth');
                                  setState(() {
                                    _termController.text = '';
                                    _monthController.text = '';
                                    mSelectedMonth = null;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          if (_termController.text.isNotEmpty)
                            SizedBox(
                              height: 35,
                              width: _width(),
                              child: ZeeDropDown(
                                title: 'Month',
                                textController: _monthController,
                                hintText: 'Select Month',
                                readOnly: true,
                                items: mMonths,
                                displayFunction: (value) => value.monthName!,
                                onChanged: (value) {
                                  if (value != null) {
                                    //setState(() {
                                    _monthController.text = value.monthName!;
                                    mSelectedMonth = value;
                                    loadAttantendanceCalendar();
                                    //});
                                  } else {
                                    _monthController.text = '';
                                    mSelectedMonth = null;
                                    _floatingDay.clear();
                                    //loadAttantendanceCalendar();
                                    setState(() {
                                      _attandanceCalendar.clear();
                                      _floatingDay.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      if (mSelectedMonth != null)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFloatingDay = !isFloatingDay;
                            });
                          },
                          // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                          style: ElevatedButton.styleFrom(
                              elevation: 10.0,
                              textStyle: TextStyle(color: kPrimaryLightColor)),
                          child: Text(
                            isFloatingDay ? 'Back' : 'Floating Day',
                            style: LightColors.subTextStyle
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      //SizedBox(width: 10,),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        Divider(
          color: LightColors.kLightGrayM,
          height: 1,
        ),
        Responsive.isDesktop(context)
            ? Expanded(
                child: _myClassWebView(),
              )
            : _myClassMobleView(),
      ],
    );
  }

  void updateMonths() {
    try {
      mSelectedMonth = null;
      mMonths.clear();
      if (mSelectedTerm != null && mSelectedTerm!.month!.isNotEmpty) {
        mMonths.addAll(mSelectedTerm!.month!);
        mMonths.sort((a, b) => a.order!.compareTo(b.order!));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {});
  }

  Expanded _myClassMobleView() {
    return Expanded(
      child: Column(
        children: [
          // Center the grid in the remaining space
          Expanded(
            child: getCalendarEvents(),
          ),
          Divider(
            color: Colors.blueGrey,
          ),
          // FloatingDay List on the right
          if (!isFloatingDay && _floatingDay.isNotEmpty)
            Container(
              width: double.infinity,
              color: LightColor.lightGrey,
              padding: EdgeInsets.all(10),
              child: Text('Floating Days'),
            ),
          if (!isFloatingDay && _floatingDay.isNotEmpty)
            Flexible(
              child: ListView.builder(
                itemCount: _floatingDay.length,
                itemBuilder: (context, index) {
                  final day = _floatingDay[index];
                  return InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KESMyClassStudentListPage(
                                  sectionId: widget.sectinId,
                                  userName: widget.userName,
                                  userid: widget.userUID,
                                  remark: _floatingDay[index].remarks!,
                                  date: _floatingDay[index].date!,
                                  termId: mSelectedTerm!.termId!,
                                  remarkList: [],
                                  monthId: mSelectedMonth!.month!,
                                  title:
                                      'Floating Day - ${_floatingDay[index].remarks!}',
                                  isFloatingDay: false,
                                  mClickListener: this,
                                )),
                      ).then((value) {
                        if (value != null && value is String) {
                          updateAttandanceForDay(value);
                        }
                      });
                    },
                    child: ListTile(
                      title: Text(
                        day.date ?? '',
                        style: LightColors.textHeaderStyle13,
                      ),
                      subtitle: Text(
                        day.remarks ?? '',
                        style: LightColors.subTextStyle,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Row _myClassWebView() {
    return Row(
      children: [
        // Center the grid in the remaining space
        Expanded(
          child: getCalendarEvents(),
        ),
        Divider(
          color: Colors.blueGrey,
        ),
        // FloatingDay List on the right
        Container(
            width: 300, // Fixed width for the list
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: LightColor.lightGrey,
                    padding: EdgeInsets.all(10),
                    child: Text('Floating Days'),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: _floatingDay.length,
                      itemBuilder: (context, index) {
                        final day = _floatingDay[index];
                        return InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      KESMyClassStudentListPage(
                                        sectionId: widget.sectinId,
                                        userName: widget.userName,
                                        userid: widget.userUID,
                                        remark: _floatingDay[index].remarks!,
                                        date: _floatingDay[index].date!,
                                        termId: mSelectedTerm!.termId!,
                                        remarkList: [],
                                        monthId: mSelectedMonth!.month!,
                                        title:
                                            'Floating Day - ${_floatingDay[index].remarks!}',
                                        isFloatingDay: false,
                                        mClickListener: this,
                                      )),
                            ).then((value) {
                              if (value != null && value is String) {
                                updateAttandanceForDay(value);
                              }
                            });
                          },
                          child: ListTile(
                            title: Text(
                              day.date ?? '',
                              style: LightColors.textHeaderStyle13,
                            ),
                            subtitle: Text(
                              day.remarks ?? '',
                              style: LightColors.subTextStyle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> loadAttantendanceCalendar() async {
    bool is24 = await BpmsDB.getACYear();
    Utility.showKESLoaderDialog(context);
    _attandanceCalendar.clear();
    _floatingDay.clear();
    //debugPrint('Selected Month ${mSelectedMonth!.toJson()} ${widget.sectinId} ${mSelectedMonth}');
    AttandanceDaysResponse response = await MyClassProvider.attandanceCalender(
        widget.sectinId, mSelectedMonth!.month!, is24 ? 2024 : 2025);
    Utility.hideDialog(context);
    if (response.data != null && response.data!.isNotEmpty) {
      _attandanceCalendar.addAll(response.data![0].attandanceData!);
    }
    if (response.data != null && response.data!.isNotEmpty) {
      _floatingDay.addAll(response.data![0].floatingDay!);
    }
    setState(() {});
  }

  void openFloatingDay(targetDate) {
    FloatingDay? matchedDay =
        _floatingDay.where((day) => day.date == targetDate).isNotEmpty
            ? _floatingDay.firstWhere((day) => day.date == targetDate)
            : null;
    if (matchedDay != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => KESMyClassStudentListPage(
                  sectionId: widget.sectinId,
                  userName: widget.userName,
                  userid: widget.userUID,
                  remark: matchedDay.remarks!,
                  date: matchedDay.date!,
                  termId: mSelectedTerm!.termId!,
                  remarkList: [],
                  monthId: mSelectedMonth!.month!,
                  title: 'Floating Day - ${matchedDay.remarks!}',
                  isFloatingDay: false,
                  mClickListener: this,
                )),
      ).then((value) {
        if (value != null && value is String) {
          updateAttandanceForDay(value);
        }
      });
    } else {
//       debugPrint('No matching date found.');
    }
  }

  bool isFloatingDayMarked(String dateToCheck) {
    return _floatingDay.any((floatingDay) => floatingDay.date == dateToCheck);
  }

  dynamic getCalendarEvents() {
    return mSelectedTerm == null || mSelectedMonth == null
        ? Utility.filter(context,
            'Please Select the ${mSelectedTerm == null ? 'Term' : 'Month'}')
        : isFloatingDay
            ? floatingDayList()
            : getDayAttandance();
  }

  Container floatingDayList() {
    return Container(
      color: Colors.white,
      child: SizedBox(
          height: MediaQuery.of(context).size.height * (kIsWeb ? 0.75 : 0.7),
          width: MediaQuery.of(context).size.width * 0.96,
          child: KESMyClassStudentListPage(
            sectionId: widget.sectinId,
            userName: widget.userName,
            monthId: mSelectedMonth!.month!,
            userid: widget.userUID,
            date: _attandanceCalendar[0].date!,
            remark: '',
            title: 'Floating Days',
            termId: mSelectedTerm!.termId!,
            remarkList: mFloatingDayRemarks,
            isFloatingDay: true,
            mClickListener: this,
          )),
    );
  }

  Expanded getDayAttandance() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _attandanceCalendar.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (isFloatingDayMarked(_attandanceCalendar[index].date!)) {
                openFloatingDay(_attandanceCalendar[index].date!);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KESMyClassStudentListPage(
                            sectionId: widget.sectinId,
                            userName: widget.userName,
                            userid: widget.userUID,
                            date: _attandanceCalendar[index].date!,
                            termId: mSelectedTerm!.termId!,
                            remarkList: [],
                            remark: '',
                            title: 'Attendance',
                            isFloatingDay: false,
                            mClickListener: this,
                          )),
                ).then((value) {
//                   debugPrint('return $value');
                  if (value != null && value is String) {
                    updateAttandanceForDay(value);
                  }
                });
              }
            },
            mouseCursor: SystemMouseCursors.click,
            child: Container(
              padding:
                  EdgeInsets.only(left: defaultPadding, right: defaultPadding),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: LightColors.kLightGrayM),
                color: _attandanceCalendar[index].isAttendanceFilled == 1
                    ? LightColors.kLightBlue
                    : Colors.white,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _attandanceCalendar[index].weekday.toString(),
                      style: LightColors.textHeaderStyle13,
                    ),
                    Text(
                      _attandanceCalendar[index].date.toString(),
                      style: LightColors.subTextStyle,
                    ),
                    if (isFloatingDayMarked(_attandanceCalendar[index].date!))
                      Image.asset(
                        'assets/icons/ic_floating_day.png',
                        width: 24,
                        height: 24,
                      )
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate: Utility.getCalenderGridViewStyle(context),
      ),
    );
  }

  double _width() {
    return (MediaQuery.of(context).size.width / 3.6 < 200
            ? MediaQuery.of(context).size.width / 3.6
            : 200)
        .toDouble();
  }

  void updateAttandanceForDay(String date) {
    for (var attendance in _attandanceCalendar) {
      if (date == attendance.date!) {
        attendance.isAttendanceFilled = 1;
      }
    }
    setState(() {});
  }

  @override
  void onClick(int action, value) {
    if (action == LocalConstant.ACTION_RESPONSE && value is String) {
//       debugPrint('Response ===$value');
      updateAttandanceForDay(value);
      if (isFloatingDay) {
        List<String> response = value.split(',');
        String date = response[0];
        String remark = response[1];
        _floatingDay.add(FloatingDay(date: date, remarks: response[1]));
      }
    }
  }
}
