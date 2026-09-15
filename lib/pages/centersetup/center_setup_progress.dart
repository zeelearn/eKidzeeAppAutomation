import 'dart:convert';
import 'dart:io';

import 'package:ekidzee/api/request/bpms/getTaskDetailsRequest.dart';
import 'package:ekidzee/helper/helpers.dart';
import 'package:ekidzee/pages/centersetup/communications.dart';
import 'package:ekidzee/pages/centersetup/widget/bpsu_emptyitem_widget.dart';
import 'package:ekidzee/pages/centersetup/widget/bpsu_item_widget.dart';
import 'package:ekidzee/pages/centersetup/widget/indent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/ServiceHandler.dart';
import '../../api/request/bpms/franchisee_details_request.dart';
import '../../api/request/bpms/update_task.dart';
import '../../api/response/bpms/franchisee_details_response.dart';
import '../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../api/response/bpms/update_task_response.dart';
import '../../constants.dart';
import '../../helper/LocalConstant.dart';
import '../../helper/color_constant.dart';
import '../../helper/image_constant.dart';
import '../../helper/math_utils.dart';
import '../../helper/utils.dart';
import '../../iface/onClick.dart';
import '../../iface/onResponse.dart';
import '../../utils/theme/colors/light_colors.dart';
import '../../widget/button_widget.dart';
import 'Model/ChatModel.dart';
import 'chat/IndividualPage.dart';

class CenterSetupProgress extends StatefulWidget {
  const CenterSetupProgress({super.key});

  @override
  _CenterSetupProgressState createState() => _CenterSetupProgressState();
}

class _CenterSetupProgressState extends State<CenterSetupProgress>
    with WidgetsBindingObserver
    implements onClickListener, onResponse {
  bool isLoading = false;
  String crnNumber = '';
  String displayName = '';
  String franchiseeId = '';
  String userId = '';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<TaskDetailModel> mTaskList = [];
  List<FranchiseeIndentModel> indentList = [];

  FranchiseeInfoModel? franchiseeModel;

  String _priorityValue = 'Select Priority';
  List<String> priorityOptions = ['Select Priority', 'High', 'Normal', 'LOW'];

  String _statusValue = 'Select Status';
  List<String> statusOptions = [
    'Select Status',
    'Pending',
    'In Progress',
    'Cancelled',
    'Completed'
  ];
  late onClickListener mClickListener;
  int currentPage = 0;

  final int PAGE_COMMUNICATION = 1;
  final int PAGE_PROGRESS = 2;
  final int PAGE_INDENT = 3;
  double cetuppercentage = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
//     debugPrint('init ');
    mClickListener = this;
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('didChangeAppLifecycleState==================');
    if (state == AppLifecycleState.resumed) {
      getUserInfo();
    }
  }

  updatecrn(String crn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LocalConstant.KEY_CRNNO, crn);
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    franchiseeId = prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
    //crnNumber = (prefs.getString(LocalConstant.KEY_CRNNO) as String) ?? '';
    userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
//     debugPrint('in center setup');
//     debugPrint('FRID ${franchiseeId} userId ${userId}');
    await offlineData();
    if (currentPage == 0) currentPage = PAGE_COMMUNICATION;
  }

  offlineData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('franc_${getId()}');
    var taskDetails = prefs.getString('synctask_$franchiseeId');
    if (data == null || data.isEmpty) {
//       debugPrint('Franchisee details are not found $data');
      loadTaskDetails();
    } else {
//       debugPrint('Franchisee Details found');
      getLocalData(data);
      if (taskDetails == null || taskDetails.isEmpty) {
//         debugPrint('Task Details not found');
        GetTaskDetailsRequest request =
            GetTaskDetailsRequest(projectID: crnNumber, UserId: userId);
        ApiServiceHandler().loadTaskDetails(request, this);
      } else {
//         debugPrint('Task Details found');
        //debugPrint(json.decode(taskDetails!));
        GetTaskDetailsResponseModel response =
            GetTaskDetailsResponseModel.fromJson(json.decode(taskDetails));
        loadTaskList(response);
      }
      return 0;
    }

    setState(() {});
  }

  loadTaskList(GetTaskDetailsResponseModel responseModel) {
    mTaskList.clear();
    mTaskList.addAll(responseModel.taskDetail);
    int totalCompletedTask = 0;
    int totalTask = 0;
    for (int index = 0; index < mTaskList.length; index++) {
      totalTask++;
      if (mTaskList[index].status != 3) {
        if (mTaskList[index].status == 4 || mTaskList[index].status == 5) {
          totalCompletedTask++;
        }
      }
    }
    cetuppercentage = (totalTask - totalCompletedTask) / totalTask;
    if (cetuppercentage < 100) {
      cetuppercentage = 1 - cetuppercentage;
    }
//     debugPrint('center percentage ${cetuppercentage}');
    if (cetuppercentage.isNaN) {
      cetuppercentage = 0.0;
    }
    setState(() {});
  }

  getLocalData(data) {
//     debugPrint('local data ${data}');
    try {
      GetFranchiseeDetailsResponse response =
          GetFranchiseeDetailsResponse.fromJson(json.decode(data!));
      if (response.indentList.isNotEmpty) {
        indentList.clear();
        indentList.addAll(response.indentList);
      }
      if (response.franchiseeInfoModel.isNotEmpty) {
        franchiseeModel = response.franchiseeInfoModel[0];
        displayName = response.franchiseeInfoModel[0].FranchiseeName;
        GetTaskDetailsRequest request = GetTaskDetailsRequest(
            projectID: franchiseeModel!.leadId, UserId: userId);
        ApiServiceHandler().loadTaskDetails(request, this);
      }
//       debugPrint('Franchisee Name ${franchiseeModel}');
      isLoading = false;
      setState(() {});
    } catch (e) {
      // debugPrint(e);
    }
  }

  void loadTaskDetails() async {
//     debugPrint('load Task Details $crnNumber');
    if (await Utility.isInternet()) {
      GetFranchiseeDetailsRequest detailsRequest =
          GetFranchiseeDetailsRequest(franchiseeId: franchiseeId);
      ApiServiceHandler().getFranchiseeDetails(detailsRequest, this);
    } else {
      Utility.showMessage(context, 'Please check Internet Connection..');
    }
  }

  getId() {
    return crnNumber;
  }

  saveFranchiseeData(String json) async {
    if (json != 'null' && json.isNotEmpty) {
      //debugPrint('save Fran ${json}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('franc_${getId()}', json);
      prefs.setString('sync_${getId()}', Utility.formatDate());
    }
  }

  @override
  Widget build(BuildContext context) {
    //FirebaseAnalyticsUtils().sendAnalyticsEvent('LeaveRequisition');
    //double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: getAppbar(),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: kPrimaryLightColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(150, 56), // button width and height
              child: Card(
                color: kPrimaryLightColor,
                child: Material(
                  color: kPrimaryLightColor,
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () {
                      setState(() {
                        currentPage = PAGE_COMMUNICATION;
                      });
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.call,
                          color: currentPage == PAGE_COMMUNICATION
                              ? Colors.white
                              : Colors.white24,
                        ), // icon
                        Text("Communication",
                            style: currentPage == PAGE_COMMUNICATION
                                ? LightColors.textHeaderStyle13Selected
                                : LightColors
                                    .textHeaderStyle13Unselected), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Text("Task",
                  style: currentPage == PAGE_PROGRESS
                      ? LightColors.textHeaderStyle13Selected
                      : LightColors.textHeaderStyle13Unselected),
            ),
            // text
            /*IconButton(
                icon: Icon(Icons.list),
                color: currentPage == PAGE_INDENT ? Colors.white :Colors.black26,
                onPressed: () {
                  setState(() {
                    currentPage = PAGE_INDENT;
                  });
                },
              ),*/
            SizedBox.fromSize(
              size: Size(150, 56), // button width and height
              child: Card(
                color: kPrimaryLightColor,
                child: Material(
                  color: kPrimaryLightColor,
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () {
                      setState(() {
                        currentPage = PAGE_INDENT;
                      });
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.menu,
                          color: currentPage == PAGE_INDENT
                              ? Colors.white
                              : Colors.white24,
                        ), // icon
                        Text("Indent",
                            style: currentPage == PAGE_INDENT
                                ? LightColors.textHeaderStyle13Selected
                                : LightColors
                                    .textHeaderStyle13Unselected), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryLightColor,
        focusColor: Colors.redAccent,
        tooltip: 'Increment Counter',
        onPressed: () {
          setState(() {
            currentPage = PAGE_PROGRESS;
          });
        },
        child: currentPage == PAGE_PROGRESS
            ? Image.asset(ImageConstant.imgTaskList)
            : Image.asset(
                ImageConstant.imgTaskList,
                color: Colors.black26,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: kPrimaryLightColor,
          backgroundColor: Colors.white,
          strokeWidth: 4.0,
          onRefresh: () async {
            // Replace this delay with the code to be executed during refresh
            // and return a Future when code finishs execution.
            loadTaskDetails();
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          // Pull from top to show refresh indicator.
          child: isLoading
              ? Center(
                  child: Lottie.asset('assets/json/kidzee_loader.json'),
                )
              : currentPage == PAGE_COMMUNICATION
                  ? CommunicationScreen(franchiseeId: franchiseeId)
                  : getTaskList(),
        ),
      ),
    );
  }

  AppBar getAppbar() {
    return AppBar(
      backgroundColor: kPrimaryLightColor,
      titleSpacing: 10.0,
      centerTitle: false,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            franchiseeModel != null ? franchiseeModel!.FranchiseeName : '--',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          Text(
            franchiseeModel != null ? franchiseeModel!.Address1 : '--',
            style: GoogleFonts.inter(
              fontSize: 10.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        CircularPercentIndicator(
          radius: 20.0,
          lineWidth: getSize(4),
          animation: true,
          percent: cetuppercentage,
          backgroundColor: Colors.white,
          center: RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: '${(cetuppercentage * 100).toInt()}',
                  style: TextStyle(
                    color: ColorConstant.whiteA700,
                    fontSize: getFontSize(
                      12,
                    ),
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '%',
                  style: TextStyle(
                    color: ColorConstant.whiteA700,
                    fontSize: getFontSize(
                      12,
                    ),
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            textAlign: TextAlign.left,
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: ColorConstant.whiteA700,
        ),
        InkWell(
          onTap: () {
            signOut();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/icons/ic_applogout.png',
              width: 25,
            ),
          ),
        ),
        /*PopupMenuButton<String>(
            padding: EdgeInsets.all(0),
            onSelected: (value) {
              debugPrint(value);
              Navigator.of(context).pop();
            },
            itemBuilder: (BuildContext contesxt) {
              return [

                PopupMenuItem(
                  child: InkWell(
                    onTap: (){
                      signOut();
                    },
                    child: Text("Log Out"),
                  ),
                  value: "Logout",
                ),
              ];
            },
          ),*/
      ],
    );
  }

  signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await Future.delayed(Duration(seconds: 0));
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
    //Navigator.of(context).pop();
  }

  Widget getTaskList() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
            ColorConstant.fromHex('#EDE7FF'),
            ColorConstant.fromHex('#E5EBFF'),
          ])),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: currentPage == PAGE_INDENT
                ? indentList.length
                : mTaskList.length,
            itemBuilder: (context, index) {
              if (currentPage == PAGE_INDENT) {
                return IndentViewWidget(indentList[index],
                    clickListener: mClickListener);
              } else {
                if (mTaskList[index].status == 1)
                  return CenterSeupEmptyItemWidget(
                    mTaskList[index],
                    clickListener: mClickListener,
                  );
                else
                  return CenterSeupItemWidget(
                    mTaskList[index],
                    clickListener: mClickListener,
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget getIndentHistory() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
            ColorConstant.fromHex('#EDE7FF'),
            ColorConstant.fromHex('#E5EBFF'),
          ])),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: mTaskList.length,
            itemBuilder: (context, index) {
              if (mTaskList[index].status == 1)
                return CenterSeupEmptyItemWidget(
                  mTaskList[index],
                  clickListener: mClickListener,
                );
              else
                return CenterSeupItemWidget(
                  mTaskList[index],
                  clickListener: mClickListener,
                );
            },
          ),
        ],
      ),
    );
  }

  getBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Color(0xff2398C3),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 1,
      // onTap: _bottomNavBarBloc.pickItem,
      items: [
        BottomNavigationBarItem(
          label: 'Search',
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: 'List',
          icon: Icon(Icons.view_list),
        ),
        BottomNavigationBarItem(
          label: 'Icon',
          icon: Container(
            padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: FlutterLogo(
              size: 38.0,
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: 'bookmark',
          icon: Icon(Icons.bookmark),
        ),
        BottomNavigationBarItem(
          label: 'setting',
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }

  final _startDateKey = GlobalKey<FormState>();
  final _endDateKey = GlobalKey<FormState>();
  final _priorityKey = GlobalKey<FormState>();
  final _statusKey = GlobalKey<FormState>();
  final _descriptionKey = GlobalKey<FormState>();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _descriptinoController = TextEditingController();

  int ACTION_DROPDOWN_PRIORITY = 1001;
  int ACTION_DROPDOWN_STATUS = 1002;

  Widget showBottomSheetEditTask(BuildContext context, TaskDetailModel item) {
    if (item.startDate.isNotEmpty) {
      _startDateController.text =
          Utility.parseShortDate(item.startDate.toString());
    }
    if (item.endDate.isNotEmpty) {
      _endDateController.text = Utility.parseShortDate(item.endDate.toString());
    }
    if (item.note.isNotEmpty) {
      _descriptinoController.text =
          Utility.parseShortDate(item.note.toString());
    }
    return isLoading
        ? Utility.showLoader()
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: const EdgeInsets.all(18.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: size.width,
                        child: Text(
                          'Update Task ',
                          style: LightColors.textHeaderStyle16,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getDateTimeTextField(
                            context,
                            _startDateKey,
                            _startDateController,
                            'Start Date',
                            Icons.date_range,
                            size,
                            size.width * 0.4,
                            this),
                        SizedBox(
                          width: 10,
                        ),
                        getDateTimeTextField(
                            context,
                            _endDateKey,
                            _endDateController,
                            'End Date',
                            Icons.date_range,
                            size,
                            size.width * 0.4,
                            this),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getDropdownField(
                            _priorityKey,
                            'Select Priority',
                            _priorityValue,
                            priorityOptions,
                            this,
                            size,
                            size.width * 0.4,
                            ACTION_DROPDOWN_PRIORITY),
                        SizedBox(
                          width: 10,
                        ),
                        getDropdownField(
                            _statusKey,
                            'Select Status',
                            _statusValue,
                            statusOptions,
                            this,
                            size,
                            size.width * 0.4,
                            ACTION_DROPDOWN_STATUS),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    getTextAreaField(
                        _descriptionKey,
                        _descriptinoController,
                        'Description',
                        Icons.description,
                        size,
                        size.width * 0.83),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: ButtonWidget(
                          text: 'Update',
                          backColor: false
                              ? [
                                  Colors.black,
                                  Colors.black,
                                ]
                              : const [Color(0xff92A3FD), Color(0xff9DCEFF)],
                          textColor: const [
                            Colors.white,
                            Colors.white,
                          ],
                          onPressed: () async {
//                       debugPrint('onPress calleed');
                            updateTaskDetails(item);
                            /*if (userName.trim().isEmpty) {
                        buildSnackError('Please Enter your userName',context,size,
                        );
                      }*/
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  int getStatus() {
    int status = 1;
    debugPrint(_statusValue);
    switch (_statusValue) {
      case 'Pending':
        status = 1;
        break;
      case 'In Progress':
        status = 2;
        break;
      case 'Cancelled':
        status = 3;
        break;
      case 'Completed':
        status = 4;
        break;
    }
    return status;
  }

  void updateTaskDetails(TaskDetailModel item) {
    Navigator.of(context).pop();
    UpdateBpmsTaskRequest request = UpdateBpmsTaskRequest(
        taskid: int.parse(item.id),
        status: _statusValue,
        remark: _descriptinoController.text.toString(),
        startDate:
            Utility.parseServerDate(_startDateController.text.toString()),
        endDate: Utility.parseServerDate(_endDateController.text.toString()),
        userId: userId);
    ApiServiceHandler().updateTaskDetails(request, true, this);
  }

  @override
  void onError(int action, value) {
    //Navigator.pop(context);
//     debugPrint('in error $action $value');
    isLoading = false;
    setState(() {});
  }

  @override
  void onResponseStart() {
    isLoading = true;
    setState(() {});
  }

  saveTaskDetails(String json) async {
    if (json != 'null' && json.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('synctask_$franchiseeId', json);
      setState(() {});
    }
  }

  @override
  void onSuccess(value) {
    isLoading = false;
//     debugPrint('on Success');
    if (value is int && value == 500) {
      offlineData();
    } else if (value is GetTaskDetailsResponseModel) {
      GetTaskDetailsResponseModel responseModel = value;
      String json = jsonEncode(responseModel);
      saveTaskDetails(json);
      loadTaskList(responseModel);

      /*mTaskList.clear();
      mTaskList.addAll(responseModel.taskDetail);
      int totalCompletedTask=0;
      int totalTask=0;
      for(int index=0;index<mTaskList.length;index++){
        totalTask++;
       if(mTaskList[index].status !=3){
         if(mTaskList[index].status ==4 || mTaskList[index].status ==5){
              totalCompletedTask++;
         }
       }
      }
      cetuppercentage = (totalTask - totalCompletedTask) /totalTask;
      if(cetuppercentage<100){
        cetuppercentage = 1-cetuppercentage;
      }
//       debugPrint('center percentage ${cetuppercentage}');
      if(cetuppercentage.isNaN){
        cetuppercentage =0.0;
      }
      currentPage = PAGE_COMMUNICATION;
      setState(() {

      });*/
    } else if (value is UpdateBpmsTaskResponse) {
      UpdateBpmsTaskResponse responseModel = value;
      Utility.getConfirmationDialog(
          context, 'Success', responseModel.data[0].msg, this);
      setState(() {});
    } else if (value is GetFranchiseeDetailsResponse) {
//       debugPrint('on GetFranchiseeDetailsResponse');
      GetFranchiseeDetailsResponse response = value;
      try {
        crnNumber = response.franchiseeInfoModel[0].leadId;
        updatecrn(crnNumber);
        String json = jsonEncode(response);
        saveFranchiseeData(json);
      } catch (e) {
        // debugPrint(e);
      }
      if (response.indentList.isNotEmpty) {
        indentList.clear();
        indentList.addAll(response.indentList);
      }
      if (response.franchiseeInfoModel.isNotEmpty) {
        franchiseeModel = response.franchiseeInfoModel[0];
        displayName = response.franchiseeInfoModel[0].FranchiseeName;
//         debugPrint('onsuccess----${displayName}');
      }
//       debugPrint('onsuccess----completed');
      GetTaskDetailsRequest request = GetTaskDetailsRequest(
          projectID: franchiseeModel!.leadId, UserId: userId);
      ApiServiceHandler().loadTaskDetails(request, this);
    }
    setState(() {});
  }

  showChatScreen(BuildContext context, TaskDetailModel taskModel) async {
    ChatModel model = ChatModel(
      name: taskModel.title,
      isGroup: false,
      currentMessage: taskModel.note,
      time: taskModel.startDate,
      icon: "person.svg",
      id: taskModel.dependentTaskId,
      status: taskModel.statusname,
    );
    /*Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            IndividualPage(taskModel:taskModel)));*/
//     debugPrint('showing chat screen');
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return IndividualPage(taskModel: taskModel, clickListener: this);
    }));
//     debugPrint('result -----------------');
    if (result is TaskDetailModel) {
//       debugPrint('Response received TaskDetailModel');
      TaskDetailModel resultModel = result;
//       debugPrint('Response received $result');
      for (int index = 0; index < mTaskList.length; index++) {
        if (mTaskList[index].mtaskId == resultModel.parentTaskId) {
          mTaskList[index].statusname = resultModel.statusname;
          if (mTaskList[index].statusname == 'BP Completed') {
            mTaskList[index].status = 4;
          } else {
            mTaskList[index].status = resultModel.status;
          }
//           debugPrint('status ${resultModel.statusname}');
        }
      }
      loadTaskDetails();
    }
  }

  @override
  void onClick(int action, value) {
//     debugPrint('onclick centersetups $action $value');
    if (action == 0 || action == 1212) {
      loadTaskDetails();
    } else if (action == ACTION_DROPDOWN_PRIORITY) {
      _priorityValue = value;
    } else if (action == ACTION_DROPDOWN_STATUS) {
      _statusValue = value;
    } else if (action == 111) {
//       debugPrint('show chat screennnn');
      TaskDetailModel taskModel = value;
      //updateTaskDetails(response);
      showChatScreen(context, taskModel);
      /*showModalBottomSheet(
          backgroundColor:
          Colors.transparent,
          context: context,
          builder: (builder) =>
              showBottomSheetEditTask(context,model));*/
    }
  }
}
