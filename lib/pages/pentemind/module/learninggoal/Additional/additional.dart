import 'dart:convert';

import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/request/pentemind/learninggoal/developmental/GetLearningGoalAcademic.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/get_day_response.dart';
import '../../../../../api/response/pentemind/learninggoals/developmental/GetLearningGoalDevelopmentalResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../globals.dart';
import '../../../../../helper/utils.dart';
import 'additional_feedback.dart';

class LGAdditionalScreen extends StatefulWidget {
  String cName;
  String observation;
  int day;
  bool isToolbar;
  bool? deepLinkingEnabled;
  String? term;

  LGAdditionalScreen(
      {super.key,
      required this.cName,
      required this.day,
      required this.observation,
      required this.isToolbar,
      this.deepLinkingEnabled,
      this.term});

  @override
  _LGAdditionalScreenState createState() => _LGAdditionalScreenState();
}

class _LGAdditionalScreenState extends State<LGAdditionalScreen>
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
  final int ACTION_DOMAIN = 23;
  final int ACTION_TERM = 24;
  GetLearningGoalDevelopmentalResponse? mSkillModel;
  GetDayResponse? dayModel;
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final focusNode = FocusNode();

  final int ACTION_OBSERVATION = 21;
  final int ACTION_DAY = 25;

  String _lasySyncDate = '';
  bool isSearch = false;

  bool isLogBookCompleted = true;
  String _term = 'Select Term';
  List<String> termList = ['Select Term', 'Term 1', 'Term 2', 'Term 3'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //getUserInfo();
    if (widget.deepLinkingEnabled != null) {
      _term = widget.term!;
      _termList.label = widget.term!;
      _chipsList.label = widget.observation;
    }
    loadData();
    //getDevelopmentalSkills();
  }

  loadData() async {
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
//     debugPrint('_AnnouncementListState didChangeAppLifecycleState $state ');
    if (state == AppLifecycleState.resumed) {
      getUserInfo();
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
    loadDevelopmentalList();
    generateOptions();
    setState(() {
      isLoading = false;
    });
  }

  String _domain = 'All Domain';
  List<String> domains = [];
  generateOptions() {
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
        if (_domain.isEmpty) _domain = domains[0];
      }
    try {
      if (_domain.isEmpty) _domain = domains[0];
    } catch (e) {}

    setState(() {
      getSortedData();
    });
  }

  loadDevelopmentalList() async {
    if (kIsWeb) {
      getDevelopmentalSkills();
      return;
    }
    bool isInternetAvaliability = await Utility.isInternet();
    var childAdvancementSummery = prefs.getString(getId());
    bool isOfflineEligble = await Utility.isOfflineEligble(
        context, prefs.getString('sync_${getId()}') ?? '');
    _lasySyncDate = prefs.getString('sync_${getId()}') ?? '';
    if (childAdvancementSummery != null &&
        (isOfflineEligble || !isInternetAvaliability)) {
//       debugPrint('oFFLINE ----');
      getLocalData(childAdvancementSummery);
    } else {
//       debugPrint('online ----');
      getDevelopmentalSkills();
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      isLoading = false;
      GetLearningGoalDevelopmentalResponse response =
          GetLearningGoalDevelopmentalResponse.fromJson(
        json.decode(data!),
      );
      mSkillModel = response;
      isLogBookCompleted = true; // response.data.LogBookCompleted;
      setState(() {});
      if (mSkillModel!.data.learningGoal.isEmpty) {
        getDevelopmentalSkills();
      }
      generateOptions();
      setState(() {});
      getSortedData();
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${programId}_${_dayController.text.toString()}_${'ADDNL'}_${LocalConstant.MENU_LG_FACILATOR_SAYS}_${'ADDNL'}';
  }

  savechildAdvancementSummery(String json, bool isSync) async {
    prefs.setString(getId(), json);
    if (isSync) {
      prefs.setString('sync_${getId()}', Utility.formatDate());
    }
    setState(() {
      _lasySyncDate = Utility.formatDate();
    });
  }

  getDevelopmentalSkills() async {
    bool isInternetAvaliability = await Utility.isInternet();
    if (_term == 'Select Term') {
    } else if (!isInternetAvaliability) {
      isInternet = false;
    } else {
      isInternet = true;
      isLoading = true;
      isLogBookCompleted = true;
      setState(() {});
      DevelopmentalRequest request = DevelopmentalRequest(
          ProgramID: programId,
          D: 0,
          Term: widget.deepLinkingEnabled == null ? _term : widget.term!,
          ObservationType: 'ADDNL');
      APIService apiService = APIService();
      print('DevelopmentalRequest Request : ${request.toJson()}');
      apiService
          .getLearningGoalDevelopmentalAdditional(request, token)
          .then((value) {
        if (value != null) {
          isLoading = false;
          if (value == null) {
            Utility.showMessage(context, 'data not found');
          } else if (value is GetLearningGoalDevelopmentalResponse) {
            GetLearningGoalDevelopmentalResponse response = value;
            isLogBookCompleted = true; // response.data.LogBookCompleted;
            String json = jsonEncode(response);
            savechildAdvancementSummery(json, true);
            mSkillModel = response;
            generateOptions();
            //getSortedData();
            //setState(() {});
          } else {
            Utility.showMessage(context, 'data not found');
          }
        }
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//     debugPrint('LG-Additional........');
    FirebaseAnalyticsUtils().sendAnalyticsEvent('LG-Developmental');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.isToolbar
            ? AppBar(
                title: const Text('Additional'),
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

  getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (_term == 'Select Term') {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          children: [
            //getHeader(),
            getHint(),
            Utility.filter(context, 'Please Select Term')
          ],
        ),
      );
    } else if (mSkillModel == null) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          children: [
            //getHeader(),
            getHint(),
            !isInternet
                ? Utility.noInternet(context)
                : Utility.emptyData(context,
                    "Observation are not avaliable, Please check again")
          ],
        ),
      );
    } else if (mSkillModel?.data.learningGoal == null ||
        mSkillModel!.data.learningGoal.isEmpty) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          children: [
            //getHeader(),
            getHint(),
            !isInternet
                ? Utility.noInternet(context)
                : Utility.emptyData(context,
                    "Observation are not avaliable, Please check again")
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          children: [
            //getHeader(),
            getHint(),
            _lasySyncDate.isEmpty
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

  getHint() {
    return isSearch
        ? Card(
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Container(
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width / 0.7,
                child: TextFormField(
                  controller: _searchController,
                  textInputAction: TextInputAction.go,
                  style: LightColors.textHeaderStyle13,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'search here..',
                    counterText: "",
                    fillColor: Colors.white60,
                    suffixIcon: InkWell(
                      onTap: () {
                        resetSearch();
                        getSortedData();
                      },
                      child: !isSearch
                          ? const Icon(Icons.search)
                          : const Icon(Icons.clear),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
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
                    //if(val.length>1)
                    setState(() {
                      _dayController.text = val.toString();
                      getSortedData();
                    });
                  },
                  onFieldSubmitted: (val) {
                    setState(() {
                      _dayController.text = val.toString();
                      getSortedData();
                      resetSearch();
                    });
                  },
                ),
              ),
            ),
          )
        :
        //true ? AnimatedFilterBar() :
        Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      //width: (Get.width * 0.15) <100 ? 100 : Get.width * 0.15,
                      width: Responsive.isMobile(context)
                          ? Get.width * 0.2
                          : Get.width * 0.2,
                      child: InkWell(
                        onTap: () {
                          showListBottomSheet(_termList.index, termList);
                        },
                        child: Card(
                          color: LightColors.kLightGray1,
                          elevation: 5,
                          shadowColor: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 5, top: 10, bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _termList.label.length > 25
                                      ? '${_termList.label.substring(0, 25)}...'
                                      : _termList.label,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: LightColors.textHeaderStyle13Selected
                                      .copyWith(color: kPrimaryLightColor),
                                ),
                                // SizedBox(
                                //   width: 10,
                                // ),
                                const Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Responsive.isMobile(context)
                          ? Get.width * 0.6
                          : Get.width * 0.4,
                      //width:  size.width * 0.25,
                      child: InkWell(
                        onTap: () {
                          showListBottomSheet(_chipsList.index, domains);
                        },
                        child: Card(
                          color: LightColors.kLightGray1,
                          elevation: 5,
                          shadowColor: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 5, top: 10, bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _chipsList.label,
                                    overflow: TextOverflow.ellipsis,
                                    style: LightColors.textHeaderStyle13Selected
                                        .copyWith(color: kPrimaryLightColor),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                const Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    _term == 'Select Term'
                        ? const SizedBox(
                            width: 1,
                          )
                        : SizedBox(
                            width: 40,
                            child: IconsButton(
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
                          ),
                  ],
                ),
              ),
            ],
          );
  }

  reset() {
    loadDevelopmentalList();
  }

  /*getHeader() {
    return Container(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            color: LightColors.kLightGray1,
            child: getHeaderNew(),
          ),
          GestureDetector(
                onTap: () {
                  getInputBottomSheet();
                },
                child: SizedBox(
                  height: 40.0,
                  child: TextFormField(
                    controller: _dayController,
                    style: LightColors.textHeaderStyle13,
                    decoration: InputDecoration(
                      labelText: 'search here..',
                      counterText: "",
                      fillColor: Colors.white60,
                      suffixIcon: InkWell(
                        onTap: (){
//                           debugPrint('onTap--');
                          setState(() {
                            _dayController.clear();
                            getSortedData();
                          });
                        },
                        child: _dayController.text.isEmpty ?  Icon(Icons.search) : Icon(Icons.clear),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(
                          color: LightColors.kLightGray,
                          width: 1.0,
                        ),
                      ),
                    ),
                    //initialValue: _dayController.text.toString(),
                    onChanged: (val){

                      if(val.length>1)
                      setState(() {
                        _dayController.text = val.toString();
                        getSortedData();
                      });
                    },
                    onFieldSubmitted: (val) {

                      setState(() {
                        _dayController.text = val.toString();
                        getSortedData();
                      });
                    },
                  ),
                ),
              ),

        ],
      ),
    );
  }*/

  final Filters _chipsList = Filters('All Domain', 1, Colors.white, true);
  final Filters _termList = Filters('Select Term', 24, Colors.white, true);

  Widget getHeaderNew() {
    return Container(
      padding: const EdgeInsets.only(left: 3, right: 3),
      color: kPrimaryLightColor,
      child: FilterChip(
        avatar: const CircleAvatar(
          backgroundColor: LightColors.kLightGrayM,
          child: Icon(Icons.keyboard_arrow_down),
        ),
        label: Text(_chipsList.label.length > 15
            ? '${_chipsList.label.substring(0, 15)}...'
            : _chipsList.label),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
        backgroundColor: kPrimaryLightColor,
        // selectedColor: kPrimaryLightColor,
        // disabledColor: kPrimaryLightColor,
        selected: _chipsList.isSelected,
        onSelected: (bool value) {
          if (_chipsList.index == ACTION_DAY) {
            getInputBottomSheet();
          }
        },
      ),
    );
  }

  updateSelection(int action, String value) {
    if (action == ACTION_DAY) {
      //reset();
      loadDevelopmentalList();
    }
    setState(() {});
  }

  final List<String> _dynamicChips = ['P', 'E', 'N'];
  final List<Color> _colorChips = [
    LightColors.kGreen,
    LightColors.kBlue,
    LightColors.kRed
  ];
  List<LearningGoal> mSortedSkill = [];

  getSortedData() {
    mSortedSkill.clear();
    if (mSkillModel != null)
      for (int index = 0;
          index < mSkillModel!.data.learningGoal.length;
          index++) {
        if (_domain == 'All Domain' ||
            _domain == mSkillModel!.data.learningGoal[index].DomainName) {
          if (_searchController.text.toString().isEmpty ||
              mSkillModel!.data.learningGoal[index].LearningGoals
                  .toLowerCase()
                  .contains(_searchController.text.toString().toLowerCase())) {
            mSortedSkill.add(mSkillModel!.data.learningGoal[index]);
          }
        }
      }

//     debugPrint('Sorted list ${mSortedSkill.length}');
    setState(() {
      isLoading = false;
    });
  }

  resetSearch() {
    isSearch = false;
    _searchController.text = '';
  }

  getContent() {
    return Container(
      color: Colors.white,
      child: Card(
          color: Colors.white,
          child: ListView.builder(
            itemCount: mSortedSkill.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  //resetSearch();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DevelopmentalFeedback(
                              model: mSortedSkill[i],
                              day: 0,
                              observation: "ADDNL",
                            )),
                  ).then((value) {
                    if (value is LearningGoal) {
//                       debugPrint('Response received....Learning Goal.');
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
                    } else {
                      getDevelopmentalSkills();
                      //debugPrint('-----------------its NOT ALearnig Goal');
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Card(
                    color: isLogBookCompleted
                        ? Colors.white
                        : LightColors.kLightGray1,
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
                                    fontSize: 10.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                              label: Text(getTagValue(mSortedSkill[i], index),
                                  style: GoogleFonts.roboto(
                                    fontSize: 10.0,
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
            },
          )),
    );
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

  getRatingCard(LearningGoal goalModel) {
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
    resetSearch();
//     debugPrint('onclick $action $value');
    if (action == ACTION_DOMAIN) {
      _domain = value;
      setState(() {
        generateOptions();
      });
    } else if (action == ACTION_TERM) {
      _term = value;
      setState(() {
        getDevelopmentalSkills();
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

  showListBottomSheet(int action, List<String> list) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(
            start: 10,
            end: 10,
            bottom: 30,
            top: 10,
          ),
          child: Wrap(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  list.length,
                  (index) => Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    color: list[index] == _term
                        ? LightColors.kLightGray1
                        : Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        //updateSelection(action, list[index]);
                        if (action == 24) {
                          _termList.label = list[index];
                          _term = list[index];
                          setState(() {
                            getDevelopmentalSkills();
                          });
                        } else {
                          _chipsList.label = list[index];
                          _domain = list[index];
                        }

                        getSortedData();
                      },
                      child: MyWidget()
                          .richText(list[index], LightColors.textbigStyle),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getInputBottomSheet() {
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
}

class Filters {
  String label;
  Color color;
  bool isSelected;
  int index;

  Filters(this.label, this.index, this.color, this.isSelected);
}

class AnimatedFilterBar extends StatelessWidget {
  AnimatedFilterBar({super.key});

  final _ctrl = Get.put(_FilterBarController());

  final _termList = _Item(index: 0, label: 'Select Term');
  final _chipsList = _Item(index: 0, label: 'All Domains');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _ctrl.updateLayout(constraints.maxWidth);

          return AnimatedBuilder(
            animation: _ctrl.animController,
            builder: (_, __) {
              return _fadeThrough(
                animation: _ctrl.animController,
                child: _ReactiveLayout(
                  ctrl: _ctrl,
                  width: constraints.maxWidth,
                  term: _termList,
                  domain: _chipsList,
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Material 3 Fade-through
  Widget _fadeThrough({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

/* ============================================================ */
/*                 ONLY THIS WIDGET IS REACTIVE                  */
/* ============================================================ */

class _ReactiveLayout extends StatelessWidget {
  const _ReactiveLayout({
    required this.ctrl,
    required this.width,
    required this.term,
    required this.domain,
  });

  final _FilterBarController ctrl;
  final double width;
  final _Item term;
  final _Item domain;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ctrl.isMobile.value ? _mobile() : _web();
    });
  }

  Widget _mobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dropdown(term.label),
        const SizedBox(height: 12),
        _dropdown(domain.label),
        const SizedBox(height: 12),
        _searchIcon(alignRight: true),
      ],
    );
  }

  Widget _web() {
    return Row(
      children: [
        SizedBox(width: width * 0.20, child: _dropdown(term.label)),
        const SizedBox(width: 12),
        SizedBox(width: width * 0.35, child: _dropdown(domain.label)),
        const Spacer(),
        _searchIcon(),
      ],
    );
  }

  Widget _dropdown(String label) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(Get.context!).textTheme.labelLarge,
              ),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
      ),
    );
  }

  /// 🔍 Shared Axis (only icon is reactive)
  Widget _searchIcon({bool alignRight = false}) {
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.center,
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: IconButton(
            key: ValueKey(ctrl.isSearch.value),
            icon: Icon(
              ctrl.isSearch.value ? Icons.close : Icons.search,
            ),
            onPressed: ctrl.toggleSearch,
          ),
        ),
      ),
    );
  }
}

/* ============================================================ */
/*                     GETX CONTROLLER                           */
/* ============================================================ */

class _FilterBarController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animController;

  final isMobile = true.obs;
  final isSearch = false.obs;

  @override
  void onInit() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.onInit();
  }

  void updateLayout(double width) {
    final mobile = width < 600;
    if (isMobile.value != mobile) {
      isMobile.value = mobile;
      animController.forward(from: 0);
    }
  }

  void toggleSearch() => isSearch.toggle();

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }
}

/* ============================================================ */
/*                         MODEL                                 */
/* ============================================================ */

class _Item {
  final int index;
  final String label;

  _Item({required this.index, required this.label});
}
