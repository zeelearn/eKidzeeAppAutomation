import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/learninggoal/get_whatwentwell.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/learninggoals/whatwentwell.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import '../../../../utils/theme/colors/light_colors.dart';

class WhatWentWellScreen extends StatefulWidget {
  String type;
  WhatWentWellScreen({super.key, required this.type});

  @override
  _WhatWentWellScreenState createState() => _WhatWentWellScreenState();
}

class _WhatWentWellScreenState extends State<WhatWentWellScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<WhatWentWellResponseModel> wwwModel = [];
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  String studentId = '';
  String className = '';
  int programId = 0;
  final TextEditingController _wwwController = TextEditingController();

  WhatWentWellResponseModel? _selectedResponseModel;
  SaveWhatWentWellModel? _wwwRequestModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    loadData();
  }

  Future<void> loadData() async {
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('_AnnouncementListState didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getWhatWentWell();
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

    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getWhatWentWell();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  bool getLocalData(data) {
    bool isLoad = false;
    try {
      wwwModel.clear();
      isLoading = false;
      WhatWentWellResponse response = WhatWentWellResponse.fromJson(
        json.decode(data!),
      );
      wwwModel.addAll(response.data);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_LG_WWW}';
  }

  Future<void> savechildAdvancementSummery(String json) async {
    prefs.setString(getId(), json);
  }

  void getWhatWentWell() {
    isLoading = true;
    setState(() {});
    wwwModel.clear();
    WhatWentWellRequest request = WhatWentWellRequest(
        ProgramID: programId, InputType: widget.type, UserID: uid);

    APIService apiService = APIService();
    apiService.getWhatWentWell(request, token).then((value) {
      debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is WhatWentWellResponse) {
          WhatWentWellResponse response = value;
          String json = jsonEncode(response);
          savechildAdvancementSummery(json);
          wwwModel.addAll(response.data);
          setState(() {});
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      //Navigator.of(context).pop();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('WhatWentWell');
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            widget.type == 'EVNBTR' ? 'Even Better If' : 'What Went Well',
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ), // You can add title here
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: kPrimaryLightColor, //You can make this transparent
          elevation: 5, //No shadow
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
              getWhatWentWell();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getWWWList(),
          ),
        ));
  }

  Widget getWWWList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (wwwModel.isEmpty) {
      return Utility.emptyData(context,
          "What Went Well List are  not available at this moment please check later");
    } else {
      return ListView.builder(
        itemCount: wwwModel.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return generateWWWListRow(wwwModel[index]);
        },
      );
    }
  }

  Container generateWWWListRow(WhatWentWellResponseModel model) {
    return Container(
        color: LightColors.kLightGray,
        child: Card(
            color: LightColors.kLightGray1,
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  color: LightColors.kLightGray1,
                  child: ListTile(
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: LightColors.kLightGray,
                          child: Padding(
                            padding: const EdgeInsets.all(2), // Border radius
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                  radius: 56,
                                  backgroundColor: LightColors.kLightGray,
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        2), // Border radius
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: model.iSphoto
                                          ? GestureDetector(
                                              onTap: () {
                                                Utility.viewimage(context,
                                                    model.studentprofileURL);
                                              },
                                              child: FadeInImage(
                                                width: 30,
                                                height: 30,
                                                placeholder: AssetImage(
                                                    'assets/icons/ic_student.png'),
                                                image: NetworkImage(
                                                    model.studentprofileURL),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  debugPrint(error.toString());
                                                  return Image.asset(
                                                      'assets/icons/ic_student.png',
                                                      fit: BoxFit.fitWidth);
                                                },
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.asset(
                                              'assets/icons/ic_student.png',
                                              fit: BoxFit.fitWidth),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: MyWidget().richText(
                          model.StudentName, LightColors.textHeaderStyle)),
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kIsWeb ? 3 : 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 1,
                    // width / height: fixed for *all* items
                    childAspectRatio: kIsWeb ? 4 : 2,
                  ),
                  itemCount: model.whatwentwellModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return getTermCard(model, model.whatwentwellModel[index]);
                  },
                ),
              ],
            )));
  }

  Card getTermCard(
      WhatWentWellResponseModel model, WhatWentWellModel wwwModel) {
    return Card(
      elevation: 8,
      shadowColor: LightColors.kAbsent,
      child: ListTile(
        /*title: MyWidget()
            .richText(wwwModel.RefKey!, GoogleFonts.robotoSlab(
          fontSize: 12.0,
          color: Colors.indigo,
          fontWeight: FontWeight.normal,
          height: 1,
        )),*/
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget().richText(
                wwwModel.RefKey,
                GoogleFonts.robotoSlab(
                  fontSize: 12.0,
                  color: Colors.indigo,
                  fontWeight: FontWeight.normal,
                  height: 1,
                )),
            SizedBox(
              height: 5,
            ),
            MyWidget().richText(
                wwwModel.Term,
                GoogleFonts.roboto(
                  fontSize: 10.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  height: 1,
                )),
            SizedBox(
              height: 5,
            ),
            MyWidget().richText(
                wwwModel.RefValue.isNotEmpty
                    ? wwwModel.RefValue.length > 30
                        ? wwwModel.RefValue.substring(0, 30)
                        : wwwModel.RefValue
                    : '',
                GoogleFonts.roboto(
                  fontSize: 12.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  height: 1,
                )),
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            _wwwController.text =
                wwwModel.RefValue.isNotEmpty ? wwwModel.RefValue : '';
            setSelection(model, wwwModel);
            showMore(
                '${model.StudentName} ${wwwModel.RefKey}', wwwModel.RefValue);
          },
          child: Icon(
            Icons.edit,
            size: 20,
          ),
        ),
      ),
    );
  }

  void setSelection(
      WhatWentWellResponseModel model, WhatWentWellModel wwwModel) {
    _selectedResponseModel = model;
    _wwwRequestModel = SaveWhatWentWellModel(
        RefKey: wwwModel.RefKey,
        RefValue: wwwModel.RefValue,
        StudentID: model.StudentID,
        Term: wwwModel.Term,
        Remarks: '');
  }

  void showMore(String title, String value) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.black,
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: LightColors.textHeaderStyle),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close, color: Colors.black54),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    MyWidget().normalTextAreaField(
                        context,
                        value.isNotEmpty ? value : 'Enter text here',
                        _wwwController),
                    SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 200, // <-- Your width
                        height: 50, // <-- Your height
                        child: ElevatedButton(
                          onPressed: () {
                            if (_wwwController.text.trim() == '') {
                              Utility.showAlertDialog(context,
                                  'Please Enter feedback and continue');
                            } else {
                              Navigator.of(context).pop();
                              saveWhatWentWell();
                            }
                          },
                          // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryLightColor,
                              elevation: 12.0,
                              textStyle: const TextStyle(color: Colors.white)),
                          child: Text(
                            'Submit',
                            style: LightColors.textHeaderStyle13Selected,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ));
  }

  void saveWhatWentWell() {
    Utility.showLoaderDialog(context);
    _wwwRequestModel!.RefValue = _wwwController.text;
    List<SaveWhatWentWellModel> list = [];
    list.add(_wwwRequestModel!);
    SaveWhatWentWellRequest request = SaveWhatWentWellRequest(
        TeacherId: teacherId,
        UserId: uid,
        ProgramID: programId,
        InputType: widget.type,
        wwwModel: list);

    APIService apiService = APIService();
    apiService.saveWhatWentWell(request, token).then((value) {
      debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          if (response.success == 200) {
            Utility.showMessage(
                context,
                response.response is String
                    ? response.response
                    : response.response.response.toString());
          }
          getWhatWentWell();
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      Navigator.of(context, rootNavigator: true).pop('dialog');
    });
  }

  @override
  void onClick(int action, value) {
//     debugPrint('onclick ${action} ${value}');
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
