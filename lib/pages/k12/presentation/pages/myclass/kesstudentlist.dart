import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/globals.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/attendance_model.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/classmastermodel.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_student_list.dart';
import 'package:ekidzee/pages/k12/presentation/providers/myclass_provider.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/KidzeeWidget.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saathi/widget/dropdown.dart';

class KESMyClassStudentListPage extends StatefulWidget {
  final int sectionId;
  final bool? isFloatingDay;
  final String title;
  final String userName;
  final String userid;
  final String date;
  final String remark;
  final int? monthId;
  final int termId;
  List<FloatingDayRemarks> remarkList;
  final onClickListener mClickListener;

  KESMyClassStudentListPage(
      {super.key,
      required this.date,
      required this.sectionId,
      required this.userName,
      required this.userid,
      required this.termId,
      required this.remark,
      this.isFloatingDay,
      this.monthId,
      required this.remarkList,
      required this.title,
      required this.mClickListener});

  @override
  _KESMyClassStudentListPageState createState() =>
      _KESMyClassStudentListPageState();
}

class _KESMyClassStudentListPageState extends State<KESMyClassStudentListPage> {
  final List<StudentKesAttandance> _studentAttandance = [];
  String _selectAllStatus = '';
  FloatingDayRemarks? mSelectedFloatingDay;
  String _selectedDate = 'Select Date';
  final String _selectedDay = '';
  bool isToday = false;
  final TextEditingController _floatingDayController = TextEditingController();
  bool isupdate = false;
  bool isLoading = false;
  int year = DateTime.now().year;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      try {
        year = DateTime.parse(widget.date).year;
//         debugPrint('year ======== $year');
      } catch (e) {}
      loadStudentList();
    });
  }

  void onBack() {
    //getObservationChanges();
    if (isupdate)
      Navigator.of(context).pop(widget.date);
    else
      Navigator.of(context).pop();
  }

  Widget _appbar() {
//     debugPrint('in appbar FloatingDay ${widget.isFloatingDay}');
    return widget.isFloatingDay!
        ? Responsive.isDesktop(context) || Responsive.isTablet(context)
            ? Center(
                child: Column(
                  children: [
                    MyWidget().richText(
                        widget.title,
                        LightColors.textvSmallStyle
                            .copyWith(color: Colors.black)),
                    Row(
                      children: [
                        if (kIsWeb)
                          Container(
                              width: 100,
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                color: LightColors.kLightGrayM,
                                border: Border.all(
                                  color: LightColors.kLightGrayM,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  openDatePicker(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    _selectedDate,
                                    style: LightColors.subTextStyle,
                                  ),
                                ),
                              )),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 2,
                          child: ZeeDropDown(
                            title: 'Floating Days Remark',
                            readOnly: true,
                            textController: _floatingDayController,
                            hintText: 'Floating Days Remark',
                            items: widget.remarkList,
                            displayFunction: (value) => value.remarkName!,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _floatingDayController.text =
                                      value.remarkName!;
                                  mSelectedFloatingDay = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            :
//mobile view
            Row(
                children: [
                  Expanded(
                    child: Container(
                        // width: MediaQuery.of(context).size.width / 3.7,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: LightColors.kLightGrayM,
                          border: Border.all(
                            color: LightColors.kLightGrayM,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            openDatePicker(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            height: 35,
                            child: Center(
                              child: Text(
                                _selectedDate,
                                style: LightColors.subTextStyle,
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ZeeDropDown(
                      title: 'Floating Days Remark',
                      readOnly: true,
                      textController: _floatingDayController,
                      hintText: 'Floating Days Remark',
                      items: widget.remarkList,
                      displayFunction: (value) => value.remarkName!,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _floatingDayController.text = value.remarkName!;
                            mSelectedFloatingDay = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              )
        : MyWidget().richText(widget.title,
            LightColors.textHeaderStyle13.copyWith(color: Colors.white));
  }

  Card floatingDayheader() {
    return Card(
        elevation: 10,
        color: Colors.white,
        shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    openDatePicker(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 35,
                    child: Center(
                      child: Text(
                        _selectedDate,
                        style: LightColors.subTextStyle,
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: SizedBox(
                  height: 35,
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: ZeeDropDown(
                    title: 'Floating Days Remark',
                    textController: _floatingDayController,
                    hintText: 'Floating Days Remark',
                    items: widget.remarkList,
                    displayFunction: (value) => value.remarkName!,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _floatingDayController.text = value.remarkName!;
                          mSelectedFloatingDay = value;
                        });
                      }
                    },
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: MaterialButton(
                    onPressed: () {
                      validateAttandance();
                    },
                    elevation: 5,
                    color: Colors.white,
                    child: MyWidget().richText(
                        'Submit',
                        LightColors.textHeaderStyle
                            .copyWith(color: kPrimaryLightColor)),
                  ),
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '--------275 Build student list ${widget.remark}. ${widget.isFloatingDay}');
    return Scaffold(
      bottomNavigationBar: Container(
        color: LightColors.kLightGray1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KidzeeWidget.getRoundedText('P', kPrimaryLightColor,
                LightColors.absentRoundedStyle, totalPresent),
            const SizedBox(
              width: 5,
            ),
            KidzeeWidget.getRoundedText('HD', LightColors.kGreen,
                LightColors.absentRoundedStyle, totalHalfDay),
            const SizedBox(
              width: 5,
            ),
            KidzeeWidget.getRoundedText('A', LightColors.kRed,
                LightColors.absentRoundedStyle, totalAbsent),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: !widget.isFloatingDay!,
        titleSpacing: 0,
        backgroundColor: widget.isFloatingDay != null && widget.isFloatingDay!
            ? Colors.black12
            : kPrimaryLightColor,
        leading: widget.isFloatingDay!
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => onBack(),
              ),
        title: ListTile(
          title: _appbar(),
          subtitle: widget.isFloatingDay!
              ? null
              : MyWidget().richText(widget.date,
                  LightColors.smallTextStyle.copyWith(color: Colors.white)),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: MaterialButton(
              onPressed: () {
                validateAttandance();
              },
              elevation: 5,
              color: Colors.white,
              child: MyWidget().richText(
                  'Submit',
                  LightColors.textHeaderStyleWhite
                      .copyWith(color: kPrimaryLightColor)),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //if(widget.isFloatingDay!)...[floatingDayheader()],
          !isLoading && _studentAttandance.isEmpty
              ? Center(
                  child:
                      Utility.emptyData(context, 'Student List not avaliable'))
              : Flexible(
                  child: ListView.builder(
                    itemCount: _studentAttandance.length,
                    itemBuilder: (context, index) {
                      StudentKesAttandance studentModel =
                          _studentAttandance[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle tap if needed
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: kPrimaryLightColor.withOpacity(0.5),
                                  width: 0.5)),
                          child: _childView(studentModel, index),
                        ),
                      );
                    },
                  ),
                )
        ],
      )),
    );
  }

  Future<void> openDatePicker(BuildContext context) async {
//     debugPrint('====openDate $year');
    DateTime initialDate = DateTime.now();

    DateTime lastDate = DateTime.now();
    DateTime firstDate = DateTime.now().subtract(Duration(days: 14));
//     debugPrint('first date ${firstDate.toString()}');
//     debugPrint('last date ${lastDate.toString()}');

    // if (lastDate.isAfter(DateTime.now())) {
    //   lastDate = DateTime.now();
    // }

    DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: kPrimaryLightColor, // Change primary color
              //accentColor: Colors.blueAccent, // Change accent color
              colorScheme: ColorScheme.light(primary: kPrimaryLightColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              // Customize additional properties as needed
            ),
            child: child!,
          );
        },
        initialDate: initialDate,
        firstDate:
            firstDate, // widget.monthId !=null && widget.monthId !=0 ? DateTime(DateTime.now().year, widget.monthId!, 1) : DateTime(DateTime.now().year, DateTime.now().month - 12, 1),
        lastDate: lastDate);

    if (pickedDate != null) {
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        if (currentDate == formattedDate) {
          isToday = true;
        } else {
          isToday = false;
        }
      });
      _selectedDate = formattedDate;
    }
  }

  Future<void> loadStudentList() async {
    _studentAttandance.clear();
    isLoading = true;
    debugPrint(
        'Student lsist ---${widget.sectionId} ${widget.userName} ${widget.date}');
    StudentKesAttandanceResponse response =
        await MyClassProvider.studentAttandance(
            widget.sectionId, widget.userName, widget.date);
    if (response.data != null) {
      setState(() {
        _studentAttandance.addAll(response.data!);
        if (widget.isFloatingDay!) {
          for (var student in _studentAttandance) {
            student.isPresent = 0;
          }
        } else {
          updateCounts();
        }
      });
    }
    isLoading = false;
  }

  void updateCounts() {
    totalPresent = 0;
    totalAbsent = 0;
    totalHalfDay = 0;
    for (var student in _studentAttandance) {
      if (student.isPresent == 1) {
        totalPresent++;
      } else if (student.isPresent == 2) {
        totalHalfDay++;
      } else if (student.isPresent == 3) {
        totalAbsent++;
      }
    }
    _selectAllStatus = '';
    if (_studentAttandance.length == totalPresent) {
      _selectAllStatus = 'Present';
    } else if (_studentAttandance.length == totalHalfDay) {
      _selectAllStatus = 'Half Day';
    } else if (_studentAttandance.length == totalAbsent) {
      _selectAllStatus = 'Absent';
    }
  }

  int totalPresent = 0;
  int totalAbsent = 0;
  int totalHalfDay = 0;

  Future<void> validateAttandance() async {
    if (widget.isFloatingDay! && _selectedDate == 'Select Date') {
      Utility.showAlertDialog(context, 'Please Select Floating Day Date');
    } else if (widget.isFloatingDay! && mSelectedFloatingDay == null) {
      Utility.showAlertDialog(context, 'Please Select Floating Day Remark');
    } else {
      List<StudentAttandanceModel> attandancelist = [];
      bool isAllAttandanceMarked = true;
      for (var item in _studentAttandance) {
        if (item.isPresent! > 0) {
          StudentAttandanceModel inputData = StudentAttandanceModel(
              studentId: item.studentId!, isPresent: item.isPresent!);
          attandancelist.add(inputData);
        } else {
          isAllAttandanceMarked = false;
          break;
        }
      }
      if (!isAllAttandanceMarked) {
        Utility.showAlertDialog(context, 'Please Mark all Student Attendance');
      } else if (attandancelist.isNotEmpty) {
        Utility.showLoaderDialog(context);
        AttendanceModel model = AttendanceModel(
            teacherId: widget.userid,
            sectionId: widget.sectionId,
            attendanceDate: widget.isFloatingDay! ? _selectedDate : widget.date,
            termId: widget.termId,
            attandance: attandancelist,
            remarks: widget.remark.isNotEmpty
                ? widget.remark
                : widget.isFloatingDay!
                    ? mSelectedFloatingDay!.remarkName!
                    : null,
            userName: widget.userName,
            BusinessId: AppFlavor == 'mlzs' ? 2 : 1);
        var response = await MyClassProvider.saveAttandacne(model);
        Utility.hideDialog(context);
        String remark =
            widget.isFloatingDay! ? '$_selectedDate,${model.remarks!}' : '';
        widget.mClickListener.onClick(LocalConstant.ACTION_RESPONSE,
            widget.isFloatingDay! ? remark : widget.date);
        Utility.showAlertDialog(context, response.toString());
      } else {
        Utility.showAlertDialog(
            context, 'Please Select the Student Attendance');
      }
    }
  }

  void updateCheckAll(String rating) {
    for (int index = 0; index < _studentAttandance.length; index++) {
      _studentAttandance[index].isPresent = rating == 'Present'
          ? 1
          : rating == 'Half Day'
              ? 2
              : rating == 'Absent'
                  ? 3
                  : 0;
    }
    updateCounts();
    setState(() {});
  }

  Widget _childView(StudentKesAttandance model, int index) {
    if (index == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: LightColors.kLightGray,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: MyWidget().richText(
                        'Student Name', LightColors.textHeaderStyle13),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Center(
                      //   child: Container(
                      //     child: MyWidget().richText(
                      //         'Attendance', LightColors.textHeaderStyle13),
                      //   ),
                      // ),
                      _buildSelectAllRatingFilters()
                    ],
                  ),
                ),
              ],
            ),
          ),
          _childRow(index),
        ],
      );
    } else {
      return _childRow(index);
    }
  }

  Widget _childRow(int index) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              child: MyWidget().richText(_studentAttandance[index].studentName!,
                  LightColors.textSmallStyle),
            ),
          ),
          Expanded(
            flex: 7,
            child: _buildRatingFilters(index),
          ),
        ],
      ),
    );
  }

  bool _getAttandanceFlag(String status, int index) {
    bool isCheck = false;
    if (status == 'Present') {
      isCheck = _studentAttandance[index].isPresent == 1 ? true : false;
    } else if (status == 'Half Day') {
      isCheck = _studentAttandance[index].isPresent == 2 ? true : false;
    } else if (status == 'Absent') {
      isCheck = _studentAttandance[index].isPresent == 3 ? true : false;
    }
    return isCheck;
  }

  Widget _buildRatingFilters(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Present', 'Half Day', 'Absent'].map((status) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _getAttandanceFlag(status, index),
              onChanged: (isChecked) {
                if (status == 'Present') {
                  _studentAttandance[index].isPresent = 1;
                } else if (status == 'Half Day') {
                  _studentAttandance[index].isPresent = 2;
                } else if (status == 'Absent') {
                  _studentAttandance[index].isPresent = 3;
                }
                updateCounts();
                setState(() {});
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSelectAllRatingFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Present', 'Half Day', 'Absent'].map((status) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              status,
              style: TextStyle(color: LightColors.kBlue),
            ),
            Checkbox(
              activeColor: Colors.grey,
              checkColor: kPrimaryLightColor,
              fillColor: WidgetStatePropertyAll(Colors.white),
              value: _selectAllStatus.contains(status),
              onChanged: (isChecked) {
                updateCheckAll(isChecked! ? status : '');
                setState(() {
                  _selectAllStatus = isChecked ? status : '';
                });
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}
