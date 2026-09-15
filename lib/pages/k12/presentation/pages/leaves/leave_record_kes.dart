import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/myclass/leave_approve.dart';
import 'package:ekidzee/api/request/pentemind/myclass/leave_records.dart';
import 'package:ekidzee/api/response/pentemind/myclass/leave_records_kes.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart' as util;
import 'package:ekidzee/pages/k12/presentation/pages/leaves/add_leave_kes.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
// import '../../../../../api/response/pentemind/GenericResponse_kes.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../../iface/onClick.dart';
import '../../../core/utils.dart';

class LeaveRecordScreen extends StatefulWidget {
  const LeaveRecordScreen({super.key});

  @override
  _LeaveRecordScreenState createState() => _LeaveRecordScreenState();
}

class _LeaveRecordScreenState extends State<LeaveRecordScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String userName = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  int programId = 0;
  int studentId = 0;
  List<LeaveInfoModel> mLeaveAllInfoList = [];
  List<LeaveInfoModel> mLeaveAckInfoList = [];
  List<LeaveInfoModel> mLeaveOriginalInfoList = [];

  final searchTextEditingController = TextEditingController();

  int? selectedRadio;
  bool selectAll = false;

  late TabController _tabController;

  final _tabs = [
    const Tab(text: 'Approved'),
    const Tab(text: 'Pending to Acknowledge'),
  ];

  String _curriculamType = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  bool canAcknowledge(String userType) {
    return userType.toLowerCase() == 'cc' ||
            userType.toLowerCase() == 'teach' ||
            userType.toLowerCase() == 'cm'
        ? true
        : false;
  }

  void buildAckList() {
    for (var element in mLeaveOriginalInfoList) {
      if (element.ApprovalStatus.toLowerCase() == 'pending') {
        mLeaveAckInfoList.add(element);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //debugPrint('LeaveRecords Screen didChangeAppLifecycleState $state ');
    //debugPrint('LeaveRecords Screen didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      //getLeaveRecords();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    userName = prefs.getString(LocalConstant.KEY_USER_NAME) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    _curriculamType = prefs
            .containsKey(LocalConstant.KEY_CURRENT_CURRICULAMTYPE)
        ? prefs.getString(LocalConstant.KEY_CURRENT_CURRICULAMTYPE) as String
        : '';
    // debugPrint('_curriculamType is $_curriculamType');
    // debugPrint('_curriculamType is $_curriculamType');
    try {
      studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
    } catch (e) {}

    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    if (canAcknowledge(userType)) {
      _tabController = TabController(length: _tabs.length, vsync: this);
    }

    var childAdvancementSummery = prefs.getString(getId());
    if (true || childAdvancementSummery == null) {
      getLeaveRecords();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  bool getLocalData(data) {
    bool isLoad = false;
    try {
      mLeaveAllInfoList.clear();
      isLoading = false;
      LeaveRecordResponse response = LeaveRecordResponse.fromJson(
        json.decode(data!),
      );
      mLeaveAllInfoList.addAll(response.data[0].Leave);

      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}__${LocalConstant.MENU_MYCLASS_LEAVE_RECORD}';
  }

  Future<void> savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  void getLeaveRecords() {
//     debugPrint('get Leave Record');
    mLeaveAllInfoList.clear();
    mLeaveAckInfoList.clear();
    mLeaveOriginalInfoList.clear();
    isLoading = true;
    setState(() {});

    if (_curriculamType.isNotEmpty && _curriculamType.toLowerCase() == 'k12' ||
        _curriculamType.toLowerCase() == 'kes') {
      LeaveRecordRequest request = LeaveRecordRequest(
          UserId: /* 'P2482789' */ userName,
          ProgramId: /* '101472' */ programId.toString(),
          TeacherId: teacherId,
          StudentID: studentId.toString());
      APIService apiService = APIService();
      apiService.getKESLeaveRecords(request, token).then((value) {
        isLoading = false;
        if (value != null) {
          KESLeaveResponse response = value;
          if (response.data != null && response.data!.isNotEmpty) if (response
                      .data !=
                  null &&
              response.data!.isNotEmpty)
            for (var leave in response.data!) {
              LeaveInfoModel leaveInfoModel = LeaveInfoModel(
                  ID: leave.leaveRecordId!,
                  Subject: '',
                  Body: leave.body!,
                  Date: leave.createdDate!,
                  ApprovalStatus: leave.leaveStatus!);

              mLeaveAllInfoList.add(leaveInfoModel);
              mLeaveOriginalInfoList.add(leaveInfoModel);
            }
        }
        mLeaveAllInfoList.sort((a, b) => b.ID.compareTo(a.ID));
        mLeaveOriginalInfoList.sort((a, b) => b.ID.compareTo(a.ID));
        buildAckList();
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('MyClass:LeaveRecord');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: false,
          title: Text('Leave Record', style: LightColors.textHeaderStyleWhite),
          actions: [
            userType == 'P'
                ? Container(
                    margin: EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewLeave(
                              token: token,
                              userId: uid,
                              programId: programId.toString(),
                              studentId: studentId,
                            ),
                          ),
                        ).then((value) {
                          //do something after resuming screen
                          getLeaveRecords();
                        });
                      },
                      child: Text(
                        "Add New Leave",
                        style: LightColors.subTextStyle,
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              getLeaveRecords();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  Widget getChildList() {
    if (isLoading) {
      return Utility.showKESLoader();
    } else if (mLeaveOriginalInfoList.isEmpty) {
      return Utility.emptyData(
          context, "Data are not available at this moment please check later");
    } else {
      return Container(
        color: Colors.white,
        // padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (canAcknowledge(userType)) ...[
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: TabBar(
                        isScrollable: true,
                        // tabAlignment: TabAlignment.fill,
                        controller: _tabController,
                        tabs: _tabs,

                        dividerColor: Colors.blueGrey,
                        labelColor: Utils.tabselectedColor,
                        indicatorColor: Utils.tabindicatorColor,
                        unselectedLabelColor: Utils.tabunselectedColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          leaveListViewWidget('pend'),
                          leaveListViewWidget('ack')
                        ],
                      ),
                    )
                  ],
                ),
              )
            ] else ...[
              SizedBox(
                height: 30,
              ),
              Expanded(child: leaveListViewWidget('all')),
            ],
            SizedBox(
              height: 40,
            )
          ],
        ),
      );
    }
  }

  void performSearch(String text, bool forAll) {
    if (forAll) {
      mLeaveAllInfoList.clear();
      mLeaveAllInfoList = mLeaveOriginalInfoList
          .where(
            (element) =>
                element.Body.toLowerCase().contains(text.toLowerCase()) ||
                element.Subject.toLowerCase().contains(text.toLowerCase()) ||
                element.ApprovalStatus.toLowerCase()
                    .contains(text.toLowerCase()),
          )
          .toList();
      setState(() {});
    } else {
      mLeaveAckInfoList.clear();
      mLeaveAckInfoList = mLeaveOriginalInfoList
          .where(
            (element) =>
                element.ApprovalStatus.toLowerCase() == 'pending' &&
                (element.Body.toLowerCase().contains(text.toLowerCase()) ||
                    element.Subject.toLowerCase()
                        .contains(text.toLowerCase()) ||
                    element.ApprovalStatus.toLowerCase()
                        .contains(text.toLowerCase())),
          )
          .toList();
      setState(() {});
    }
  }

  void handleSelectAll(bool? value) {
    if (value != null) {
      setState(() {
        selectAll = value;
        // mLeaveAckInfoList.every(
        //   (element) => element.ApprovalStatus = 'Approved',
        // );
        if (value) {
          for (var element in mLeaveAckInfoList) {
            element.ApprovalStatus = 'Approved';
          }
          /*  for (var element in mLeaveAllInfoList) {
            element.ApprovalStatus = 'Approved';
          } */
        } else {
          for (var element in mLeaveAckInfoList) {
            element.ApprovalStatus = 'Pending';
          }
          /* for (var element in mLeaveAllInfoList) {
            element.ApprovalStatus = 'Pending';
          } */
        }
      });
    } else {
      setState(() {
        selectAll = false;
      });
    }
  }

  Widget leaveListViewWidget(String type) {
    var forAll = type == 'all' || type == 'pend';
    if (type == 'pend') {
      mLeaveAllInfoList.removeWhere(
          (element) => element.ApprovalStatus.toLowerCase() == 'pending');
    }

    final currentList = forAll ? mLeaveAllInfoList : mLeaveAckInfoList;

    return LayoutBuilder(builder: (context, constraints) {
      bool isWide = constraints.maxWidth > 700;
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: isWide
                ? Row(
                    children: [
                      Expanded(child: _buildSearchField(forAll)),
                      if (!forAll && mLeaveAckInfoList.isNotEmpty) ...[
                        SizedBox(width: 16),
                        SizedBox(width: 200, child: _buildSelectAllTile()),
                        SizedBox(width: 16),
                        _buildAcknowledgeButton(),
                      ]
                    ],
                  )
                : Column(
                    children: [
                      _buildSearchField(forAll),
                      if (!forAll && mLeaveAckInfoList.isNotEmpty) ...[
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildSelectAllTile()),
                            SizedBox(width: 10),
                            _buildAcknowledgeButton(),
                          ],
                        ),
                      ]
                    ],
                  ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: currentList.isEmpty
                ? Utility.emptyData(
                    context,
                    searchTextEditingController.text.trim().isNotEmpty
                        ? 'No Matching Data found.'
                        : forAll
                            ? "Data are not available at this moment please check later"
                            : 'No Leave Record for Acknowledge.')
                : isWide
                    ? GridView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 1200 ? 3 : 2,
                          childAspectRatio: 1.6,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: currentList.length,
                        itemBuilder: (context, index) {
                          return getLeaveRecordWidget(
                              currentList[index], !forAll, index,
                              isGrid: true);
                        },
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 16),
                        itemCount: currentList.length,
                        itemBuilder: (context, index) {
                          return getLeaveRecordWidget(
                              currentList[index], !forAll, index,
                              isGrid: false);
                        },
                      ),
          ),
        ],
      );
    });
  }

  Widget _buildSearchField(bool forAll) {
    return TextField(
      controller: searchTextEditingController,
      onSubmitted: (value) {
        if (value.trim().isEmpty) {
          Utility.showAlertDialog(context, 'TextBox can not be empty.');
          return;
        }
        performSearch(value.trim(), forAll);
      },
      onChanged: (value) {
        if (value.isEmpty || value.length > 2) {
          performSearch(value.trim(), forAll);
        }
      },
      decoration: InputDecoration(
        hintText: 'Search by name, subject, message',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _buildSelectAllTile() {
    return CheckboxListTile(
      title: Text(
        'Select All',
        style:
            LightColors.menuStyle.copyWith(color: Colors.black, fontSize: 14),
      ),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: selectAll,
      onChanged: handleSelectAll,
      dense: true,
    );
  }

  Widget _buildAcknowledgeButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryLightColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      onPressed: () {
        String value = mLeaveAckInfoList
            .where(
              (element) => element.ApprovalStatus.toLowerCase() == 'approved',
            )
            .map(
              (e) => e.ID,
            )
            .toList()
            .join(',');

        if (value.isNotEmpty) {
          Utility.showConfirmationDialog(
            context,
            'Warning',
            'Are you sure you want to acknowledge?',
            () => updateLeaveStatus(value, 'Approved'),
          );
        } else {
          Utility.showAlertDialog(context, 'Select leave to acknoweledge');
        }
      },
      child: Text(
        'Acknowledge',
        style: LightColors.textHeaderStyle13.copyWith(color: Colors.white),
      ),
    );
  }

  Widget getLeaveRecordWidget(LeaveInfoModel model, bool canAck, int index,
      {bool isGrid = false}) {
    return Container(
      margin: isGrid
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kPrimaryLightColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.description_outlined,
                            size: 16, color: kPrimaryLightColor),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Ref: ${model.ID}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: model.ApprovalStatus == 'Approved'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      model.ApprovalStatus,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: model.ApprovalStatus == 'Approved'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              flex: isGrid ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(
                          Utility.parseDateformat(model.Date),
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    isGrid
                        ? Expanded(
                            child: SingleChildScrollView(
                                child: Html(data: model.Body)))
                        : Html(data: model.Body),
                  ],
                ),
              ),
            ),

            // Footer (Actions)
            if (canAck && canAcknowledge(userType))
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      model.ApprovalStatus == 'Approved'
                          ? 'Approved'
                          : 'Approve',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Checkbox(
                      value: model.ApprovalStatus == 'Approved',
                      activeColor: Colors.green,
                      onChanged: (bool? value) {
                        if (!selectAll) {
                          if (value != null) {
                            setState(() {
                              util.Utility.showConfirmationDialog(
                                  context,
                                  LocalConstant.LBL_CONFIRMATION,
                                  LocalConstant.LBL_UPDATE_LEAVE, () {
                                if (model.ApprovalStatus != 'Approved') {
                                  model.ApprovalStatus = 'Approved';
                                  updateLeaveStatus(
                                      model.ID.toString(), 'Approved');
                                } else {
                                  model.ApprovalStatus = 'Pending';
                                  updateLeaveStatus(
                                      model.ID.toString(), 'Pending');
                                }
                              });
                            });
                          }
                        } else {
                          setState(() {
                            if (value ?? false) {
                              mLeaveAckInfoList[index].ApprovalStatus =
                                  'Approved';
                            } else {
                              mLeaveAckInfoList[index].ApprovalStatus =
                                  'Pending';
                            }
                          });
                          updateSelectAll();
                        }
                      },
                    ),
                  ],
                ),
              )
            else if (userType == 'P' || !canAck)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                child: Row(
                  children: [
                    Icon(
                      model.ApprovalStatus == 'Approved'
                          ? Icons.check_circle
                          : Icons.pending,
                      size: 16,
                      color: model.ApprovalStatus == 'Approved'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Text(
                      model.ApprovalStatus == 'Approved'
                          ? 'Acknowledged'
                          : 'Pending for Acknowledgement',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: model.ApprovalStatus == 'Approved'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  void updateSelectAll() {
    bool allApproved = mLeaveAckInfoList.every(
      (item) => item.ApprovalStatus == 'Approved',
    );
    setState(() {
      selectAll = allApproved;
    });
  }

  void updateLeaveStatus(String model, String status) {
    updateKESLeaveRecord(model, status);
  }

  void updateLeaveRecord(LeaveInfoModel model, String status) {
//     debugPrint('get Leave note ');
    mLeaveAllInfoList.clear();
    isLoading = true;
    setState(() {});
    LeaveApproveRequest request = LeaveApproveRequest(
        ID: model.ID.toString(), Status: status, UserId: uid);
    APIService apiService = APIService();
    apiService.updateLeaveRecord(request, token).then((value) {
      if (value != null) {
        isLoading = false;
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          if (response.success == 200) {
            //Utility.showMessage(context, response.response[0].response.toString());
            Utility.getConfirmationDialog(
                context, 'SUCCESS', response.response[0].response, this);
            getLeaveRecords();
          }
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      setState(() {});
    });
  }

  void updateKESLeaveRecord(String model, String status) {
    debugPrint('get Leave note $model');
    // mLeaveAckInfoList.clear();
    isLoading = true;
    setState(() {});
    LeaveApproveRequest request =
        LeaveApproveRequest(ID: model, Status: status, UserId: uid);
    APIService apiService = APIService();
    apiService.updateKESLeaveRecord(request, token).then((value) {
      isLoading = false;
      if (value == null) {
        Utility.showMessage(context, 'data not found');
      } else if (value is GenericResponse) {
        GenericResponse response = value;
        if (response.success == 200) {
          //Utility.showMessage(context, response.response[0].response.toString());
          Utility.getConfirmationDialog(
              context,
              'SUCCESS',
              response.response is String
                  ? response.response
                  : response.response.response.toString(),
              this);
          List<String> idList = model.split(',');
          mLeaveAckInfoList.removeWhere(
            (element) => idList.contains(element.ID.toString()),
          );
          for (int i = 0; i < mLeaveOriginalInfoList.length; i++) {
            if (idList.contains(mLeaveOriginalInfoList[i].ID.toString())) {
              mLeaveOriginalInfoList[i].ApprovalStatus = 'Approved';
            }
          }
          for (int i = 0; i < mLeaveAllInfoList.length; i++) {
            if (idList.contains(mLeaveAllInfoList[i].ID.toString())) {
              mLeaveOriginalInfoList[i].ApprovalStatus = 'Approved';
            }
          }
          selectAll = false;
          setState(() {});

          // getLeaveRecords();
        }
      } else {
        Utility.showMessage(context, 'data not found');
      }
    });
  }

  @override
  void onClick(int action, value) {
    // TODO: implement onClick
  }
}
