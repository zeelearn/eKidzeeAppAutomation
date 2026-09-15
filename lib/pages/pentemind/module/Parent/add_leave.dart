import 'package:ekidzee/api/request/pentemind/parent_corner/add_leave_request.dart';
import 'package:ekidzee/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../helper/LightColor.dart';
import '../../../../helper/utils.dart';
import '../../../../iface/onClick.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import '../../../../widget/MyWidget.dart';

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
  final TextEditingController _publishDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime minDate = DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
  DateTime maxDate = DateTime(DateTime.now().year, DateTime.now().month + 3, 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kPrimaryLightColor, //You can make this transparent
        elevation: 0.0,
      ),
      body: SafeArea(
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
                  MyWidget()
                      .richText('Subject : ', LightColors.textHeaderStyle),
                  const SizedBox(
                    height: 5,
                  ),
                  MyWidget().normalText(
                      context, 'Enter Subject here', _titleController),
                  const SizedBox(
                    height: 10,
                  ),
                  MyWidget()
                      .richText('Message : ', LightColors.textHeaderStyle),
                  const SizedBox(
                    height: 5,
                  ),
                  MyWidget().normalTextAreaField(
                      context, 'Enter Message here', _descriptionController),
                  const SizedBox(
                    height: 10,
                  ),
                  MyWidget().richText('Date : ', LightColors.textHeaderStyle),
                  const SizedBox(
                    height: 5,
                  ),
                  MyWidget().getDateTime(context, 'Date:',
                      _publishDateController, minDate, maxDate),
                  const SizedBox(
                    height: 10,
                  ),
                  MyWidget()
                      .richText('End Date : ', LightColors.textHeaderStyle),
                  const SizedBox(
                    height: 5,
                  ),
                  MyWidget().getDateTime(context, 'End Date:',
                      _endDateController, minDate, maxDate),
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
    );
  }

  Future<void> validate() async {
    bool isInternet = await Utility.isInternet();
    if (!isInternet) {
      Utility.noInternetConnection(context);
    } else if (_titleController.text == '' || _titleController.text == '') {
      Utility.alert(context, 'Alert', 'Please Enter the Subject', this);
    } else if (_descriptionController.text == '') {
      Utility.alert(context, 'Alert', 'Please Enter the Message', this);
    } else if (_publishDateController.text == '') {
      Utility.alert(context, 'Alert', 'Please Enter the date', this);
    } else {
      DateTime start = parseDateTime(_publishDateController.text);
      addLeave();
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

  void addLeave() {
    Utility.showLoaderDialog(context);
    String htmlData =
        '<p><span>Subject: </span>${_titleController.text.toString()}<br><span>Body: </span>${_descriptionController.text.toString()}<br><span>Leave Date: </span>${_publishDateController.text.toString()}</p>';
    LeaveRequestModel model = LeaveRequestModel(
        StudentID: widget.studentId,
        Subject: _titleController.text.toString(),
        Body: htmlData,
        RequestType: 'Leave',
        MsgType: 'Leave',
        Leavedate: _publishDateController.text.toString());
    List<LeaveRequestModel> list = [model];
    AddLeaveRequest request = AddLeaveRequest(
        ProgramID: widget.programId, UserId: widget.userId, InputData: list);
    //debugPrint(request.toJson());
    APIService apiService = APIService();
    apiService.addLeaveRequest(request, widget.token).then((value) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      if (value != null) {
        if (value == null) {
          Utility.alert(context, 'Alert', 'Unable to save new Leave', this);
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          //Utility.alert(context,'Alert', response.response[0].response,this);
          Utility.getConfirmationDialog(
              context, 'SUCCESS', response.response[0].response, this);
        }
      } else {
        Utility.alert(context, 'Alert', "Unable to save new Leave", this);
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
