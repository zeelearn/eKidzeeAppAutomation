import 'dart:convert';

import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../../utils/theme/colors/light_colors.dart';
import '../../../../api/request/pentemind/parent_corner/elgdetail.dart';
import '../../../../api/response/pentemind/parent_corner/elg_details.dart';
import '../../../../api/response/pentemind/parent_corner/elg_response.dart';

class ElgDetails extends StatefulWidget {
  String day;
  ElgModel model;

  ElgDetails({Key? key, required this.day, required this.model})
      : super(key: key);

  @override
  _ElgDetailsScreenState createState() => _ElgDetailsScreenState();
}

class _ElgDetailsScreenState extends State<ElgDetails>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<FacilatorObservation> Observation = [];
  List<ElgDetailsModel> mList = [];
  bool isLoading = true;
  bool isPresent = false;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';

  String studentId = '';
  String className = '';
  int programId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    //debugPrint('Update ELG Details didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getElgDetails();
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
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    if (userType == 'P') {
      _dynamicChips.clear();
      _dynamicChips.add('Rarely');
      _dynamicChips.add('Sometimes');
      _dynamicChips.add('Always');
      Observation.add(FacilatorObservation(
          RefKey: "Rarely", RefCount: 1, Remarks: "", isChecked: false));
      Observation.add(FacilatorObservation(
          RefKey: "Sometimes", RefCount: 2, Remarks: "", isChecked: false));
      Observation.add(FacilatorObservation(
          RefKey: "Always", RefCount: 3, Remarks: "", isChecked: false));
    } else {
      Observation.add(FacilatorObservation(
          RefKey: "C", RefCount: 0, Remarks: "", isChecked: false));
      Observation.add(FacilatorObservation(
          RefKey: "NC", RefCount: 0, Remarks: "", isChecked: false));
    }
    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getElgDetails();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mList.clear();
      isLoading = false;
      ElgDetailsResponse response = ElgDetailsResponse.fromJson(
        json.decode(data!),
      );
      mList.addAll(response.elgDetailsList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_DAILY_ACTIVITY_UPDATE}';
  }

  savechildAdvancementSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getElgDetails() {
    isLoading = true;
    setState(() {});
    mList.clear();
    ElgDetailsRequest request = ElgDetailsRequest(
        UserID: uid,
        ProgramId: programId.toString(),
        PCID: widget.model.PCID,
        C: widget.day,
        StudentID: 0);
    APIService apiService = APIService();
    apiService.getElgDetails(request, token).then((value) {
      //debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
        //debugPrint('value is not null ${value}');
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is ElgDetailsResponse) {
          ElgDetailsResponse response = value;
          String json = jsonEncode(response);
          savechildAdvancementSummery(json);
          mList.add(ElgDetailsModel(
              StudentID: 0,
              StudentName: 'Student Name',
              ParentName: '',
              MobileNo: '',
              Title: '',
              StatusCode: '',
              OBSRN: null));
          mList.addAll(response.elgDetailsList);
          setState(() {});
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      //Navigator.of(context).pop();
      setState(() {});
    });
  }

  getImage(String imgName) {
    if (imgName == 'FocusedMind') {
      return 'assets/icons/pentemind/FocusedMind.png';
    } else if (imgName == 'AnalyticalMind') {
      return 'assets/icons/pentemind/AnalyticalMind.png';
    } else if (imgName == 'InventiveMind') {
      return 'assets/icons/pentemind/InventiveMind.png';
    } else if (imgName == 'EmpatheticMind') {
      return 'assets/icons/pentemind/EmpatheticMind.png';
    } else if (imgName == 'ConscientiousMind') {
      return 'assets/icons/pentemind/ConscientiousMind.png';
    } else {
      return 'assets/icons/image_placeholder.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('ELGDETAILS');
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: FadeInImage(
                width: 30,
                height: 30,
                placeholder: AssetImage('assets/icons/image_placeholder.png'),
                image: AssetImage(getImage(widget.model.ImgName)),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/icons/image_placeholder.png',
                      fit: BoxFit.fitWidth);
                },
                fit: BoxFit.cover,
              ),
            ),
          ],
          title: Text(
            widget.model.Title,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ),
          // You can add title here
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: kPrimaryLightColor,
          //You can make this transparent
          elevation: 5,
          //No shadow
          shadowColor: LightColors.kLightGray1,
        ),
        extendBodyBehindAppBar: true,
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
              getElgDetails();
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
    } else if (mList.length <= 0) {
      return Utility.emptyData(context,
          "Student List are  not available at this moment please check later");
    } else {
      return Container(
        margin: EdgeInsets.all(10),
        child: Card(
          color: Colors.white,
          elevation: 10,
          shadowColor: LightColors.kLightGrayM,
          child: Column(children: <Widget>[
            getContent(),
            /*generateTable(),*/
            SizedBox(
              height: 30,
            ),
            Container(
                width: 100,
                height: 40,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPresent == true
                              ? kPrimaryLightColor
                              : LightColors.kHeaderColor,
                        ),
                        onPressed: () {},
                        child: Text(
                          'Submit',
                          style: LightColors.textHeaderStyle13
                              .copyWith(color: Colors.white),
                        ))))
          ]),
        ),
      );
    }
  }

  int id = 1;

  List<String> _dynamicChips = ['Status'];
  getContent() {
    return Flexible(
        child: ListView.builder(
      itemCount: mList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index > 0) showListBottomSheet(index, mList[index]);
          },
          child: Container(
            decoration: BoxDecoration(
                color: index == 0
                    ? LightColors.kHeaderColor
                    : LightColors.kLightGrayM,
                border: Border.all(color: LightColors.kHeaderColor)),
            padding: EdgeInsets.only(left: 5, right: 5),
            child: ListTile(
                title: MyWidget().richText(
                    mList[index].StudentName, LightColors.textSmallStyle),
                trailing: Wrap(
                  spacing: 4.0,
                  runSpacing: 2.0,
                  children:
                      List<Widget>.generate(_dynamicChips.length, (int mIndex) {
                    return index == 0
                        ? Container(
                            margin: EdgeInsets.all(5),
                            child: Text(_dynamicChips[mIndex],
                                style: LightColors.textSmallStyle),
                          )
                        : MyWidget().richText(mList[index].StatusCode,
                            LightColors.textSmallStyle);
                  }),
                )),
          ),
        );
      },
    ));
  }

  Widget getObservations(List<OBSRNModel> list) {
    List<OBSRNModel> obsrnModelList = [];
    obsrnModelList.add(OBSRNModel(
        PCID: 1, TransType: '', Observation: 'Observation', StatusCode: ''));
    obsrnModelList.addAll(list);
    List<String> _observations = ['Rarely', 'Sometimes', 'Always'];
    return Flexible(
        child: ListView.builder(
      itemCount: obsrnModelList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        //debugPrint(obsrnModelList[index].StatusCode);
        return Container(
          decoration: BoxDecoration(
              color: index == 0
                  ? LightColors.kLightGray1
                  : LightColors.kLightGrayM,
              border: Border.all(color: LightColors.kHeaderColor)),
          padding: EdgeInsets.only(left: 0, right: 0),
          child: ListTile(
              title: MyWidget().richText(obsrnModelList[index].Observation,
                  LightColors.textSmallStyle),
              trailing: Wrap(
                spacing: 4.0,
                runSpacing: 2.0,
                children:
                    List<Widget>.generate(_observations.length, (int mIndex) {
                  //debugPrint(_observations[mIndex].substring(0,1));
                  return index == 0
                      ? Container(
                          margin: EdgeInsets.all(5),
                          child: Text(_observations[mIndex],
                              style: LightColors.textSmallHightliteStyle),
                        )
                      : Radio(
                          value: obsrnModelList[index].StatusCode ==
                                  _observations[mIndex].substring(0, 1)
                              ? index
                              : 999,
                          groupValue: index,
                          fillColor: WidgetStateProperty.resolveWith(
                              (states) => Colors.black26),
                          activeColor: obsrnModelList[index].StatusCode ==
                                  _observations[mIndex].substring(0, 1)
                              ? kPrimaryLightColor
                              : LightColors.kLightGrayM,
                          onChanged: (value) {});
                }),
              )),
        );
      },
    ));
  }

  showListBottomSheet(int action, ElgDetailsModel model) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),*/
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 25),
        child: Column(
          children: [
            AppBar(
              title: Text(model.StudentName),
              leading: BackButton(),
              backgroundColor: kPrimaryLightColor,
              elevation: 0,
            ),
            getObservations(model.OBSRN!)
          ],
        ),
      ) /*SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          start: 0,
          end: 0,
          bottom: 30,
          top: 25,
        ),
        child: Column(children: [
          AppBar(
            leading: BackButton(),
            backgroundColor: Colors.lightBlue,
            elevation: 0,
          ),
          getObservations(model.OBSRN!)
        ],) ,
      )*/
      ,
    );
  }

  @override
  void onClick(int action, value) {
    //debugPrint('onclick ${action} ${value}');
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utility.showMessage(context, value.toString());
    } else if (action == Utility.ACTION_OK) {
      Utility.showMessageCallback(context, 'SUCCESS', value.message, this);
    } else if (value is GenericResponse) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      GenericResponse response = value;
      if (response.success == 200) {
        Utility.showMessage(context, response.response[0].response);
      }
    }
  }
}
