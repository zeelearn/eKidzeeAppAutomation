import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/reports/get_report.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/reports/get_reports.dart';
import '../../../../api/response/pentemind/reports/logbook_response.dart';
import '../../../../constants.dart';
import 'reportdatasource.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Reportdatasource _dataSource;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  String studentId = '';
  String className = '';
  int classID = 0;
  String cName = '';
  int programId = 0;
  List<dynamic> mReport = [];
  final TextEditingController _dayController = TextEditingController();

  int? sortColumnIndex;
  bool isAscending = false;

  String _chosenValue = 'Student Learning Goal Developmental';
  List<String> options = [
    'Student Learning Goal Developmental',
    'Teacher Logbook'
  ];
  int _selectedReport = LocalConstant.ACTION_REPORT_LEARNING_GOAL;
  final controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataSource = Reportdatasource();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    loadData();
  }

  loadData() async {
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('Learning Goal Screen didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      // getReports();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) as String;
    classID = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    _dayController.text = '1';
    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getReports();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mReport.clear();
      isLoading = false;
      GetReportResponse response = GetReportResponse.fromJson(
        json.decode(data!),
      );
      mReport.addAll(response.reportModelList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${_dayController.toString()}_${LocalConstant.MENU_REPORTS}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getReports() {
    mReport.clear();
    isLoading = true;
    setState(() {});
    GetReportRequest request = GetReportRequest(
        ReportId: _chosenValue == 'Student Learning Goal Developmental'
            ? LocalConstant.ACTION_REPORT_LEARNING_GOAL
            : LocalConstant.ACTION_REPORT_LOGBOOK,
        UserID: uid,
        UserType: userType,
        EntityId: teacherId,
        ProgramID: programId.toString(),
        ClassId: classID.toString(),
        FeeType: 'Classic');
    APIService apiService = APIService();
    apiService.getReports(request, token).then((value) {
//       debugPrint('REsponse from getReport is - ${value.runtimeType}');
      isLoading = false;
      setState(() {});
      // if (value != null) {
      if (value == null) {
        Utility.showMessage(context, 'data not found');
      } else if (value is GetReportResponse) {
        GetReportResponse response = value;
        String json = jsonEncode(response);
//         debugPrint('Data is getting stored -');
        savechildSummery(json);
//         debugPrint('Data is getting stored done -');
        mReport.addAll(response.reportModelList);
        _dataSource.setData(response.reportModelList);
//         debugPrint('Data is added in list - ${response.reportModelList.length}');

        setState(() {});
      } else if (value is LogbookReportResponse) {
        LogbookReportResponse response = value;
        String json = jsonEncode(response);
        savechildSummery(json);
        mReport.addAll(response.logbookModelList);
        _dataSource.setData(response.logbookModelList);

        setState(() {});
      } else {
        Utility.showMessage(context, 'data not found');
      }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('LearningGoal:Materials');
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              getReports();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Utility.showLoader();
    } else if (mReport.isEmpty) {
      return Column(
        children: [
          getHeader(),
          Utility.emptyData(context,
              "Data are not available at this moment please check later")
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          children: [
            getHeader(),
            Expanded(child: SingleChildScrollView(child: buildDataTable())),
          ],
        ),
      );
    }
  }

  Widget buildDataTable() {
    List<String> columns = [];
    if (_selectedReport == LocalConstant.ACTION_REPORT_LEARNING_GOAL) {
      columns = [
        'Class Name',
        'Culmination',
        'Session',
        'Domain',
        'Skill',
        'Learning Goal',
        'Student name',
        'Teacher Name',
        'Rating',
        'Obv Type',
        'OnDay'
      ];
    } else if (_selectedReport == LocalConstant.ACTION_REPORT_LOGBOOK) {
      columns = [
        'Class Name',
        'Culmination',
        'Teacher Name',
        'Session',
        'Topic',
        'BoardFlow Activity',
        'Kit Material',
        'Other Material',
        'Learning Outcome',
        'Worksheet',
        'Observation',
        'Status',
        'Remark',
        'Date'
      ];
    }

    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: const CardThemeData(
            color: Colors.white), // Change the footer background color here
      ),
      child: PaginatedDataTable(
        headingRowColor: WidgetStateColor.resolveWith(
          (states) => Colors.white,
        ),
        // header: const Text('User Data'),
        rowsPerPage: 50, dataRowMinHeight: 20, dataRowMaxHeight: 20,
        availableRowsPerPage: const [10, 20, 50], headingRowHeight: 30,
        columns: getColumns(columns),
        source: _dataSource,
      ),
    )
        /* DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(mReport),
    ) */
        ;
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: LightColors.textvSmallStyle,
            ),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<dynamic> reports) => reports.map((dynamic report) {
        if (_selectedReport == LocalConstant.ACTION_REPORT_LEARNING_GOAL) {
          final cells = [
            report.ClassName,
            report.CulminationName,
            report.SessionName,
            report.DomainName,
            report.SessionName,
            report.LearningGoals,
            report.StudentName,
            report.TeacherName,
            report.Rating,
            report.ObservationType,
            report.OnDay
          ];
          return DataRow(cells: getCells(cells));
        } else {
          LogbookModel model = report;
          final cells = [
            model.ClassName,
            model.CulminationName,
            model.TeacherName,
            model.SessionName,
            model.Topic,
            model.BroadFlowActivity,
            model.KitMaterial,
            model.OtherMaterial,
            model.LearningOutcome,
            model.Worksheet,
            model.Observations,
            model.StatusCode,
            model.Remarks,
            model.CreatedDate,
          ];
          return DataRow(cells: getCells(cells));
        }
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(Text(
            '$data',
            style: LightColors.textvSmallStyle,
          )))
      .toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      mReport.sort((repot1, repot2) =>
          compareString(ascending, repot1.StudentName, repot2.StudentName));
    } else if (columnIndex == 1) {
      mReport.sort((repot1, repot2) =>
          compareString(ascending, repot1.LearningGoals, repot2.LearningGoals));
    } else if (columnIndex == 2) {
      mReport.sort((repot1, repot2) => compareString(
          ascending, '${repot1.SkillName}', '${repot2.SkillName}'));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  getHeader() {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Expanded(
            flex: 5, // 30%
            child: Text(''),
          ),
          Expanded(
              flex: 10, // 30%
              child: MyWidget()
                  .richText('Select Report', LightColors.textSmallStyle)),

          /*Expanded(
            flex: 40, // 30%
            child:MyWidget().richText(cName, LightColors.textSmallStyle),
          ),*/
          Expanded(
              flex: 50, // 30%
              child: MyWidget().getDropdownButton('Select Report', _chosenValue,
                  options, Utility.ACTION_OBSERVATION, this)),
        ],
      ),
    );
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OBSERVATION) {
      setState(() {
        _chosenValue = value;
        _selectedReport = _chosenValue == 'Student Learning Goal Developmental'
            ? LocalConstant.ACTION_REPORT_LEARNING_GOAL
            : LocalConstant.ACTION_REPORT_LOGBOOK;
        getReports();
      });
    }
  }
}
