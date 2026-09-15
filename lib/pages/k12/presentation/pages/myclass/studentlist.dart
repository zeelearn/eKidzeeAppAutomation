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
import 'package:ekidzee/widget/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saathi/core/theme/hex.dart';

class CogniMyClassStudentListPage extends StatefulWidget {
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

  CogniMyClassStudentListPage(
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
  _CogniMyClassStudentListPageState createState() =>
      _CogniMyClassStudentListPageState();
}

class _CogniMyClassStudentListPageState
    extends State<CogniMyClassStudentListPage> {
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

  final TextEditingController _searchController = TextEditingController();
  List<StudentKesAttandance> _filteredStudents = [];

  Color presentColor = HexColor.fromHex('#9370DB');
  Color halfDayColor = HexColor.fromHex('#FFD700');
  Color absentColor = HexColor.fromHex('#FF6347');
  Color naColor = HexColor.fromHex('#DCDCDC');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        year = DateTime.parse(widget.date).year;
      } catch (e) {}
      loadStudentList();
    });
  }

  void onBack() {
    //getObservationChanges();
    if (isupdate) {
      Navigator.of(context).pop(widget.date);
    } else {
      debugPrint('Back is getting callled - no data');
      Navigator.of(context).pop();
    }
  }

  Widget _appbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (!widget.isFloatingDay!)
          Text(
            DateFormat('dd MMM yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(widget.date)),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderControls() {
    bool isWide = Responsive.isDesktop(context) || Responsive.isTablet(context);

    // If it's not a floating day, we only show searching here
    if (!widget.isFloatingDay!) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: _buildSearchBar(),
      );
    }

    // For floating days, show Date Picker, Remark Dropdown, and Search
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildDatePickerField()),
                const SizedBox(width: 12),
                Expanded(flex: 5, child: _buildRemarkDropdown()),
                const SizedBox(width: 12),
                Expanded(flex: 4, child: _buildSearchBar()),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildDatePickerField()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildRemarkDropdown()),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSearchBar(),
              ],
            ),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () => openDatePicker(context),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: kPrimaryLightColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                  Text(
                    _selectedDate,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarkDropdown() {
    return DropDownWidget(
      title: 'Remark',
      readOnly: true,
      textController: _floatingDayController,
      hintText: 'Select Remark',
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
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _filterStudents,
      decoration: InputDecoration(
        hintText: 'Search students...',
        prefixIcon: Icon(Icons.search, color: kPrimaryLightColor),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryLightColor, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '--------275 Build student list ${widget.remark}. ${widget.isFloatingDay}');
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          color: LightColors.kLightGray1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KidzeeWidget.getRoundedText(
                  Responsive.isMobile(context) ? 'P' : 'P - Present',
                  presentColor,
                  LightColors.absentRoundedStyle,
                  totalPresent),
              const SizedBox(
                width: 5,
              ),
              KidzeeWidget.getRoundedText(
                  Responsive.isMobile(context) ? 'HD' : 'HD - Half Day',
                  halfDayColor,
                  LightColors.absentRoundedStyle,
                  totalHalfDay),
              const SizedBox(
                width: 5,
              ),
              KidzeeWidget.getRoundedText(
                  Responsive.isMobile(context) ? 'A' : 'A - Absent',
                  absentColor,
                  LightColors.absentRoundedStyle,
                  totalAbsent),
              const SizedBox(
                width: 5,
              ),
              KidzeeWidget.getRoundedText(
                  Responsive.isMobile(context) ? 'NA' : 'NA - Not Applicable',
                  naColor,
                  LightColors.absentRoundedStyle,
                  totalNA),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: kPrimaryLightColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => onBack(),
        ),
        title: _appbar(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: FilledButton(
              onPressed: validateAttandance,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kPrimaryLightColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderControls(),
            _buildBatchActionsPanel(),
            const Divider(height: 1, thickness: 1),
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_filteredStudents.isEmpty)
              Expanded(
                child: Center(
                  child: Utility.emptyData(
                      context, 'No students found matching your search'),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        Responsive.isMobile(context) ? 500 : 400,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 120,
                  ),
                  itemCount: _filteredStudents.length,
                  itemBuilder: (context, index) {
                    return _buildStudentCard(_filteredStudents[index], index);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> openDatePicker(BuildContext context) async {
//     debugPrint('====openDate $year');
    DateTime initialDate = DateTime.now();

    DateTime lastDate = DateTime.now();
    DateTime firstDate = DateTime(DateTime.now().year, 1, 1);
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
    setState(() => isLoading = true);

    StudentKesAttandanceResponse response =
        await MyClassProvider.studentAttandance(
            widget.sectionId, widget.userName, widget.date);

    if (response.data != null) {
      _studentAttandance.addAll(response.data!);
      if (widget.isFloatingDay!) {
        for (var student in _studentAttandance) {
          student.isPresent = 0;
        }
      } else {
        updateCounts();
      }
    }

    _filteredStudents = List.from(_studentAttandance);
    setState(() => isLoading = false);
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_studentAttandance);
      } else {
        _filteredStudents = _studentAttandance
            .where((s) =>
                s.studentName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _buildBatchActionsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Text(
            'Mark All:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBatchButton('P', 'Present', presentColor),
                  _buildBatchButton('HD', 'Half Day', halfDayColor),
                  _buildBatchButton('A', 'Absent', absentColor),
                  _buildBatchButton('NA', 'NA', naColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchButton(String label, String status, Color color) {
    final isSelected = _selectAllStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          updateCheckAll(isSelected ? '' : status);
          setState(() {
            _selectAllStatus = isSelected ? '' : status;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: isSelected ? color : color.withOpacity(0.5)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentKesAttandance student, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: kPrimaryLightColor.withOpacity(0.1),
                  child: Text(
                    student.studentName!.isNotEmpty
                        ? student.studentName![0]
                        : 'S',
                    style: TextStyle(
                        color: kPrimaryLightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    student.studentName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSegmentedAttendance(student),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedAttendance(StudentKesAttandance student) {
    return Row(
      children: [
        _buildStatusOption(student, 1, 'Present', presentColor),
        const SizedBox(width: 8),
        _buildStatusOption(student, 2, 'Half Day', halfDayColor),
        const SizedBox(width: 8),
        _buildStatusOption(student, 3, 'Absent', absentColor),
        const SizedBox(width: 8),
        _buildStatusOption(student, 4, 'NA', naColor),
      ],
    );
  }

  Widget _buildStatusOption(
      StudentKesAttandance student, int value, String label, Color color) {
    final isSelected = student.isPresent == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            student.isPresent = value;
            updateCounts();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: isSelected ? color : Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              label == 'Half Day'
                  ? 'HD'
                  : (label == 'Present'
                      ? 'P'
                      : (label == 'Absent' ? 'A' : 'NA')),
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateCounts() {
    totalPresent = 0;
    totalAbsent = 0;
    totalHalfDay = 0;
    totalNA = 0;
    for (var student in _studentAttandance) {
      if (student.isPresent == 1) {
        totalPresent++;
      } else if (student.isPresent == 2) {
        totalHalfDay++;
      } else if (student.isPresent == 3) {
        totalAbsent++;
      } else if (student.isPresent == 4) {
        totalNA++;
      }
    }
    _selectAllStatus = '';
    if (_studentAttandance.length == totalPresent) {
      _selectAllStatus = 'Present';
    } else if (_studentAttandance.length == totalHalfDay) {
      _selectAllStatus = 'Half Day';
    } else if (_studentAttandance.length == totalAbsent) {
      _selectAllStatus = 'Absent';
    } else if (_studentAttandance.length == totalNA) {
      _selectAllStatus = 'NA';
    }
  }

  int totalPresent = 0;
  int totalAbsent = 0;
  int totalHalfDay = 0;
  int totalNA = 0;

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
        int presentCount = attandancelist
            .where(
              (element) => element.isPresent == 1 || element.isPresent == 2,
            )
            .length;
        widget.mClickListener.onClick(
            LocalConstant.ACTION_RESPONSE,
            widget.isFloatingDay!
                ? (remark, presentCount)
                : (widget.date, presentCount));
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
                  : rating == 'NA'
                      ? 4
                      : 0;
    }
    updateCounts();
    setState(() {});
  }

  // Helper methods removed in favor of new _buildStudentCard logic
}
