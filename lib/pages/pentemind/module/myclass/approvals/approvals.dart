import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/myclass/approval_request.dart';
import 'package:ekidzee/api/request/pentemind/myclass/cm_approve.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/myclass/approval_response.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';

class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  _ApprovalsScreenState createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  String studentId = '';
  String className = '';
  String cName = '';
  int programId = 0;
  List<ApprovalData> mApprovalList = [];
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  DateTime minDate = DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
  DateTime maxDate = DateTime(DateTime.now().year, DateTime.now().month + 3, 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    
    DateTime toDate =DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _fromDateController.text = DateFormat("yyyy-MM-dd").format(minDate);
    _toDateController.text = DateFormat("yyyy-MM-dd").format(toDate);
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
//     debugPrint('_Academic Screen didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      getApprovals();
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

//     debugPrint('Teacher id $uid');
    //_dayController.text = '1';
    //var childAdvancementSummery = prefs.getString(getId());
    getApprovals();
    ///*** DISABLE DEAD CODE */
    // if (true || childAdvancementSummery == null) {
    //   getApprovals();
    // } else {
    //   getLocalData(childAdvancementSummery);
    // }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mApprovalList.clear();
      isLoading = false;
      ApprovalResponse response = ApprovalResponse.fromJson(
        json.decode(data!),
      );
      mApprovalList.addAll(response.data);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_MYCLASS_APPROVALS}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
  }

  getApprovals() {
    mApprovalList.clear();
    isLoading = true;
    setState(() {});
    ApprovalRequest request = ApprovalRequest(
        fromdate: _fromDateController.text.toString(),
        todate: _toDateController.text.toString(),
        ReqType: _requestType == 'Select All'
            ? ''
            : _requestType == 'Homework'
                ? 'HW'
                : _requestType,
        programID: programId.toString(),
        ApprovalStatus: _status == 'Select All' ? '' : _status);
    APIService apiService = APIService();
    apiService.getApprovalstatus(request, token).then((value) {
      // if (value != null) {
      isLoading = false;
      if (value == null) {
        Utility.showMessage(context, 'data not found');
      } else if (value is ApprovalResponse) {
        ApprovalResponse response = value;
        String json = jsonEncode(response);
        savechildSummery(json);
        mApprovalList.addAll(response.data);

        setState(() {});
      } else {
        Utility.showMessage(context, 'data not found');
      }
      // }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('$userType Approvals');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Approval'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            updateApproval();
          },
          backgroundColor: kPrimaryLightColor,
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
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
              getApprovals();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  getHeader(),
                  SizedBox(
                    height: 20,
                  ),
                  getChildList(),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (mApprovalList.isEmpty) {
      return Utility.emptyData(
          context, "Data are not available at this moment please check later");
    } else {
      return Flexible(
          child: ListView.builder(
        itemCount: mApprovalList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getwidget(mApprovalList[index]);
        },
      ));
    }
  }

  int ACTION_REQUESTTYPE = 111;
  String _requestType = 'Select All';
  List<String> requestTypes = [
    'Select All',
    'Absent',
    'Announcement',
    'Homework',
    'Leave'
  ];

  int ACTION_STATUS = 112;
  String _status = 'Select All';
  List<String> statusList = ['Select All', 'Pending', 'Approved'];

  Widget getHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile = constraints.maxWidth < 700;

        return Container(
          padding: const EdgeInsets.all(12),
          color: LightColors.kLightGray,
          child: Column(
            children: [
              // ---------- ROW 1 ----------
              Row(
                children: [
                  Expanded(
                    child: _dateField(
                      label: 'From',
                      controller: _fromDateController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dateField(
                      label: 'To',
                      controller: _toDateController,
                    ),
                  ),
                  if (!mobile) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: MyWidget().getDropdown(
                        'Request Type',
                        _requestType,
                        requestTypes,
                        ACTION_REQUESTTYPE,
                        this,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MyWidget().getDropdown(
                        'Status',
                        _status,
                        statusList,
                        ACTION_STATUS,
                        this,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _updateButton(),
                  ],
                ],
              ),

              // ---------- ROW 2 (MOBILE ONLY) ----------
              if (mobile) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: MyWidget().getDropdown(
                        'Request Type',
                        _requestType,
                        requestTypes,
                        ACTION_REQUESTTYPE,
                        this,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MyWidget().getDropdown(
                        'Status',
                        _status,
                        statusList,
                        ACTION_STATUS,
                        this,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _updateButton(expand: true),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _updateButton({bool expand = false}) {
    final button = GestureDetector(
      onTap: getApprovals,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Update',
          style: LightColors.textHeaderStyle13Selected,
        ),
      ),
    );

    return expand ? Expanded(child: Center(child: button)) : button;
  }

  Widget _dateField({
    required String label,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        MyWidget().richText('$label ', LightColors.textSmallStyle),
        const SizedBox(width: 6),
        Expanded(
          child: MyWidget().getDateTimePicker(
            context,
            '',
            controller,
            minDate,
            maxDate,
          ),
        ),
      ],
    );
  }

  getHeader1() {
    return Container(
        padding: EdgeInsets.all(15),
        color: LightColors.kLightGray,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyWidget().richText('From ', LightColors.textSmallStyle),
                SizedBox(
                    width: 40, // 30%
                    child: MyWidget().getDateTimePicker(
                        context, '', _fromDateController, minDate, maxDate)),
                Expanded(
                  flex: 5, // 30%
                  child: Text(''),
                ),
                MyWidget().richText('To ', LightColors.textSmallStyle),
                Expanded(
                    flex: 40, // 30%
                    child: MyWidget().getDateTimePicker(
                        context, '', _toDateController, minDate, maxDate)),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    flex: 40, // 30%
                    child: MyWidget().getDropdown('Request Type', _requestType,
                        requestTypes, ACTION_REQUESTTYPE, this)),
                Expanded(
                    flex: 40, // 30%
                    child: MyWidget().getDropdown(
                        'Status', _status, statusList, ACTION_STATUS, this)),
                Expanded(
                  flex: 25, // 30%
                  child: Center(
                    child: GestureDetector(
                        onTap: () {
                          getApprovals();
                        },
                        child: Container(
                          color: kPrimaryLightColor,
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Update',
                            style: LightColors.textHeaderStyle13Selected,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  getwidget(ApprovalData model) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 8),
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
        child: true
            ? trailine(model)
            : ListTile(
                title: Padding(
                  padding: EdgeInsetsDirectional.all(0),
                  child: Text(
                    model.StudentName,
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      color: Color(0xFF4B39EF),
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                ),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(0),
                        child: Html(style: {
                          "body": Style(
                            fontSize: FontSize(12.0),
                          ),
                        }, data: model.Subject)),
                    Padding(
                        padding: EdgeInsets.all(0),
                        child: Html(style: {
                          "body": Style(
                            fontSize: FontSize(10.0),
                          ),
                        }, data: model.Body)),
                  ],
                ),
                trailing: model.ApprovalStatus == 'Approved'
                    ? MyWidget().richText(
                        model.ApprovalStatus, LightColors.textvSmallStyle)
                    : model.ApprovalStatus.isEmpty
                        ? Text('')
                        : Stack(
                            children: [
                              Checkbox(
                                checkColor: Colors.white, // color of tick Mark
                                activeColor: kPrimaryLightColor,
                                value: model.isApprove ? true : false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    model.isApprove = value!;
                                  });
                                },
                              ),
                              Text(
                                model.ApprovalStatus == 'NULL' ||
                                        model.ApprovalStatus == 'Pending'
                                    ? 'Not Approved'
                                    : model.ApprovalStatus,
                                style: TextStyle(color: kPrimaryLightColor),
                              ),
                            ],
                          )),
      ),
    );
  }

  trailine(ApprovalData model) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: Colors.grey.shade200),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.03),
      //       blurRadius: 6,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- CONTENT ----------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student name
                Text(
                  model.StudentName,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: const Color(0xFF4B39EF),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                // Subject
                Html(
                  data: model.Subject,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(12),
                    ),
                  },
                ),

                const SizedBox(height: 4),

                // Body
                Html(
                  data: model.Body,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(10),
                      color: Colors.grey.shade700,
                    ),
                  },
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ---------- TRAILING ----------
          _approvalWidget(model),
        ],
      ),
    );
  }

  Widget _approvalWidget(ApprovalData model) {
    // Approved state
    if (model.ApprovalStatus == 'Approved') {
      return MyWidget()
          .richText(model.ApprovalStatus, LightColors.textvSmallStyle);
    }

    // Empty state
    if (model.ApprovalStatus.isEmpty) {
      return const SizedBox.shrink();
    }

    // Pending / Not approved
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: model.isApprove,
          activeColor: kPrimaryLightColor,
          onChanged: (value) {
            setState(() {
              model.isApprove = value ?? false;
            });
          },
        ),
        Text(
          model.ApprovalStatus == 'NULL' || model.ApprovalStatus == 'Pending'
              ? 'Not Approved'
              : model.ApprovalStatus,
          style: TextStyle(
            color: kPrimaryLightColor,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void onClick(int action, value) {
    if (action == ACTION_REQUESTTYPE) {
      setState(() {
        _requestType = value;
      });
      getApprovals();
    } else if (action == ACTION_STATUS) {
      setState(() {
        _status = value;
      });
      getApprovals();
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
        getApprovals();
      }
    }
  }

  ifAnySelection() {
    List<ApprovalModel> approvalsList = [];
    for (int index = 0; index < mApprovalList.length; index++) {
      if (mApprovalList[index].isApprove) {
        approvalsList.add(ApprovalModel(ID: mApprovalList[index].ID));
      }
    }
    return approvalsList;
  }

  updateApproval() {
    List<ApprovalModel> approvalsList = ifAnySelection();
    if (approvalsList.isEmpty) {
    } else {
      setState(() {
        isLoading = true;
      });
      debugPrint(teacherId);
      ApprovedRequest request = ApprovedRequest(
          ApprovedStatus: 'Approved',
          ApprovedBy: uid,
          inputdata: approvalsList);
      APIService apiService = APIService();
      apiService.updateApprovalStatus(request, token).then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is GenericResponse) {
            GenericResponse response = value;
            if (response.success == 200) {
              Utility.showMessage(context, response.response[0].response);
              getApprovals();
            }
          } else {
            Utility.showMessage(context, 'data not found');
          }
        }

        setState(() {});
      });
    }
  }

  showListBottomSheet(int action, List<String> list) {
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
}

class Filters {
  String label;
  Color color;
  bool isSelected;
  int index;

  Filters(this.label, this.index, this.color, this.isSelected);
}
