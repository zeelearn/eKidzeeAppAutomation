import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_termrequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/pentemind/module/learninggoal/facilatorsays_mind.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import '../../../../utils/theme/colors/light_colors.dart';

class FacilatorSaysScreen extends StatefulWidget {
  const FacilatorSaysScreen({super.key});

  @override
  _FacilatorSaysState createState() => _FacilatorSaysState();
}

class _FacilatorSaysState extends State<FacilatorSaysScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<FacilatorSaysModel> facilatorSaysList = [];
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
  String _chosenValue = 'Term 1';
  FacilatorSaysModel? _mModel;

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
//     debugPrint('_AnnouncementListState didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      getFacilatorSaysList();
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
      getFacilatorSaysList();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      facilatorSaysList.clear();
      isLoading = false;
      FacilatorSaysResponse response = FacilatorSaysResponse.fromJson(
        json.decode(data!),
      );
      facilatorSaysList.addAll(response.data);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_LG_FACILATOR_SAYS}';
  }

  savechildAdvancementSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getFacilatorSaysList() {
    isLoading = true;
    setState(() {});
    facilatorSaysList.clear();
    BasePentemindTermRequest request = BasePentemindTermRequest(
        Program_ID: programId, userId: uid, term: _chosenValue);
    APIService apiService = APIService();
    apiService.getFacilatorSaysList(request, token).then((value) {
      debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
//         debugPrint('value is not null $value');
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is FacilatorSaysResponse) {
//           debugPrint('in child info');
          FacilatorSaysResponse response = value;
          String json = jsonEncode(response);
          savechildAdvancementSummery(json);
          facilatorSaysList.addAll(response.data);
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
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Facilitator Says');
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Facilitator Says',
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ),
          // You can add title here
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
              getFacilatorSaysList();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (facilatorSaysList.isEmpty) {
      return Utility.emptyData(context,
          "Facilator Says List are  not available at this moment please check later");
    } else {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: DropdownButton<String>(
              focusColor: Colors.white,
              value: _chosenValue,
              //elevation: 5,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: <String>['Term 1', 'Term 2', 'Term 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              hint: const Text(
                "Select Term",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (value) {
                _chosenValue = value!;
                getFacilatorSaysList();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: facilatorSaysList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return generateListRow(facilatorSaysList[index], index);
              },
            ),
          )
        ],
      );
    }
  }

  IconData editIcon = Icons.edit;
  generateListRow(FacilatorSaysModel model, int index) {
    return Container(
        color: Colors.white,
        child: Card(
            color: Colors.white.withOpacity(0.8),
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  color: LightColors.kLightGrayM,
                  child: ListTile(
                    leading: SizedBox(
                      width: 40,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: LightColors.kLightGray,
                        child: Padding(
                          padding: const EdgeInsets.all(2), // Border radius
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/icons/pentemind/${model.ImgName}.png',
                              height: 30.0,
                              width: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: MyWidget().richText(
                        model.Mind,
                        LightColors
                            .textHeaderStyle), /*DataTable(
                        // Datatable widget that have the property columns and rows.
                          columns: getHeaders(model),
                          rows: getRows(model),
                      ),*/
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kIsWeb ? 3 : 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 1,
                    // width / height: fixed for *all* items
                    childAspectRatio: kIsWeb ? 4 : 2,
                  ),
                  itemCount: model.Observation.length,
                  itemBuilder: (BuildContext context, int index) {
                    return getTermCard(model, model.Observation[index]);
                  },
                )
              ],
            )));
  }

  getTermCard(
      FacilatorSaysModel facilatorSaysModel, FacilatorObservation model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FacilatorSaysMindFeedbackScreen(
                    term: _chosenValue,
                    facilatorSaysModel: facilatorSaysModel,
                    Observation: facilatorSaysModel.Observation,
                  )),
        ).then((value) {
          //do something after resuming screen
          getFacilatorSaysList();
        });
      },
      child: Card(
        elevation: 8,
        shadowColor: LightColors.kAbsent,
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          trailing: Container(
            width: 20.0, // this width forces the container to be a circle
            height: 24.0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                LightColors.kLightBlue,
                LightColors.kLightBlue,
                LightColors.kLightBlue
              ]),
              borderRadius: BorderRadius.circular(10),
            ), // this height forces the container to be a circle
            child: Text(
              model.RefCount.toString(),
              style: LightColors.textHeaderStyle,
              textAlign: TextAlign.center,
            ),
          ),
          title: MyWidget().richText(
              model.RefKey,
              GoogleFonts.robotoSlab(
                fontSize: 16.0,
                color: kPrimaryLightColor,
                fontWeight: FontWeight.normal,
                height: 1,
              )),
          subtitle: Column(
            children: [
              MyWidget().richText(
                  model.Remarks.isNotEmpty
                      ? model.Remarks.length > 40
                          ? '${model.Remarks.substring(0, 40)}..'
                          : model.Remarks
                      : '',
                  GoogleFonts.roboto(
                    fontSize: 12.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  )),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DataColumn> getHeaders(FacilatorSaysModel models) {
    List<DataColumn> list = [];
    for (int index = 0; index < models.Observation.length; index++) {
      list.add(
        DataColumn(
          label: Text(
            models.Observation[index].RefKey,
            style: LightColors.textSmallStyle,
          ),
        ),
      );
    }
    return list;
  }

  List<DataRow> getRows(FacilatorSaysModel models) {
    List<DataRow> list = [];
    List<DataCell> cell = [];
    for (int index = 0; index < models.Observation.length; index++) {
      cell.add(
        DataCell(Text(
          models.Observation[index].Remarks,
          style: LightColors.textSmallStyle,
        )),
      );
    }
    list.add(DataRow(cells: cell));
    return list;
  }

  setSelection(FacilatorSaysModel model) {
    _mModel = model;
  }

  updateStudentInfo() {
    /*Utility.showLoaderDialog(context);
    List<SaveWhatWentWellModel> list = [];
    list.add(SaveWhatWentWellModel(RefKey: 'Height',RefValue: _mModel!.StartTermWeight,StudentID: int.parse(_mModel!.StudentID),Term: 'Term 1'));
    list.add(SaveWhatWentWellModel(RefKey: 'Height',RefValue: _mModel!.EndTermHeight,StudentID: int.parse(_mModel!.StudentID),Term: 'Term 3'));
    list.add(SaveWhatWentWellModel(RefKey: 'Weight',RefValue: _mModel!.StartTermWeight,StudentID: int.parse(_mModel!.StudentID),Term: 'Term 1'));
    list.add(SaveWhatWentWellModel(RefKey: 'Weight',RefValue: _mModel!.EndTermWeight,StudentID: int.parse(_mModel!.StudentID),Term: 'Term 3'));
    SaveWhatWentWellRequest request = SaveWhatWentWellRequest(
        TeacherId: teacherId,
        UserId: uid,
        ProgramID: programId,
        InputType: 'CHILDINFO',
        wwwModel: list);

    APIService apiService = APIService();
    apiService.insertStudentAnecdotal(request, token).then((value) {
      debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          if (response != null) {
            if (response.success == 200) {
              Utility.showMessage(context, response.response.toString());
            }
            //getChildInfomrmationList();
          }
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      Navigator.of(context, rootNavigator: true).pop('dialog');
    });*/
  }

  @override
  void onClick(int action, value) {
//     debugPrint('onclick $action $value');
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
