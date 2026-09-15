import 'dart:convert';
import 'dart:developer';

import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/request/pentemind/learninggoal/developmental/GetLearningGoalAcademic.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/get_day_response.dart';
import '../../../../../api/response/pentemind/learninggoals/developmental/GetLearningGoalDevelopmentalResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../globals.dart';
import '../../../../../helper/utils.dart';
import '../../../../home/model/StatusModel.dart';
import '../../../../home/pentemindhome.dart';
import '../../../../notification/NotificationService.dart';
import 'developmental_feedback.dart';

class DevelopmentalScreen extends StatefulWidget {
  String cName;
  String? observation;
  String? observationType;
  String? domain;
  String? skill;
  int day;
  bool isToolbar;
  bool? deepLinkingenabled;
  onClickListener listener;
  String? programId;

  DevelopmentalScreen(
      {super.key,
      required this.cName,
      required this.day,
      this.observation,
      required this.isToolbar,
      required this.listener,
      this.observationType,
      this.domain,
      this.skill,
      this.deepLinkingenabled,
      this.programId});

  @override
  _DevelopmentalScreenState createState() => _DevelopmentalScreenState();
}

class _DevelopmentalScreenState extends State<DevelopmentalScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isInternet = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String term = '';
  String studentId = '';
  String className = '';
  int programId = 0;
  final String _culminationName = '';
  GetLearningGoalDevelopmentalResponse? mSkillModel;
  GetDayResponse? dayModel;
  final TextEditingController _dayController = TextEditingController();

  final int ACTION_OBSERVATION = 21;
  final int ACTION_DOMAIN = 23;
  final int ACTION_DAY = 25;

  List<String> domains = [];
  String _lasySyncDate = '';

  bool isLogBookCompleted = true;
  final TextEditingController _searchController = TextEditingController();
  final focusNode = FocusNode();
  bool isSearch = false;

  int activeObservation = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    loadData();
    _observation =
        widget.observationType == null && widget.deepLinkingenabled == null
            ? 'DAILY'
            : widget.observationType!;

    setState(() {});
  }

  Future<void> loadData() async {
    if (widget.day > 0) {
//       debugPrint('113 ${widget.day}  ${_observation} ${widget.observationType}');
      _dayController.text = widget.day.toString();
      if (widget.observationType == 'TEACH') {
        activeObservation = 1;
        _observation = "TEACH";
      }
    } else if (widget.deepLinkingenabled == null) {
      if (widget.cName == 'fill_btn_click') {
        _dayController.text = widget.day.toString();
//         debugPrint('123 ${widget.cName} ${_observation} ${widget.observationType}');
      } else if (widget.cName.isEmpty) {
        GetDayResponse? dayModel = await KidzeePref.getDay(context);
        _dayController.text = dayModel.data.D.toString();
//         debugPrint('127');
      }
    } else if (widget.cName.isEmpty) {
      GetDayResponse? dayModel = await KidzeePref.getDay(context);
      _dayController.text = dayModel.data.D.toString();
//       debugPrint('132');
    } else {
      _dayController.text = widget.day.toString();
//       debugPrint('135');
    }
//     debugPrint('getDay ${_dayController.text}');
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dayController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadDevelopmentalList();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    debugPrint('Get Token $token');
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) as String;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    loadDevelopmentalList();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadOfflineDevelopmentSkill() async {
    if (getObservationType() == 'All') {
      generateOptions();
    } else {
      var childAdvancementSummery = prefs.getString(getId());
      _lasySyncDate = prefs.getString('sync_${getId()}') ?? '';
      if (childAdvancementSummery != null) {
//         debugPrint('oFFLINE ----');
        getLocalData(childAdvancementSummery);
      } else {
//         debugPrint('online ----');
        mSkillModel!.data.learningGoal.clear();
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadDevelopmentalList() async {
    if (getObservationType() == 'All') {
      generateOptions();
      setState(() {
        isLoading = false;
      });
    } else {
      bool isInternetAvaliability = await Utility.isInternet();
      var childAdvancementSummery = prefs.getString(getId());
      bool isOfflineEligble = await Utility.isOfflineEligble(
          context, prefs.getString('sync_${getId()}') ?? '');
//       debugPrint('isOffline ${isOfflineEligble} ${childAdvancementSummery}');
      _lasySyncDate = prefs.getString('sync_${getId()}') ?? '';
      if (widget.deepLinkingenabled == null) {
        if (widget.cName == 'fill_btn_click') {
          getDevelopmentalSkills();
        } else if (childAdvancementSummery != null &&
            (isOfflineEligble || !isInternetAvaliability)) {
//           debugPrint('oFFLINE ----');
          getLocalData(childAdvancementSummery);
        } else if (isInternetAvaliability) {
//           debugPrint('online ----');
          getDevelopmentalSkills();
        } else {
//           debugPrint('====================ELSE 210');
        }
      } else {
        getDevelopmentalSkills();
      }
    }
  }

  bool getLocalData(data) {
    bool isLoad = false;
    try {
      isLoading = false;
      GetLearningGoalDevelopmentalResponse response =
          GetLearningGoalDevelopmentalResponse.fromJson(
        json.decode(data!),
      );
      mSkillModel = response;
      isLogBookCompleted = response.data.LogBookCompleted;
      setState(() {});
      if (mSkillModel!.data.learningGoal.isEmpty) {
        getDevelopmentalSkills();
      }
      setState(() {});
      generateOptions();
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${programId}_${_dayController.text.toString()}_${getObservationType()}_${LocalConstant.MENU_LG_FACILATOR_SAYS}_${getObservationType()}';
  }

  Future<void> savechildAdvancementSummery(String json, bool isSync) async {
    prefs.setString(getId(), json);
    if (isSync) {
      prefs.setString('sync_${getId()}', Utility.formatDate());
    }
    setState(() {
      _lasySyncDate = Utility.formatDate();
    });
  }

  String _observation = '';
  String _domain = '';

  void generateOptions() {
    //debugPrint('generate options................');
    domains.clear();
    domains.add('All Domain');

    if (mSkillModel != null)
      for (int index = 0;
          index < mSkillModel!.data.learningGoal.length;
          index++) {
        if (!domains
            .contains(mSkillModel!.data.learningGoal[index].DomainName)) {
          domains.add(mSkillModel!.data.learningGoal[index].DomainName);
        }
      }

    if (_dayController.text.isEmpty || _dayController.text == '0') {
      _dayController.text = '1';
    }
    try {
      if (widget.deepLinkingenabled != null) {
        _domain = widget.observationType!;
      } else if (_domain.isEmpty) {
        _domain = domains[0];
      }
    } catch (e) {}
    setState(() {
      getSortedData();
    });
  }

  Future<void> getDevelopmentalSkills() async {
    bool isInternetAvaliability = await Utility.isInternet();
    if (getObservationType() == 'All') {
      generateOptions();
    } else if (!isInternetAvaliability) {
      isInternet = false;
      generateOptions();
    } else {
      isInternet = true;
      isLoading = true;
      isLogBookCompleted = true;
      setState(() {});
      DevelopmentalRequest request = DevelopmentalRequest(
          ProgramID: widget.cName == 'fill_btn_click'
              ? int.parse(widget.programId ?? '$programId')
              : programId,
          D: _dayController.text.toString().isEmpty
              ? 0
              : int.parse(_dayController.text.toString()),
          ObservationType: getObservationType(),
          Term: '');
      APIService apiService = APIService();

      apiService.getLearningGoalDevelopmental(request, token).then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is GetLearningGoalDevelopmentalResponse) {
            GetLearningGoalDevelopmentalResponse response = value;
            isLogBookCompleted = response.data.LogBookCompleted;
            String json = jsonEncode(response);
            savechildAdvancementSummery(json, true);
            mSkillModel = response;

            generateOptions();
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
//     debugPrint('LG-Developmental........');
    FirebaseAnalyticsUtils().sendAnalyticsEvent('LG-Developmental');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.isToolbar
            ? AppBar(
                title: const Text('Developmental'),
              )
            : null,
        bottomNavigationBar: footerPEN(),
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              getDevelopmentalSkills();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  Widget getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (mSkillModel == null) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            getHeader(),
            !isInternet
                ? Utility.noInternet(context)
                : Utility.emptyData(
                    context,
                    !isInternet
                        ? LocalConstant.NO_INTERNET
                        : "Observation are not avaliable for this day, Please check again")
          ],
        ),
      );
      /*return Utility.emptyData(
          context, "Data are not available at this moment please check later");*/
    } else if (mSkillModel == null ||
        mSkillModel?.data.learningGoal == null ||
        mSkillModel!.data.learningGoal.isEmpty) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            getHeader(),
            !isInternet
                ? Utility.noInternet(context)
                : Utility.emptyData(context,
                    "Observation are not avaliable for this day, Please check again")
          ],
        ),
      );
    } else if (mSortedSkill.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          children: [
            getHeader(),
            ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width * 0.7,
              initialLabelIndex: activeObservation,
              animate: true,
              activeBgColor: [
                kPrimaryLightColor,
              ],
              inactiveBgColor: LightColors.kLightGray1, totalSwitches: 2,
              //inactiveBgColor: Colors.grey[900],
              labels: const ['Daily Observation', 'Teachers Observation'],
              onToggle: (index) {
//                 debugPrint('switched to: $index');
                activeObservation = index!;
                _observation = index == 0 ? 'DAILY' : 'TEACH';
                getSortedData();
              },
            ),
            !isInternet
                ? Utility.noInternet(context)
                : Utility.emptyData(
                    context, "Observation are not avaliable for this Filter")
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          children: [
            getHeader(),
            ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width * 0.7,
              initialLabelIndex: activeObservation,
              animate: true,

              //activeBgColor: kPrimaryColor,
              //activeBgColor: Colors.white,
              inactiveBgColor: LightColors.kLightGray1,
              activeBgColor: [
                kPrimaryLightColor,
              ],
              totalSwitches: 2,
              //inactiveBgColor: Colors.grey[900],
              labels: const ['Daily Observation', 'Teachers Observation'],
              onToggle: (index) {
//                 debugPrint('switched to: $index');
                activeObservation = index!;
                _observation = index == 0 ? 'DAILY' : 'TEACH';
                getSortedData();
              },
            ),
            const SizedBox(
              height: 5,
            ),
            !isLogBookCompleted
                ? InkWell(
                    onTap: () {
                      widget.listener.onClick(
                          LocalConstant.ACTION_PENTEMIND_MODULE,
                          PentemindItem(
                              3,
                              'Facilitator Tools',
                              LocalConstant.MODULE_FACILATORTOOL,
                              'assets/icons/ic_facilitatortools.png'));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Please fill logbook First!!',
                            style: LightColors.hintTextStyle),
                        const Icon(
                          Icons.forward_sharp,
                          color: Color(0xFF4B39EF),
                        )
                      ],
                    ),
                  )
                : kIsWeb
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
            Expanded(
              child: getContent(),
            ),
          ],
        ),
      );
    }
  }

  Container getHint() {
    return Container(
      color: LightColors.kLightGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: MyWidget()
                .richText('P = Progressing', LightColors.textvSmallStyle),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: MyWidget().richText(
                'E = Needs Encouragement', LightColors.textvSmallStyle),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: MyWidget().richText(
                'N = Not Assessing at this time', LightColors.textvSmallStyle),
          ),
        ],
      ),
    );
  }

  void reset() {
    _domain = '';
    loadDevelopmentalList();
  }

  void updateSelection(int action, String value) {
    if (action == ACTION_DAY) {
      //reset();
      loadDevelopmentalList();
    } else if (action == ACTION_OBSERVATION) {
      _observation = value;

      reset();
      getSortedData();
    } else if (action == ACTION_DOMAIN) {
      setState(() {
        _domain = value;
      });
      generateOptions();
      getSortedData();
      //reset();
    }
    setState(() {});
  }

  String getObservationType() {
    return widget.observationType ??
        (widget.deepLinkingenabled == null ? 'DAILY' : widget.observationType!);
  }

  void resetSearch() {
    isSearch = false;
    _searchController.text = '';
  }

  StatelessWidget getHeader() {
    return isSearch
        ? Card(
            margin: const EdgeInsets.all(15),
            color: Colors.white,
            child: Container(
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width / 0.7,
                child: TextFormField(
                  controller: _searchController,
                  cursorColor: kPrimaryLightColor,
                  textInputAction: TextInputAction.done,
                  style: LightColors.textHeaderStyle13,
                  // initialValue: _dayController.text.toString(),
                  //focusNode: focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'search here..',
                    counterText: "",
                    fillColor: Colors.white60,
                    suffixIcon: InkWell(
                      onTap: () {
//                         debugPrint('onTap--');
                        setState(() {
                          if (isSearch) {
                            // FocusScope.of(context).requestFocus(focusNode);
                            resetSearch();
                          } else {
                            isSearch = !isSearch;
                          }
                          getSortedData();
                        });
                      },
                      child: !isSearch
                          ? const Icon(Icons.search)
                          : const Icon(Icons.clear),
                    ),
                    /*focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),*/
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: const BorderSide(
                        color: LightColors.kLightGray,
                        width: 1.0,
                      ),
                    ),
                  ),
                  //initialValue: _dayController.text.toString(),
                  onChanged: (val) {
                    //if(val.length>1) {
                    log('OnChanged value is - $val');
                    // _searchController.text = val.toString();
                    getSortedData();
                    //}
                  },
                  onFieldSubmitted: (val) {
                    setState(() {
                      // _searchController.text = val.toString();
                      getSortedData();
                      resetSearch();
                    });
                  },
                ),
              ),
            ),
          )
        : Container(
            margin:
                const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
            child: true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        Expanded(
                          flex: 30,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: LightColors.kLightGray,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            height: 50,
                            child: Center(
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 3,
                                cursorColor: kPrimaryColor,
                                decoration:
                                    MyWidget().getInputDecoration('Day'),
                                // decoration: const InputDecoration(
                                //
                                //   labelText: 'Day :',
                                //   counterText: "",
                                //
                                //   // enabledBorder: UnderlineInputBorder(
                                //   //   borderSide:
                                //   //       BorderSide(color: Color(0xFF6200EE)),
                                //   // ),
                                // ),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                initialValue: _dayController.text.toString(),
                                onFieldSubmitted: (value) {
                                  _dayController.text = value;
                                  getDevelopmentalData();
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 45,
                          child: MyWidget().getDropdownButton('All Domain',
                              _domain, domains, ACTION_DOMAIN, this),
                        ),
                        Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: SizedBox(
                                height: 45,
                                child: IconsButton(
                                  onPressed: () {
                                    Future.delayed(
                                            const Duration(milliseconds: 50))
                                        .then((_) {
                                      //Navigator.of(context).pop();
                                      setState(() {
                                        isSearch = true;
                                      });
                                    });
                                  },
                                  text: '',
                                  iconData:
                                      !isSearch ? Icons.search : Icons.cancel,
                                  color: Colors.white,
                                  textStyle:
                                      const TextStyle(color: Colors.black87),
                                  iconColor: Colors.black87,
                                ),
                              ),
                            )),
                      ])
                : Table(
                    children: [
                      TableRow(children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: LightColors.kLightGray,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 40,
                          child: Center(
                            child: TextFormField(
                              maxLength: 3,
                              cursorColor: kPrimaryColor,
                              decoration: const InputDecoration(
                                labelText: '  Day',
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF6200EE)),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              initialValue: _dayController.text.toString(),
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (value) {
                                _dayController.text = value;
                                getDevelopmentalSkills();
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: MyWidget().getDropdown('All Domain', _domain,
                              domains, ACTION_DOMAIN, this),
                        ),
                        IconsButton(
                          onPressed: () {
                            Future.delayed(const Duration(milliseconds: 50))
                                .then((_) {
                              //Navigator.of(context).pop();
                              setState(() {
                                isSearch = true;
                              });
                            });
                          },
                          text: '',
                          iconData: !isSearch ? Icons.search : Icons.cancel,
                          color: Colors.white,
                          textStyle: const TextStyle(color: Colors.black87),
                          iconColor: Colors.black87,
                        ),
                      ]),
                      const TableRow(children: [
                        Divider(
                          color: LightColors.kLightGray1,
                        ),
                        Divider(
                          color: LightColors.kLightGray1,
                        ),
                        Divider(
                          color: LightColors.kLightGray1,
                        ),
                      ]),
                    ],
                  ),
          );
  }

  final List<String> _dynamicChips = ['P', 'E', 'N'];
  final List<Color> _colorChips = [
    LightColors.kGreen,
    LightColors.kBlue,
    LightColors.kRed
  ];
  List<LearningGoal> mSortedSkill = [];

  Future<void> getSortedData() async {
    mSortedSkill.clear();
    if (widget.deepLinkingenabled != null) {
      _observation = widget.observationType!;
    }
    if (mSkillModel != null)
      for (int index = 0;
          index < mSkillModel!.data.learningGoal.length;
          index++) {
        if (_observation ==
            mSkillModel!.data.learningGoal[index].ObservationType) {
          if (_domain == 'All Domain' ||
              (_domain == mSkillModel!.data.learningGoal[index].DomainName)) {
            if (_searchController.text == '' ||
                mSkillModel!.data.learningGoal[index]
                    .isContains(_searchController.text.toLowerCase())) {
//               debugPrint('Search $_searchController');
              mSortedSkill.add(mSkillModel!.data.learningGoal[index]);
            }
            //mSortedSkill.add(mSkillModel!.data.learningGoal[index]);
          }
        }
        //debugPrint('sorted length ${mSortedSkill.length}');
        setState(() {});
      }
  }

  Container getContent() {
//     debugPrint('Sorted list ${mSortedSkill.length}');
    return Container(
        color: LightColors.kLightGray,
        child: ListView.builder(
            itemCount: mSortedSkill.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  //resetSearch();
                  debugPrint(_dayController.text);
                  if (isLogBookCompleted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DevelopmentalFeedback(
                                model: mSortedSkill[i],
                                day: int.parse(_dayController.text.toString()),
                                observation: mSortedSkill[i].ObservationType,
                                listener: widget.listener,
                                programId: widget.programId != null
                                    ? int.parse(widget.programId!)
                                    : null,
                              )),
                    ).then((value) async {
//                       debugPrint('Response received.....$value');
                      if (value is LearningGoal) {
                        final statusBox =
                            await Hive.openBox(LocalConstant.logbookStatus);
                        await NotificationService().cancelNotification(
                            LocalConstant.LEARNINGOAL_NOTIFICATION_ID_1);
                        await NotificationService().cancelNotification(
                            LocalConstant.LEARNINGOAL_NOTIFICATION_ID_2);
                        await NotificationService().cancelNotification(
                            LocalConstant.FINAL_NOTIFICATION_ID);
                        var statusList = statusBox.values.toList();
                        for (int i = 0; i < statusList.length; i++) {
                          if (statusList[i] is StatusModel) {
//                             debugPrint('Status model data is - $statusList[i]');
                            if (widget.programId != null
                                ? (statusList[i].programID ==
                                    int.parse(widget.programId!))
                                : (statusList[i].programID == programId) &&
                                    statusList[i].day ==
                                        int.parse(
                                            _dayController.text.toString())) {
                              await statusBox.deleteAt(i);
                            }
                          }
                        }
                        LearningGoal updatedLearningGoal = value;
                        for (int index = 0;
                            index < mSkillModel!.data.learningGoal.length;
                            index++) {
                          if (mSkillModel!.data.learningGoal[index].LGDID ==
                                  updatedLearningGoal.LGDID &&
                              mSkillModel!.data.learningGoal[index].SessionID ==
                                  updatedLearningGoal.SessionID) {
                            mSkillModel!.data.learningGoal[index] =
                                updatedLearningGoal;
                          }
                        }
                        String json = jsonEncode(mSkillModel);
                        savechildAdvancementSummery(json, false);
                        loadDevelopmentalList();
                      } else if (value != null && value == 'open_attendance') {
                        widget.listener.onClick(
                            LocalConstant.ACTION_PENTEMIND_MODULE,
                            PentemindItem(2, 'My Class', 'attendance',
                                'assets/icons/ic_attendance.png'));
                      } else {
                        getDevelopmentalSkills();
                        //debugPrint('-----------------its NOT ALearnig Goal');
                      }

                      //loadDevelopmentalList();
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Card(
                    color: isLogBookCompleted
                        ? Colors.white
                        : LightColors.kLightGray,
                    child: ListTile(
                        title: MyWidget().richText(
                            mSortedSkill[i].LearningGoals,
                            LightColors.textSmallStyle),
                        trailing: Wrap(
                          spacing: 4.0,
                          runSpacing: 2.0,
                          children: List<Widget>.generate(_dynamicChips.length,
                              (int index) {
                            return Chip(
                              avatar: CircleAvatar(
                                backgroundColor: _colorChips[index],
                                child: Text(
                                  _dynamicChips[index],
                                  style: GoogleFonts.roboto(
                                    fontSize: kIsWeb ? 14 : 10.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                              label: Text(getTagValue(mSortedSkill[i], index),
                                  style: GoogleFonts.roboto(
                                    fontSize: kIsWeb ? 14 : 10.0,
                                    color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  )),
                            );
                          }),
                        )),
                  ),
                ),
              );
            }));
  }

  String getTagValue(LearningGoal learningGoal, int index) {
    String value = '';
    if (learningGoal.tlg.isNotEmpty) {
      if (index == 0) {
        value = learningGoal.tlg[0].P.toString();
      } else if (index == 1) {
        value = learningGoal.tlg[0].E.toString();
      } else if (index == 2) {
        value = learningGoal.tlg[0].N.toString();
      }
    }
    return value;
  }

  Row getRatingCard(LearningGoal goalModel) {
    return Row(
      children: [
        Chip(
          labelPadding: const EdgeInsets.all(5.0),
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade600,
            child: const Text("P"),
          ),
          label: const Text(
            "1",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: LightColors.kLightBlue,
          elevation: 6.0,
          shadowColor: Colors.grey[60],
          padding: const EdgeInsets.all(6.0),
        ),
      ],
    );
  }

  void updateStudentInfo() {
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
    if (action == ACTION_DOMAIN) {
      _domain = value;
      setState(() {
        generateOptions();
      });
    }
    if (action == ACTION_OBSERVATION) {
      _observation = value;
      loadDevelopmentalList();
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

  void showListBottomSheet(int action, List<String> list) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(
          start: 20,
          end: 20,
          bottom: 30,
          top: 50,
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
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsetsDirectional.only(bottom: 10),
                    width: double.infinity,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        updateSelection(action, list[index]);
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

  void getInputBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                // content padding
                child: Form(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height / 4.5,
                      // color: Colors.red,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _dayController,
                              maxLines: 2,
                              minLines: 2,
                              decoration: const InputDecoration(
                                  hintText: "Insert Culmination Day",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Culmination Day can\'t be empty';
                                } else {
                                  _dayController.text = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.black,
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() {});
                                  Navigator.of(context).pop();
                                  updateSelection(ACTION_DAY,
                                      _dayController.text.toString());
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8)),
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 25,
                                child: const Text("Save",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ));
        },
        context: context);
  }

  void getDevelopmentalData() async {
    if (kIsWeb || await Utility.isInternet()) {
      getDevelopmentalSkills();
    } else {
      loadOfflineDevelopmentSkill();
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
