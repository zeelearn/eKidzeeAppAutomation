import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/parent_corner/student_list.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/math_utils.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../../utils/theme/colors/light_colors.dart';
import '../../../../api/response/pentemind/parent_corner/artst.dart';
import '../../../../api/response/pentemind/parent_corner/elg_details.dart';
import '../../../../api/response/pentemind/parent_corner/student_list.dart';
import '../../../../widget/image_viewer.dart';
import '../../../../widget/scrollable_widget.dart';

class ArtsyDetails extends StatefulWidget {
  ArtsyModel model;
  int programID;
  String userId;

  ArtsyDetails(
      {super.key,
      required this.programID,
      required this.userId,
      required this.model});

  @override
  _ArtsyDetailsState createState() => _ArtsyDetailsState();
}

class _ArtsyDetailsState extends State<ArtsyDetails>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<ArtsyStudentModel> mList = [];
  bool isLoading = true;
  late final prefs;
  String token = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
//     debugPrint('Update ELG Details didChangeAppLifecycleState ${state} ');
    if (state == AppLifecycleState.resumed) {
      getArtsyDetails();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    var offlineData = prefs.getString(getId());
    if (true || offlineData == null) {
      getArtsyDetails();
    } else {
      getLocalData(offlineData);
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      mList.clear();
      isLoading = false;
      GetParentCornerArtsyStudentListResponse response =
          GetParentCornerArtsyStudentListResponse.fromJson(
        json.decode(data!),
      );
      mList.addAll(response.studentList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${widget.userId.toString()}_${widget.programID.toString()}_${LocalConstant.MENU_ARTSY_DETAILS}';
  }

  saveData(String json) async {
    prefs.setString(getId(), json);
  }

  getArtsyDetails() {
    isLoading = true;
    setState(() {});
    mList.clear();
    GetParentCornerArtsyStudentListRequest request =
        GetParentCornerArtsyStudentListRequest(
            UserID: widget.userId,
            ProgramID: widget.programID,
            PCID: widget.model.PCID);
    APIService apiService = APIService();
    apiService.getArtsyStudentList(request, token).then((value) {
      debugPrint(value.toString());
      isLoading = false;
      if (value != null) {
//         debugPrint('value is not null ${value}');
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GetParentCornerArtsyStudentListResponse) {
          GetParentCornerArtsyStudentListResponse response = value;
          String json = jsonEncode(response);
          saveData(json);
          mList.addAll(response.studentList);
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
    FirebaseAnalyticsUtils().sendAnalyticsEvent('ELGDETAILS');
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            widget.model.Title,
          ),
          // You can add title here
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
              getArtsyDetails();
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
    } else if (mList.isEmpty) {
      return Utility.emptyData(
          context, "Data are not available at this moment please check later");
    } else {
      return Container(
        margin: EdgeInsets.all(10),
        child: ScrollableWidget(child: buildDataTable()),
      );
    }
  }

  int id = 1;

  final List<String> _dynamicChips = ['Status', 'Uploaded Image'];
  getContent() {
    return Container(
        child: ListView.builder(
      itemCount: mList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
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
                      : mIndex == 0
                          ? MyWidget().richText(
                              mList[index].StatusCode.isEmpty
                                  ? 'NA'
                                  : mList[index].StatusCode,
                              LightColors.textSmallStyle)
                          : getImageView(mList[index]);
                }),
              )),
        );
      },
    ));
  }

  getImageView(ArtsyStudentModel model) {
    debugPrint(model.ParentMediaUrl);
    return Container(
      padding: EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          if (model.ParentMediaUrl.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ImageViewer(
                      imageUrl: model.ParentMediaUrl,
                    )));
          }
        },
        child: SizedBox(
          height: 30,
          child: FadeInImage(
            width: 30,
            height: 30,
            placeholder: AssetImage('assets/icons/ic_no_img_uploaded.png'),
            image: NetworkImage(model.ParentMediaUrl.toString()),
            imageErrorBuilder: (context, error, stackTrace) {
              debugPrint(error.toString());
              return Image.asset('assets/icons/ic_no_img_uploaded.png',
                  fit: BoxFit.fitWidth);
            },
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  int? sortColumnIndex;
  bool isAscending = false;

  Widget buildDataTable() {
    List<String> columns = ['Student Name', 'Status', 'Uploaded Image'];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(mList),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: LightColors.textvSmallStyle,
            ),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<ArtsyStudentModel> reports) =>
      reports.map((ArtsyStudentModel studentModel) {
        List<Widget> cells = [
          SizedBox(
            width: size.width * 0.25,
            child: Text(
              studentModel.StudentName,
              style: LightColors.textvSmallStyle,
            ),
          ),
          SizedBox(
            width: size.width * 0.25,
            child: Text(
              studentModel.StatusCode.isEmpty ? 'NA' : studentModel.StatusCode,
              style: LightColors.textvSmallStyle,
            ),
          ),
          getImageView(studentModel),
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<Widget> cells) =>
      cells.map((data) => DataCell(data)).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      mList.sort((repot1, repot2) =>
          compareString(ascending, repot1.StudentName, repot2.StudentName));
    } else if (columnIndex == 1) {
      mList.sort((repot1, repot2) =>
          compareString(ascending, repot1.StatusCode, repot2.StatusCode));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  Widget getObservations(List<OBSRNModel> list) {
    List<OBSRNModel> obsrnModelList = [];
    obsrnModelList.add(OBSRNModel(
        PCID: 1, TransType: '', Observation: 'Observation', StatusCode: ''));
    obsrnModelList.addAll(list);
    List<String> observations = ['Rarely', 'Sometimes', 'Always'];
    return Container(
        child: ListView.builder(
      itemCount: obsrnModelList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              color: index == 0
                  ? LightColors.kHeaderColor
                  : LightColors.kLightGrayM,
              border: Border.all(color: LightColors.kHeaderColor)),
          padding: EdgeInsets.only(left: 5, right: 5),
          child: ListTile(
              title: MyWidget().richText(obsrnModelList[index].Observation,
                  LightColors.textSmallStyle),
              trailing: Wrap(
                spacing: 4.0,
                runSpacing: 2.0,
                children:
                    List<Widget>.generate(observations.length, (int mIndex) {
                  return index == 0
                      ? Container(
                          margin: EdgeInsets.all(5),
                          child: Text(observations[mIndex],
                              style: LightColors.textSmallHightliteStyle),
                        )
                      : Radio(
                          value: index + 1,
                          groupValue: index,
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
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          start: 20,
          end: 20,
          bottom: 30,
          top: 8,
        ),
        child: getObservations(model.OBSRN!),
      ),
    );
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
