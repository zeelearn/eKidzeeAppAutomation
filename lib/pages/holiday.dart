import 'dart:convert';

import 'package:ekidzee/api/request/holiday_request.dart';
import 'package:ekidzee/api/response/Holidaynfo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../api/APIService.dart';
import '../api/response/academic_year.dart';
import '../helper/KidzeePref.dart';
import '../helper/LocalStrings.dart';
import '../helper/utils.dart';
import '../model/user_model.dart';
import '../widget/task_card/TextTaskInfo.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  _HolidayScreen createState() => _HolidayScreen();
}

class _HolidayScreen extends State<HolidayScreen> {
  late AcademicYearInfo academicYearInfo;
  late HolidayInfo holidayInfo;
  List<String> academicYearList = [''];
  LoginData? userProfile;
  List<HolidayInfoModel> holidayList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    userProfile = await KidzeePref().getLoginResponse();
    academicYearId = userProfile!.currentACADYear ?? 0;
    debugPrint('User Profile is ${userProfile!.toJson()}');
    loadHolidayList();
    debugPrint('api called');
  }

  Future<AcademicYearInfo?> loadHolidayList() async {
    try {
      isLoading = true;
      final uri =
          Uri.parse("https://www.ekidzee.com${LocalStrings.API_GET_HOLIDAYS}");

      final HolidayRequest request = HolidayRequest(
          AcademicYearId: academicYearId.toString(),
          FranchiseeId: userProfile!.franchiseeId == 0
              ? "0"
              : userProfile!.franchiseeId.toString(),
          UserId: userProfile!.userId.toString());
      final response = await http.post(uri,
          //headers: APIService().loginHeader(),
          body: request.toJson());

      debugPrint('➡ API: $uri');
      debugPrint('➡ Status: ${response.statusCode}');
      debugPrint('➡ Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 400) {
        final decoded = jsonDecode(response.body);

        // If API returns list directly → wrap it as { "data": [...] }
        final formattedJson = {
          "data": decoded,
        };

        HolidayInfo info = HolidayInfo.fromJson(formattedJson);
        holidayList.clear();
        holidayList.addAll(info.data);
        getSortedList();
        setState(() {
          isLoading = false;
        });
      } else {
        debugPrint("❌ AcademicYear API failed: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
        return null;
      }
    } catch (e, stack) {
      debugPrint("❌ Exception in loadHolidayList(): $e");
      // debugPrint(stack);
      setState(() {
        isLoading = false;
      });
      return null;
    }
    return null;
  }

  void loadAcademicYears() {
    debugPrint('api calling');
    isLoading = true;
    try {
      APIService apiService = APIService();
      //Utility.showLoaderDialog(context);
      apiService.getAcademicYear().then((value) {
        if (value != null) {
          isLoading = false;
          academicYearList.clear();
          academicYearInfo = value;
          academicYearList.addAll(academicYearInfo.getArray());
          //var _currentAcademicYear = academicYearInfo.data[academicYearInfo.getArray().length - 1].AcademicYear_Name;
          //debugPrint(_currentAcademicYear);
          loadHolidayList();
        } else {
          //Navigator.pop(context);
          Utility.showMessage(context, "Unable to get Academic Years");
          //debugPrint("null value");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<HolidayInfoModel> holidaysList = [];
  getSortedList() {
    holidaysList.clear();
    for (int index = 0; index < holidayList.length; index++) {
      if (radioButtonItem == 1 && holidayList[index].isStaff) {
        holidaysList.add(holidayList[index]);
      } else if (radioButtonItem == 2 && holidayList[index].isStudent) {
        holidaysList.add(holidayList[index]);
      } else {}
    }
    setState(() {});
  }

  int academicYearId = 25;

  void loadHolidayList123() async {
    debugPrint('loadHolidayList called');
    isLoading = true;
    // debugPrint(userProfile!.currentACADYear);
    academicYearId = userProfile!.currentACADYear ??
        0; //academicYearInfo.getSelectedAcademicYearId(_currentAcademicYear);
    APIService apiService = APIService();
    HolidayRequest request = HolidayRequest(
        AcademicYearId: academicYearId.toString(),
        FranchiseeId: userProfile!.franchiseeId == 0
            ? "0"
            : userProfile!.franchiseeId.toString(),
        UserId: userProfile!.userId.toString());
    debugPrint('request ${request.toJson()}');
    apiService.getHolidayList(request).then((value) {
      isLoading = false;

      if (value != null) {
        // isLoading = false;
        holidayList.clear();
        HolidayInfo model = value;
        //holidayList.addAll(holidayInfo.data);
        Map<String, Object> keys = {};
        for (int index = 0; index < model.data.length; index++) {
          // if (!keys.containsKey(model.data[index].toDate)) {
          holidayList.add(model.data[index]);
          //   keys.putIfAbsent(model.data[index].toDate, () => model.data[index]);
          // }
        }
        debugPrint('Response from holiday api is - ${model.toJson()}');
        //debugPrint(_currentAcademicYear);
        if (userProfile!.userType == 'F') getSortedList();
        setState(() {});
      }
      //Navigator.pop(context);
    });
  }

  int radioButtonItem = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: userProfile == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Academic Year  : $academicYearId",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    userProfile!.userType == 'F'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                value: radioButtonItem,
                                groupValue: 1,
                                onChanged: (val) {
                                  radioButtonItem = 1;
                                  loadHolidayList();
                                },
                              ),
                              Text(
                                'Teacher',
                                style: TextStyle(fontSize: 17.0),
                              ),
                              Radio(
                                value: radioButtonItem,
                                groupValue: 2,
                                onChanged: (val) {
                                  radioButtonItem = 2;
                                  loadHolidayList();
                                },
                              ),
                              Text(
                                'Student',
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: 0,
                          ),
                    getData(),
                  ],
                ),
        ));
  }

  Widget getData() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (holidayList.isEmpty) {
      return Utility.emptyDataSet(context);
    } else {
      return Flexible(
          child: ListView.builder(
        itemCount: userProfile!.userType == 'F'
            ? holidaysList.length
            : holidayList.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16),
        itemBuilder: (context, index) {
          return TextTaskInfo(
            page: TaskPageStatus.active,
            isCompleted: false,
            title: userProfile!.userType == 'F'
                ? holidaysList[index].description
                : holidayList[index].description,
            note: userProfile!.userType == 'F'
                ? '${holidaysList[index].fromDate} to ${holidaysList[index].toDate}'
                : '${holidayList[index].fromDate} to ${holidayList[index].toDate}',
            date: userProfile!.userType == 'F'
                ? parseDate(holidaysList[index].fromDate)
                : parseDate(holidayList[index].fromDate),
          );
        },
      ));
    }
  }

  DateTime parseDate(String value) {
    DateTime dt = DateTime.now();
    try {
      dt = DateFormat('dd MMM yyyy').parse(value);
    } catch (e) {
      e.toString();
    }
    return dt;
  }
}

class HolidayAdaptar extends StatefulWidget {
  HolidayInfoModel holidayInfoModel;
  HolidayAdaptar({super.key, required this.holidayInfoModel});

  @override
  _HolidayAdaptar createState() => _HolidayAdaptar();
}

class _HolidayAdaptar extends State<HolidayAdaptar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/icons/ic_holiday.png',
                    width: 15,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.holidayInfoModel.description,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            '${widget.holidayInfoModel.fromDate} to ${widget.holidayInfoModel.toDate}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.holidayInfoModel.holidayTypeCode,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
