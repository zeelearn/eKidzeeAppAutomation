import 'dart:io';

import 'package:ekidzee/helper/utils.dart' as util;
import 'package:ekidzee/pages/k12/domain/entities/reports/phase.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/student_list_lgreport.dart';
import 'package:ekidzee/pages/k12/presentation/pages/folders/dropdownexample.dart';
import 'package:ekidzee/pages/k12/presentation/pages/reports/studentprofile.dart';
import 'package:ekidzee/pages/k12/presentation/providers/report_provider.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/pageddatatable.dart';
import 'package:ekidzee/widget/simplewebview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saathi/core/responsive.dart';
import 'package:saathi/core/utility/utils.dart';
import 'package:saathi/widget/dropdown.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningGoalReportPage extends StatefulWidget {
  int sectionId;
  int classId;
  String userName;
  String teacherId;
  LearningGoalReportPage(
      {Key? key,
      required this.sectionId,
      required this.userName,
      required this.classId,
      required this.teacherId});

  @override
  _LearningGoalReportPageState createState() => _LearningGoalReportPageState();
}

class _LearningGoalReportPageState extends State<LearningGoalReportPage> {
  late Future<List<ReportPhase>> _phasesFuture;
  late Future<List<StudentForLGReport>> _studentList;
  TextEditingController _contPhases = TextEditingController();
  ReportPhase? _selectedPhase;
  List<StudentForLGReport> studentList = [];

  @override
  void initState() {
    super.initState();
    _phasesFuture = ReportProvider.phases(
        widget.classId.toString(), widget.sectionId.toString());
  }

  @override
  Widget build(BuildContext context) {
    double screentype = Responsive.isMobile(context)
        ? 2.4
        : Responsive.isTablet(context)
            ? 4.6
            : 4.4;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder<List<ReportPhase>>(
            future: _phasesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for data
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Show an error message if something went wrong
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.length == 0) {
                // Show a message if no data is returned
                return Center(child: Text('No Data found.'));
              } else {
                // Show the folder tree with the fetched data
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 2, right: 2, top: 10, bottom: 10),
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width / screentype,
                        child: ZeeDropDown(
                          title: 'Phase',
                          textController: _contPhases,
                          hintText: 'Select Phase',
                          items: snapshot.data!,
                          displayFunction: (value) => value.phaseName,
                          onChanged: (value) {
//                                 debugPrint('in 76 $value');
                            if (value != null) {
                              _selectedPhase = value;
                              _contPhases.text = value.phaseName;
                              loadStudentList(value.value);
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: _selectedPhase == null
                          ? util.Utility.filter(context, 'Please Select Phase')
                          : _tableview(studentList),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  getKesCertificate(StudentForLGReport student) async {
    Utility.showLoaderDialog(context);
    var _certificate = await ReportProvider.kesCertificaet(
        widget.sectionId, student.studentId, _selectedPhase!.value, 1);
//   debugPrint('response kescertification $_certificate');
    Navigator.of(context, rootNavigator: true).pop('dialog');
    if (_certificate != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => FacilatorToolReport(
                title: 'KES Certificate : ${student.studentName}',
                reportname: _selectedPhase!.value,
                htmlData: _certificate.data,
                sectionid: widget.sectionId,
                student: student,
                userName: widget.userName,
                teacherId: widget.teacherId,
              )));
    } else {
//     debugPrint('null Certificate');
    }
  }

  _updateStudentProfile(StudentForLGReport student) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => StudentProfielLGRPage(
              studentInfo: student,
              sectionId: widget.sectionId,
              reportName: _selectedPhase!.value,
              userName: widget.userName,
            )));
  }

  loadStudentList(String value) async {
//     debugPrint('student list loading');
    var _studentList = await ReportProvider.studentList(
        widget.sectionId, widget.userName, value);
//     debugPrint('student list ${_studentList}');
    studentList.clear();
    if (_studentList != null) {
      studentList.addAll(_studentList);
    }
    setState(() {});
//     debugPrint('length ${studentList.length}');
    tableController.refresh();
  }

  final tableController =
      PagedDataTableController<String, StudentForLGReport>();

  _tableview(List<StudentForLGReport> data) {
    return MyDataTable(
      headers: ['Student Name', 'Add', 'View', 'Download'],
      title: 'Zll Documents',
      tableController: tableController,
      items: data,
      displayFunction: (index, item) {
        switch (index) {
          case 0:
            return Text(
              item.studentName!,
              style: LightColors.textvSmallStyle,
              textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
            );
          case 1:
            return IconButton(
                onPressed: () {
                  _updateStudentProfile(item);
                },
                icon: Icon(Icons.add));
          case 2:
            return IconButton(
                onPressed: () {
                  getKesCertificate(item);
                },
                icon: Icon(Icons.visibility));
          case 3:
            return IconButton(
                onPressed: () {
                  _downloadCertificate(item);
                },
                icon: Icon(Icons.download));
        }
        return Text('');
      },
      onClick: (index, value) {
//         debugPrint('onclick called....');
        onFileTapped(context, value.url!);
      },
      fetch: (pageSize, sortModel, filterModel, pageToken) async {
        return getItemsForPage(int.parse(pageToken) - 1, pageSize, data);
      },
      getColoumSize: (index) {
        switch (index) {
          case 2:
          case 1:
            return const FixedColumnSize(kIsWeb ? 80 : 40);
          case 3:
            return const FixedColumnSize(kIsWeb ? 80 : 40);
        }
        return RemainingColumnSize();
      },
    );
  }

  _downloadCertificate(StudentForLGReport studentInfo) async {
//     debugPrint('download starts...');
    String url =
        'https://pdfapi.zeelearn.com/api/convert?ID=3&JsonData={"student_id":"${studentInfo.studentId}","section_id":"${widget.sectionId}","phase_id":"${_selectedPhase!.value}"}';
    if (kIsWeb) {
      await launchUrl(Uri.parse(url));
    } else {
      Directory? tempDir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();

      if (Platform.isIOS) {
        await launchUrl(Uri.parse(url));
      }
      await FlutterDownloader.enqueue(
        url: url,
        fileName:
            '${studentInfo.studentName} ${_selectedPhase!.phaseName} Report.pdf', //================File Name
        savedDir: tempDir!.path,
        showNotification: true,
        timeout: 90000,

        requiresStorageNotLow: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
    }
    Utility.showAlertDialog(context, 'Download',
        'Report Download started..please check at Notification Drawar');
  }

  List<StudentForLGReport> getItemsForPage(
      int pageIndex, int itemPerPage, List<StudentForLGReport> items) {
    final int startIndex = pageIndex * itemPerPage;
    final int endIndex = (startIndex + itemPerPage) < items.length
        ? (startIndex + itemPerPage)
        : items.length;

    return items.sublist(startIndex, endIndex);
  }
}
