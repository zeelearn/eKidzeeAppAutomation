import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/pentemind/module/dailyactivity/homework.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/response/pentemind/tracker/tracker_response.dart';
import '../../../../constants.dart';
import '../facilatorsays/logbook/logbook.dart';
import '../learninggoal/developmental/developmental.dart';

class TrackerScreen extends StatefulWidget {
  onClickListener listener;

  TrackerScreen({super.key, required this.listener});

  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool isLoading = true;
  late final prefs;
  String uid = '';
  String token = '';
  String _lasySyncDate = '';
  int programId = 0;
  List<TrackerModel> trackerList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    loadData();
  }

  loadData() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    getTrackerList();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('tracker  didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      getTrackerList();
    }
  }

  Future<void> getTrackerList() async {
    if (kIsWeb) {
      reloadTrackerList();
      return;
    }
    var childAdvancementSummery = prefs.getString(getId());
    _lasySyncDate = prefs.getString('sync_${getId()}') ?? '';
    bool isOfflineEligble = await Utility.isOfflineEligble(
        context, prefs.getString('sync_${getId()}') ?? '');
    if (childAdvancementSummery != null && isOfflineEligble) {
      getLocalData(childAdvancementSummery);
    } else {
      reloadTrackerList();
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      trackerList.clear();
      isLoading = false;
      TrackerResponse response = TrackerResponse.fromJson(
        json.decode(data!),
      );
      trackerList.addAll(response.trackerModelList);
      /*trackerList.sort((a, b) => a.CName.toLowerCase()
          .compareTo(b.CName.toString().toLowerCase()));
      trackerList = trackerList.reversed.toList();*/
      setState(() {});

      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${programId.toString()}_${LocalConstant.MENU_TRACKER}';
  }

  savechildSummery(String json) async {
    prefs.setString(getId(), json);
    prefs.setString('sync_${getId()}', Utility.formatDate());
    setState(() {
      _lasySyncDate = Utility.formatDate();
    });
  }

  reloadTrackerList() async {
    trackerList.clear();
    isLoading = true;
    setState(() {});
    if (!await Utility.isInternet()) {
      setState(() {
        isLoading = false;
      });
    } else {
      BasePentemindRequest request =
          BasePentemindRequest(Program_ID: programId, userId: uid);
      APIService apiService = APIService();
      apiService.getTracker(request, token).then((value) {
        // if (value != null) {
        isLoading = false;
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is TrackerResponse) {
          TrackerResponse response = value;
          String json = jsonEncode(response);
          savechildSummery(json);
          trackerList.addAll(response.trackerModelList);
          setState(() {
            /*trackerList.sort((a, b) => a.CName.toLowerCase()
                .compareTo(b.CName.toString().toLowerCase()));
            trackerList = trackerList.reversed.toList();*/
          });
        } else {
          Utility.showMessage(context, 'data not found');
        }
        // }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) FirebaseAnalyticsUtils().sendAnalyticsEvent('Tracker');
    return Scaffold(
        backgroundColor: LightColors.kLightGray1,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              reloadTrackerList();
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
    } else if (trackerList.isEmpty) {
      return Column(
        children: [
          Utility.emptyData(context,
              "Data are not available at this moment please check later")
        ],
      );
    } else {
      return Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            color: LightColors.kLightGray1,
            padding: const EdgeInsets.only(top: 1),
            child: ListView.builder(
              itemCount: trackerList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return getTrackerWidget(trackerList[index]);
              },
            ),
          ));
    }
  }

  getActivities(TrackerModel model) {
    List<String> dataActivities = model.dataactivity.split('~');
    return ListTile(
        title: Text(model.CName, style: LightColors.textHeaderStyle),
        subtitle: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children:
                List<Widget>.generate(dataActivities.length, (int mIndex) {
              List<String> trackerCount = dataActivities[mIndex].split('/');
              return InkWell(
                onTap: () {
                  List<String> day = model.CName.split('D');
                  int day0 = int.parse(day[1].replaceAll('D', ''));
                  debugPrint(day[0]);
                  // debugPrint(day0);
                  if (trackerCount[1].contains('LB')) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogbookScreen(
                                  cName: model.CName,
                                  day: day0,
                                  isToolbar: true,
                                )));
                  } else if (trackerCount[1].contains('LGD') &&
                      trackerCount[1].toLowerCase().contains('daily')) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DevelopmentalScreen(
                                  cName: model.CName,
                                  day: day0,
                                  isToolbar: true,
                                  observationType: 'DAILY',
                                  listener: widget.listener,
                                )));
                  } else if (trackerCount[1].contains('LGD')) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DevelopmentalScreen(
                                  cName: model.CName,
                                  day: day0,
                                  isToolbar: true,
                                  observationType: 'TEACH',
                                  listener: widget.listener,
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeworkScreen(
                                  isToolbar: true,
                                )));
                  }
                },
                child: Container(
                    margin: const EdgeInsets.all(0),
                    child: Chip(
                      backgroundColor: LightColors.kLightGrayM,
                      label: Text(
                          trackerCount[1].contains('LGD(Teach)')
                              ? trackerCount[1].toString().replaceAll(')', ') ')
                              : ' ${trackerCount[1]}   ${trackerCount.length >= 3 ? trackerCount[2] : ''} / ${trackerCount.length >= 4 ? trackerCount[3] : ''}',
                          style: GoogleFonts.roboto(
                            fontSize: 10.0,
                            color: LightColors.kDarkBlue,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          )),
                    )),
              );
            })));
  }

  getTrackerWidget(TrackerModel model) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
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
          kIsWeb
              ? SizedBox.shrink()
              : _lasySyncDate.isEmpty
                  ? const SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Last Sync : ${Utility.parseFullDate(_lasySyncDate)} ',
                        style: LightColors.textvSmallStyle,
                      )),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Text(
                    'Date : ${model.AttendanceDate.isEmpty ? 'NA' : Utility.parseDate(model.AttendanceDate)}',
                    style: LightColors.textSmallStyle,
                  ),
                ),
              ],
            ),
          ),
          getActivities(model)
        ],
      ),
    );
  }

  @override
  void onClick(int action, value) {}
}
