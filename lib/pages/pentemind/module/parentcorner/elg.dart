import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/parent_corner/elg_request.dart';
import 'package:ekidzee/api/response/pentemind/parent/elg_stud_response.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/request/pentemind/parent_corner/update_elg.dart';
import '../../../../api/response/pentemind/parent_corner/elg_response.dart';
import '../../../../constants.dart';
import '../Parent/parent_elgupdate.dart';
import 'elg_details.dart';

class ElgScreen extends StatefulWidget {
  ElgScreen({Key? key}) : super(key: key);

  @override
  _ElgScreenScreenState createState() => _ElgScreenScreenState();
}

class _ElgScreenScreenState extends State<ElgScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String token = '';
  String userType = '';
  int studentId = 0;
  int programId = 0;
  List<ElgModel> mElglist = [];
  String _chosenValue = 'Select Culmination';
  List<String> options = ['Select Culmination', '1', '2', '3', '4', '5', '6'];

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
    //debugPrint('ELG  didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getElgData();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    studentId = prefs.containsKey(LocalConstant.KEY_STUDENT_ID)
        ? prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int
        : 0;
    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getElgData();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mElglist.clear();
      isLoading = false;
      ElgResponse response = ElgResponse.fromJson(
        json.decode(data!),
      );
      mElglist.addAll(response.elgList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${_chosenValue.toString()}_${LocalConstant.MENU_ELG}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getElgData() {
    mElglist.clear();
    isLoading = true;
    setState(() {});
    if (_chosenValue == 'Select Culmination') {
      isLoading = false;
      setState(() {});
    } else {
      ElgRequest request = ElgRequest(
          ProgramID: programId,
          C: _chosenValue,
          FeeType: 'Classic',
          UserID: uid,
          StudentID: studentId);
      APIService apiService = APIService();
      apiService.getElg(request, token).then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is ElgResponse) {
            ElgResponse response = value;
            String json = jsonEncode(response);
            savechildSummery(json);
            mElglist.addAll(response.elgList);
            setState(() {});
          } else {
            Utility.showMessage(context, 'data not found');
          }
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('ParentCorner:ELG');
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
              getElgData();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  getChildList() {
    debugPrint(_chosenValue);
    if (isLoading) {
      return Utility.showLoader();
    } else if (_chosenValue.trim() == 'Select Culmination' ||
        mElglist.length <= 0) {
      return Column(
        children: [
          getHeader(),
          _chosenValue.trim() == 'Select Culmination' || _chosenValue == '0'
              ? Utility.filter(context, 'Select Culmination')
              : Utility.emptyData(context,
                  "Data are not available at this moment please check later")
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 1),
        child: Column(
          children: [
            getHeader(),
            userType == 'P'
                ? Align(
                    alignment: Alignment.topRight,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParentELGUpdateScreen(
                                  model: mElglist[0],
                                  culmination: _chosenValue)),
                        ).then((value) {
                          //do something after resuming screen
                          getElgData();
                        });
                      },
                      child: Text(
                        'Observations',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF4B39EF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            Flexible(
                child: ListView.builder(
              itemCount: mElglist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return getActivityWidget(mElglist[index]);
              },
            ))
          ],
        ),
      );
    }
  }

  getHeader() {
    return Container(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 5, // 30%
            child: Text(''),
          ),
          Expanded(
              flex: 25, // 30%
              child: MyWidget()
                  .richText('Culmination', LightColors.textSmallStyle)),
          Expanded(
              flex: 50, // 30%
              child: MyWidget().getDropdownButton('Select Culmination',
                  _chosenValue, options, Utility.ACTION_OBSERVATION, this)),
        ],
      ),
    );
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

  getActivityWidget(ElgModel model) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x430F1113),
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              leading: model.ImgName.isEmpty
                  ? null
                  : GestureDetector(
                      onTap: () => showListBottomSheet(
                          Utility.ACTION_OBSERVATION, model),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: FadeInImage(
                          width: 40,
                          height: 40,
                          placeholder:
                              AssetImage('assets/icons/image_placeholder.png'),
                          image: AssetImage(getImage(model.ImgName)),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                                'assets/icons/image_placeholder.png',
                                fit: BoxFit.fitWidth);
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              title: GestureDetector(
                onTap: () =>
                    showListBottomSheet(Utility.ACTION_OBSERVATION, model),
                child: Padding(
                  padding: EdgeInsetsDirectional.all(0),
                  child: Text(
                    model.Title,
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      color: Color(0xFF4B39EF),
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              trailing: GestureDetector(
                  onTap: () {
                    //ElgDetails
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => userType == 'P'
                              ? ParentELGUpdateScreen(
                                  model: model,
                                  culmination: _chosenValue,
                                )
                              : ElgDetails(
                                  day: _chosenValue,
                                  model: model,
                                )),
                    ).then((value) {
                      //do something after resuming screen
                      getElgData();
                    });
                  },
                  child: Container(
                    /*color: model.D==null || model.D ==0 ? LightColors.kLightGray : Colors.white,*/
                    child: userType == 'P'
                        ? OutlinedButton(
                            onPressed: () {
                              if (model.D == 0) updateStatus(model);
                            },
                            child: Text(
                              model.D == 1 ? 'Completed' : 'Complete',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: model.D == 0
                                    ? Color(0xFF4B39EF)
                                    : Colors.black38,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 5, // space between two icons
                            children: <Widget>[
                              Chip(
                                backgroundColor: LightColors.kLightGrayM,
                                avatar: CircleAvatar(
                                  backgroundColor:
                                      LightColors.kLightGreenMaterial,
                                  child: Text(
                                    'C',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                label: Text(
                                    model.D == 'null'
                                        ? '0'
                                        : model.D.toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 10.0,
                                      color: LightColors.kDarkBlue,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    )),
                              ),
                              Chip(
                                backgroundColor: LightColors.kLightGrayM,
                                avatar: CircleAvatar(
                                  backgroundColor:
                                      LightColors.kLightRedMaterial,
                                  child: Text(
                                    'NC',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                label: Text(
                                    model.ND == 'null'
                                        ? '0'
                                        : model.ND.toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 10.0,
                                      color: LightColors.kDarkBlue,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    )),
                              )
                            ],
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  updateStatus(ElgModel model) {
    setState(() {
      isLoading = true;
    });

    //Utility.showLoaderDialog(context);
    OBSRNModel obrsModel = OBSRNModel(
        PCID: int.parse(model.PCID),
        TransType: model.TransType,
        Observation: '',
        StatusCode: 'C');
    UpdateElgObservationRequest request = UpdateElgObservationRequest(
        ProgramId: programId,
        Class_Id: programId,
        User_ID: uid,
        StudentID: studentId,
        OBSRN: [obrsModel]);
    APIService apiService = APIService();
    apiService.updateParentCorner(request, token).then((value) {
      isLoading = false;
      if (value != null) {
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          if (response.success == 200) {
            try {
              Utility.showMessage(
                  context,
                  response.response is String
                      ? response.response
                      : response.response.response.toString());
            } catch (e) {
              Utility.showMessage(
                  context,
                  response.response is String
                      ? response.response
                      : response.response.response.toString());
            }
            //Navigator.pop(context, 'DONE');
            getElgData();
          }
        } else {
          Utility.showMessage(context, 'data not found');
        }
        setState(() {
          isLoading = false;
        });
      }
      //Navigator.of(context, rootNavigator: true).pop('dialog');
    });
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_OBSERVATION) {
      setState(() {
        _chosenValue = value;
        getElgData();
      });
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
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

  showListBottomSheet(int action, ElgModel model) {
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
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          start: 20,
          end: 20,
          bottom: 30,
          top: 8,
        ),
        child: Wrap(
          children: [
            userType == 'P1'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(''),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParentELGUpdateScreen(
                                    model: model, culmination: _chosenValue)),
                          ).then((value) {
                            //do something after resuming screen
                            getElgData();
                          });
                        },
                        child: Text(
                          'Observations',
                          style: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF4B39EF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(''),
            Html(
              style: {
                "body": Style(
                  fontSize: FontSize(14.0),
                ),
              },
              data: model.ActivityText,
            ),
          ],
        ),
      ),
    );
  }
}
