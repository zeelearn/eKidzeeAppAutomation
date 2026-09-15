import 'package:ekidzee/api/request/add_remark.dart';
import 'package:ekidzee/api/request/diary_request.dart';
import 'package:ekidzee/model/parent_info.dart';
import 'package:ekidzee/ui/commonwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/APIService.dart';
import '../../api/response/diary_remark_response.dart';
import '../../api/response/diary_response.dart';
import '../../helper/DatabaseHelper.dart';
import '../../helper/LightColor.dart';
import '../../helper/LocalConstant.dart';
import '../../helper/utils.dart';
import '../../ui/theme.dart';

class StudentDiaryScreen extends StatefulWidget {
  StudentDiaryScreen({Key? key}) : super(key: key);

  @override
  _StudentDiaryScreen createState() => _StudentDiaryScreen();
}

class _StudentDiaryScreen extends State<StudentDiaryScreen> {
  String userId = '';
  String Parent_ID = '';
  String userType = '';
  int pagenumber = 1;

  List<DiaryInfo> _diaryList = [];

  @override
  void initState() {
    super.initState();
    _diaryList.add(DiaryInfo(
        diaryID: 87476,
        diaryTitle: '-',
        diaryMessage: '--',
        diaryDate: '-',
        diaryCreatedBy: '-',
        teacherName: '-',
        diaryStudentID: 2339201,
        studentID: 1564814,
        studentName: '-',
        remark: '-',
        remarkDate: '-',
        isRemarked: true));
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => getUserInfo());
    } catch (e) {
      //debugPrint(e.toString());
    }
  }

  Future<void> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(LocalConstant.KEY_UID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    ParentInfo parentInfo = await DBHelper().getParentInfo() as ParentInfo;
    //userId = '1664175';
    Parent_ID = userId; //parentInfo.parentID.toInt().toString();
    //debugPrint('uid is ${userId}');
    loadStudentDiary();
  }

  void loadStudentDiary() {
    Utility.showLoaderDialog(context);
    APIService apiService = APIService();
    StudentDiaryRequest request = StudentDiaryRequest(
        Parent_ID: Parent_ID, PageSize: '15', PageIndex: pagenumber.toString());
    //debugPrint(request.toJson());
    apiService.getStudentDiary(request).then((value) {
      if (value != null) {
        if (pagenumber == 1) _diaryList.clear();
        DiaryResponse response = value;
        _diaryList.addAll(response.data);
        setState(() {});
      } else {
        Utility.showMessage(
            context, "Data not Available, please try again later");
      }
      Navigator.pop(context);
    });
  }

  void saveRemark(String studentId, String parentId, remark) {
    Utility.showLoaderDialog(context);
    APIService apiService = APIService();
    AddDiaryRemarkRequest request = AddDiaryRemarkRequest(
        DiaryStudent_ID: studentId, Parent_ID: parentId, Remark_Text: remark);
    apiService.addDiaryRemark(request).then((value) {
      Navigator.pop(context);
      //Navigator.pop(context);
      if (value != null) {
        if (pagenumber == 1) _diaryList.clear();
        DiaryRemarkResponse response = value;
        Navigator.pop(context);
        Utility.showMessage(context, response.result);
        setState(() {});
      } else {
        Utility.showMessage(
            context, "Unable to save remark please try again later.");
        ////debugPrint("null value");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              /*_header(context),*/
              CommonWidget.header('Student Diary'),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      getData(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          pagenumber++;
          loadStudentDiary();
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.more),
      ),
    );
  }

  clipClick(String actionString) {
    if (actionString == 'DATE_SEL') {
      /*_onPressed(context: context);*/
    }
  }

  Widget getData() {
    if (_diaryList.length > 0) {
      return ListView.builder(
        itemCount: _diaryList.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _DiaryInfo(context, _diaryList[index],
              _decorationContainerA(Colors.redAccent, -110, -85),
              background: LightColor.seeBlue);
        },
      );
    } else {
      return Utility.emptyDataSet(context);
    }
  }

  Widget _decorationContainerA(Color primaryColor, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: LightColor.darkseeBlue,
          ),
        ),
        _smallContainer(LightColor.yellow, 40, 20),
        Positioned(
          top: -30,
          right: -10,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        ),
        Positioned(
          top: 110,
          right: -50,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: LightColor.darkseeBlue,
            child:
                CircleAvatar(radius: 40, backgroundColor: LightColor.seeBlue),
          ),
        ),
      ],
    );
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  Positioned _smallContainer(Color primaryColor, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primaryColor.withAlpha(255),
        ));
  }

  Widget _DiaryInfo(BuildContext context, DiaryInfo model, Widget decoration,
      {required Color background}) {
    return Card(
        color: Colors.white,
        elevation: 8,
        child: GestureDetector(
          onTap: () {
            _show(context, model);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Text(model.diaryTitle,
                                style: const TextStyle(
                                    color: LightColor.purple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('Remark : ${model.remark.toString()}',
                              style: const TextStyle(
                                color: LightColor.grey,
                                fontSize: 14,
                              )),
                          const SizedBox(width: 10)
                        ],
                      ),
                    ),
                    Text('Teacher Name : ${model.teacherName.toString()}',
                        style: AppTheme.h6Style.copyWith(
                          fontSize: 12,
                          color: LightColor.grey,
                        )),
                    const SizedBox(height: 15),
                    Text(model.diaryMessage,
                        style: AppTheme.h6Style.copyWith(
                            fontSize: 12, color: LightColor.extraDarkPurple)),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Text('Event Date : ',
                            style: AppTheme.h6Style.copyWith(
                                fontSize: 12,
                                color: LightColor.extraDarkPurple)),
                        _chip('', model.diaryDate, LightColor.darkOrange,
                            height: 5),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
  }

  Widget _card(BuildContext context,
      {Color primaryColor = Colors.redAccent, required Widget backWidget}) {
    return Card(
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: backWidget,
        ),
      ),
    );
  }

  Widget _chip(String actionString, String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return GestureDetector(
      //onTap: clipClick(actionString),
      onTap: () => clipClick(actionString),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: textColor.withAlpha(isPrimaryCard ? 150 : 50),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
        ),
      ),
    );
  }

  void _show(BuildContext ctx, DiaryInfo model) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  // content padding
                  child: TextFormField(
                    cursorColor: Theme.of(context).cardColor,
                    initialValue: '',
                    maxLength: 20,
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onFieldSubmitted: (remark) {
                      saveRemark(
                          model.diaryStudentID.toString(), Parent_ID, remark);
                      //debugPrint('terms clickeed ${remark}');
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.mark_chat_read),
                      labelText: 'Enter Remark',
                      counterText: "",
                      labelStyle: TextStyle(
                        color: Color(0xFF6200EE),
                      ),
                      helperText: 'Helper text',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6200EE)),
                      ),
                    ),
                  )),
            ),
          );
          // From with TextField inside
        });

    /*showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.amber,
        context: ctx,
        isScrollControlled: true,
        builder: (ctx) => Padding(padding: MediaQuery.of(context).viewInsets,
        child: Container(
          width: 250,
          height: 250,
          color: Colors.white54,
          alignment: Alignment.center,
          child: TextFormField(

            cursorColor: Theme.of(context).cursorColor,
            initialValue: 'Input text',
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.favorite),
              labelText: 'Label text',
              labelStyle: TextStyle(
                color: Color(0xFF6200EE),
              ),
              helperText: 'Helper text',
              suffixIcon: Icon(
                Icons.check_circle,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),
            ),
          ),
        ),)
      );*/
  }
}
