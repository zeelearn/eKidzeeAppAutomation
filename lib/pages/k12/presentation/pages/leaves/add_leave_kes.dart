import 'dart:developer';

import 'package:ekidzee/constants.dart';
import 'package:ekidzee/pages/k12/presentation/pages/leaves/add_leave_response.dart'
    as addLeaveResponse;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../helper/LightColor.dart';
import '../../../../../helper/LocalConstant.dart';
import '../../../../../helper/utils.dart';
import '../../../../../iface/onClick.dart';
import '../../../../../utils/theme/colors/light_colors.dart';
import '../../../../../widget/MyWidget.dart';
import 'add_leave_request_kes.dart';

class AddNewLeave extends StatefulWidget {
  String token;
  String programId;
  String userId;
  int studentId;

  AddNewLeave(
      {super.key,
      required this.userId,
      required this.programId,
      required this.studentId,
      required this.token});

  @override
  _AddNewLeaveScreen createState() => _AddNewLeaveScreen();
}

class _AddNewLeaveScreen extends State<AddNewLeave> implements onClickListener {
  final TextEditingController _publishDateController = TextEditingController(
      text: DateFormat('dd-MMM-yyyy').format(DateTime.now()));
  final TextEditingController _publishToDateController =
      TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime(DateTime.now().year, DateTime.now().month + 3, 1);
  String _curriculamType = '';
  String userName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(LocalConstant.KEY_USER_NAME) as String;
    _curriculamType = prefs
            .containsKey(LocalConstant.KEY_CURRENT_CURRICULAMTYPE)
        ? prefs.getString(LocalConstant.KEY_CURRENT_CURRICULAMTYPE) as String
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: LightColors.kLightGray,
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Add New Leave',
          style: LightColors.textStyle.copyWith(color: Colors.white),
        ),

        backgroundColor: kPrimaryLightColor, //You can make this transparent
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyWidget().richText(
                            'Subject : ', LightColors.textHeaderStyle),
                        const SizedBox(
                          height: 5,
                        ),
                        MyWidget().normalTextAreaField(
                            context, 'Enter Subject here', _titleController,
                            maxLength: 50),
                        const SizedBox(
                          height: 10,
                        ),
                        MyWidget().richText(
                            'Message : ', LightColors.textHeaderStyle),
                        const SizedBox(
                          height: 5,
                        ),
                        MyWidget().normalTextAreaField(context,
                            'Enter Message here', _descriptionController,
                            maxLength: 250),
                        const SizedBox(
                          height: 10,
                        ),
                        MyWidget()
                            .richText('Date : ', LightColors.textHeaderStyle),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: MyWidget().getDateTime(
                                    context,
                                    'From Date:',
                                    _publishDateController,
                                    minDate,
                                    maxDate,
                                    onDateSelected: () => setState(() {
                                      _publishToDateController.text = '';
                                    }),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: MyWidget().getDateTime(
                                    context,
                                    'To Date:',
                                    _publishToDateController,
                                    _publishDateController.text.isNotEmpty
                                        ? DateFormat('dd-MMM-yyyy')
                                            .parse(_publishDateController.text)
                                        : minDate,
                                    maxDate,
                                    onDateSelected: () {},
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {
                            validate();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: size.height / 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: kPrimaryLightColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: LightColor.seeBlue,
                                  offset: Offset(0, 5.0),
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Text(
                              'Submit',
                              style: LightColors.textbuttonStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validate() async {
    FocusScope.of(context).unfocus();
    bool isInternet = await Utility.isInternet();
    if (!isInternet) {
      Utility.noInternetConnection(context);
    } else if (_titleController.text == '' || _titleController.text == '') {
      Utility.alert(context, 'Alert', 'Please Enter the Subject', null);
    } else if (_descriptionController.text == '') {
      Utility.alert(context, 'Alert', 'Please Enter the Message', null);
    } else if (_publishDateController.text == '') {
      Utility.alert(context, 'Alert', 'Please Enter the date', null);
    } else if (_publishToDateController.text == '') {
      Utility.alert(context, 'Alert', 'Please Enter the To date', null);
    } else {
      DateTime start = parseDateTime(_publishDateController.text);

      addKESLeave();
    }
  }

  DateTime parseDateTime(String value) {
    DateTime dt = DateTime.now();
    try {
      dt = DateFormat('dd-MMM-yyyy').parse(value);
    } catch (e) {
      e.toString();
    }
    return dt;
  }

  void addKESLeave() {
    Utility.showLoaderDialog(context);
    KESLeaveRequest request = KESLeaveRequest(
        body: _descriptionController.text.toString(),
        subject: _titleController.text.toString(),
        fromdate: _publishDateController.text.toString(),
        todate: _publishToDateController.text.toString(),
        sectionId: Utility.toInt(widget.programId),
        username: userName);

    APIService apiService = APIService();
    apiService.addKESLeaveRequest(request, widget.token).then((value) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      log('Add Kes levae is - ${value.runtimeType}');
      if (value != null) {
        if (value is addLeaveResponse.AddLeaveResponse) {
          addLeaveResponse.AddLeaveResponse response = value;
          if (response.data?.msg ==
              'Leave already exists between given dates') {
            Utility.alert(context, 'Alert', response.data?.msg ?? '', null);
          } else {
            //Utility.alert(context,'Alert', response.response[0].response,this);
            Utility.showKESDialog(
                context, 'SUCCESS', response.data!.msg!, this);
          }
        } else {
          Utility.alert(context, 'Alert', 'Unable to save new Leave', null);
        }
      } else {
        Utility.alert(context, 'Alert', "Unable to save new Leave", null);
        //debugPrint("null value");
      }
    });
  }

  DateTime parseDate(String value) {
    DateTime dt = DateTime.now();
    //2022-07-18T00:00:00
    try {
      dt = DateFormat('yyyy-MM-dd').parse(value);
      //debugPrint('asasdi   ' + dt.day.toString());
    } catch (e) {
      e.toString();
    }
    return dt;
  }

  String getParsedShortDate(String value) {
    DateTime dateTime = parseDate(value);
    return DateFormat("MMM-dd").format(dateTime);
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OK) {
      //Navigator.of(context, rootNavigator: true).pop();
      //debugPrint('action close');
      Navigator.pop(context, [1]);
    } else {
      Navigator.pop(context, 'DONE');
    }
  }
}
