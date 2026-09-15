import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/dailyactivity/studentlist.dart';
import 'package:ekidzee/api/request/pentemind/dailyactivity/update_workbook.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../../utils/theme/colors/light_colors.dart';
import '../../../../api/response/pentemind/dailyactivity/activityresponse.dart';
import '../../../../api/response/pentemind/dailyactivity/student_list.dart';

/// Screen for updating student remarks/observation for Daily Activity.
/// Adheres to modern coding standards with modular structure and responsive design.
class DAStudentRemarkScreen extends StatefulWidget {
  final int day;
  final String DWSType;
  final DailyActivityModel model;

  const DAStudentRemarkScreen({
    super.key,
    required this.day,
    required this.DWSType,
    required this.model,
  });

  @override
  _DAStudentRemarkScreenState createState() => _DAStudentRemarkScreenState();
}

class _DAStudentRemarkScreenState extends State<DAStudentRemarkScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // List of observation types (C, NC)
  List<FacilatorObservation> observationTypes = [];
  // Main list of students
  List<DAStudentInfo> studentList = [];
  
  bool isLoading = true;
  bool isPresentAny = false;
  bool isSelectAll = false;

  late SharedPreferences prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String className = '';
  int programId = 0;

  // State management for radio groups
  final Map<int, int> _groupValues = {};
  final List<String> _statusOptions = ['C', 'NC'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize default observation values
    observationTypes = [
      FacilatorObservation(RefKey: "C", RefCount: 0, Remarks: "", isChecked: false),
      FacilatorObservation(RefKey: "NC", RefCount: 0, Remarks: "", isChecked: false),
    ];
    
    _initializeData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Initial load of user and student information.
  Future<void> _initializeData() async {
    await _getUserAndFetchList();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchStudentList();
    }
  }

  /// Retrieves user session data and initiates student list fetching.
  Future<void> _getUserAndFetchList() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) ?? '';
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) ?? '';
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) ?? '';
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    className = prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? '';
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;

    _fetchStudentList();
  }

  /// Core logic to fetch students from API based on DWSType.
  Future<void> _fetchStudentList() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final request = DailyActivityStudListRequest(
        UserID: uid,
        ProgramId: programId.toString(),
        LogBookID: widget.model.LogBookID,
        D: widget.day,
        DWSType: widget.DWSType == 'MID' ? 'DAILY' : widget.DWSType,
      );

      final apiService = APIService();
      final response = widget.DWSType == 'MID'
          ? await apiService.getDailyMidTermActivityStudentList(request, token)
          : await apiService.getDailyActivityStudentList(request, token);

      if (response is DailyActivityStudListResponse) {
        _handleResponseSuccess(response);
      } else {
        Utility.showMessage(context, 'No data found');
      }
    } catch (e) {
      debugPrint('Error fetching students: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// Processes successful student list response and prepares UI states.
  void _handleResponseSuccess(DailyActivityStudListResponse response) {
    studentList.clear();
    _groupValues.clear();

    // Add placeholder for header row
    studentList.add(DAStudentInfo(
      StudentID: '',
      StudentName: 'Student Name',
      ParentName: '',
      MobileNo: '',
      StatusCode: '',
      IsPresent: false,
      LogBookStatusCode: '',
    ));

    studentList.addAll(response.studentList);
    _syncRadioState();
  }

  /// Synchronizes the internal radio group state with student data.
  void _syncRadioState() {
    isPresentAny = false;
    for (int i = 0; i < studentList.length; i++) {
      if (i > 0 && studentList[i].IsPresent) isPresentAny = true;

      int val = 0; // Unselected
      if (studentList[i].StatusCode == 'C') val = 1;
      if (studentList[i].StatusCode == 'NC') val = 2;
      
      _groupValues[i] = val;
    }
  }

  /// Toggles selection for all active students.
  void _toggleSelectAll(bool isChecked) {
    setState(() {
      isSelectAll = isChecked;
      for (int i = 1; i < studentList.length; i++) {
        if (studentList[i].IsPresent) {
          _groupValues[i] = isChecked ? 1 : 0;
          studentList[i].StatusCode = isChecked ? 'C' : '';
        }
      }
    });
  }

  /// Submits updated remark data to the server.
  Future<void> _handleSubmit() async {
    List<DAStudentInfo> updates = [];
    
    for (int i = 1; i < studentList.length; i++) {
      if (studentList[i].IsPresent && studentList[i].StatusCode.isNotEmpty) {
        studentList[i].DWSType = widget.DWSType;
        updates.add(studentList[i]);
      }
    }

    if (updates.isEmpty) {
      Utility.showMessageSingleButton(context, 'Please provide observations for present students', this);
      return;
    }

    Utility.showLoaderDialog(context);
    try {
      final request = UpdateDailyWorkbookRequest(
        LogBookID: widget.model.LogBookID,
        UserId: uid,
        ProgramID: programId.toString(),
        InputDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
        InputData: updates,
      );

      final response = await APIService().updateDailyWorkbook(request, token);
      
      if (response is GenericResponse && response.success == 200) {
        Navigator.pop(context, 'DONE');
        Utility.showMessage(context, response.response is String ? response.response : 'Updated successfully');
      } else {
        Utility.showMessage(context, 'Update failed');
      }
    } catch (e) {
      debugPrint('Submission error: $e');
    } finally {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Developmental Feedback');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.model.Worksheet,
          style: GoogleFonts.roboto(fontSize: 16.0, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kPrimaryLightColor,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async => _fetchStudentList(),
          child: _buildContent(),
        ),
      ),
    );
  }

  /// Builds the main content area with responsive handling.
  Widget _buildContent() {
    if (isLoading) return Utility.showLoader();
    if (studentList.isEmpty) {
      return Utility.emptyData(context, "No student data available");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildControlBar(),
              const SizedBox(height: 10),
              Expanded(child: _buildListView(isWide)),
              _buildSubmitAction(),
            ],
          ),
        );
      },
    );
  }

  /// Builds the 'Select All' control bar.
  Widget _buildControlBar() {
    return Row(
      children: [
        Checkbox(
          activeColor: kPrimaryLightColor,
          value: isSelectAll,
          onChanged: (val) => _toggleSelectAll(val ?? false),
        ),
        const Text('Mark All Completed (C)', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// Builds the responsive student list.
  Widget _buildListView(bool isWide) {
    return ListView.builder(
      itemCount: studentList.length,
      itemBuilder: (context, index) => _buildRow(index, isWide),
    );
  }

  /// Builds an individual row for a student with radio button observations.
  Widget _buildRow(int index, bool isWide) {
    final student = studentList[index];
    final isHeader = index == 0;
    
    return Container(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[200] : (student.IsPresent ? Colors.white : Colors.grey[100]),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              student.StudentName,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader ? Colors.black : (student.IsPresent ? Colors.black87 : Colors.grey),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRadioCell(index, 1, 'C', isHeader),
                _buildRadioCell(index, 2, 'NC', isHeader),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build a radio cell or header text.
  Widget _buildRadioCell(int studentIndex, int radioVal, String label, bool isHeader) {
    if (isHeader) {
      return Text(label, style: const TextStyle(fontWeight: FontWeight.bold));
    }
    
    return Radio<int>(
      value: radioVal,
      groupValue: _groupValues[studentIndex],
      activeColor: kPrimaryLightColor,
      onChanged: studentList[studentIndex].IsPresent
          ? (val) {
              setState(() {
                _groupValues[studentIndex] = val!;
                studentList[studentIndex].StatusCode = label;
              });
            }
          : null,
    );
  }

  /// Builds the sticky submission button at the bottom.
  Widget _buildSubmitAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: 150,
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isPresentAny ? kPrimaryLightColor : Colors.grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: isPresentAny ? _handleSubmit : null,
          child: const Text('SUBMIT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Utility.showMessage(context, value.toString());
    }
  }
}
