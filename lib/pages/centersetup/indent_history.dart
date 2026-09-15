import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/facilatortool/lessonplan.dart';
import '../../api/ServiceHandler.dart';
import '../../api/request/bpms/franchisee_details_request.dart';
import '../../api/response/bpms/franchisee_details_response.dart';
import '../../constants.dart';
import '../../helper/LocalConstant.dart';
import '../../iface/onResponse.dart';

class IndentHistoryScreen extends StatefulWidget {
  int franchiseeid;
  IndentHistoryScreen({super.key, required this.franchiseeid});

  @override
  _IndentScreenState createState() => _IndentScreenState();
}

class _IndentScreenState extends State<IndentHistoryScreen>
    with WidgetsBindingObserver
    implements onClickListener, onResponse {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isLoading = true;
  List<FranchiseeIndentModel> indentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserInfo();
  }

  String franchiseeId = '';
  String userId = '';
  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    franchiseeId = prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
    userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    loadIndentData();
  }

  loadIndentData() async {
    GetFranchiseeDetailsRequest detailsRequest =
        GetFranchiseeDetailsRequest(franchiseeId: franchiseeId);
    ApiServiceHandler().getFranchiseeDetails(detailsRequest, this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('_Academic Screen didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      loadIndentData();
    }
  }

  /*getLessonPlanData(){
    var summary = prefs.getString(getId());
    if (true || summary == null) {
      loadData();
    }*/ /* else {
      getLocalData(summary);
    }*/ /*
  }*/

  /*getLocalData(data) {
    bool isLoad = false;
    try {
      mLessonPlanList.clear();
      isLoading = false;
      LessonPlanResponse response = LessonPlanResponse.fromJson(
        json.decode(data!),
      );
      if (response != null && response.lessonPlanModelList != null) {
        mLessonPlanList.addAll(response.lessonPlanModelList);
        if(mLessonPlanList!=null && mLessonPlanList.length>0){
          cName = mLessonPlanList[0].CName;
        }
        setState(() {});
      }
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }*/

  /* String getId() {
    return '${uid.toString()}${classId.toString()}_${LocalConstant.MENU_GUIDELINE}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }*/

  /*getGuideline() {
    mLessonPlanList.clear();
    isLoading = true;
    setState(() {});
    LessonPlanRequest request = LessonPlanRequest(ClassId: classId.toString(), D: _dayController.text.toString(), UserID: uid);
    debugPrint(request.toJson());
    APIService apiService = APIService();
    apiService.getGuideline(request, token)
        .then((value) {
      if (value != null) {
        isLoading = false;
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is LessonPlanResponse) {
          LessonPlanResponse response = value;
          if (response != null && response.lessonPlanModelList != null) {
            String json = jsonEncode(response);
            savechildSummery(json);
            mLessonPlanList.addAll(response.lessonPlanModelList);
            setState(() {});
          }
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      setState(() {});
    });
  }*/

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('FacilatorTool:LessonPlan');
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
              loadIndentData();
              return Future<void>.delayed(const Duration(seconds: 2));
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
    } else if (indentList.isEmpty) {
      return Utility.emptyData(
          context, "Data are not available at this moment please check later");
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 1),
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              itemCount: indentList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return getView(indentList[index]);
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
              flex: 20, // 30%
              child: MyWidget()
                  .richText('Indent History', LightColors.textSmallStyle)),
        ],
      ),
    );
  }

  openContent(LessonPlanModel model) {
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => goToMyPdf(worksheetUrl: model.WebUrl, title: model.ContentDescription, filename: model.ContentDescription, module: '${classId}_guldeline',),
      ),
    );*/
  }

  getView(FranchiseeIndentModel model) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: ListTile(
          title: Padding(
            padding: EdgeInsetsDirectional.all(0),
            child: Text(
              model.IndentNo,
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                color: Color(0xFF4B39EF),
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          subtitle: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                model.IndentDate,
                style: LightColors.textvSmallStyle,
              )),
          trailing: OutlinedButton(
            onPressed: () {
              //openContent(model);
            },
            child: Row(
              children: [
                Text(
                  model.IndentAmount.toString(),
                  style: TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF4B39EF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  model.IndentStatus,
                  style: TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF4B39EF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onClick(int action, value) {
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

  showListBottomSheet(int action, List<String> list) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          start: 20,
          end: 20,
          bottom: 30,
          top: 8,
        ),
        child: Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                list.length,
                (index) => Card(
                  borderOnForeground: true,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsetsDirectional.only(bottom: 10),
                    width: double.infinity,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        //updateSelection(action, list[index]);
                      },
                      child: MyWidget()
                          .richText(list[index], LightColors.textbigStyle),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onError(int action, value) {
    // TODO: implement onError
  }

  @override
  void onResponseStart() {
    // TODO: implement onResponseStart
  }

  @override
  void onSuccess(value) {
    if (value is GetFranchiseeDetailsResponse) {
      GetFranchiseeDetailsResponse response = value;
      if (response.indentList.isNotEmpty) {
        indentList.clear();
        indentList.addAll(response.indentList);
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}

class Filters {
  String label;
  Color color;
  bool isSelected;
  int index;

  Filters(this.label, this.index, this.color, this.isSelected);
}
