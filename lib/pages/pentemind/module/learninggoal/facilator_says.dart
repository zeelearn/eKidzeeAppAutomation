import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_termrequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/pentemind/module/learninggoal/facilatorsays_mind.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import 'learning_goal_ui.dart';

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
  String token = '';
  String className = '';
  int programId = 0;
  String _chosenValue = 'Term 1';

  @override
  void initState() {
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
    if (state == AppLifecycleState.resumed) {
      getFacilatorSaysList();
    }
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
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
      isLoading = false;
      if (value != null) {
        if (value is FacilatorSaysResponse) {
          FacilatorSaysResponse response = value;
          String json = jsonEncode(response);
          savechildAdvancementSummery(json);
          facilatorSaysList.addAll(response.data);
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Facilitator Says');
    return Scaffold(
      backgroundColor: LearningGoalUi.pageBackground,
      appBar: LearningGoalUi.appBar(
        title: 'Facilitator Says',
        subtitle: className.isNotEmpty ? className : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LearningGoalUi.termSelector(
              value: _chosenValue,
              items: const ['Term 1', 'Term 2', 'Term 3'],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _chosenValue = value);
                getFacilatorSaysList();
              },
            ),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                color: Colors.white,
                backgroundColor: kPrimaryLightColor,
                strokeWidth: 3.0,
                onRefresh: () async {
                  getFacilatorSaysList();
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: getChildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getChildList() {
    if (isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: LearningGoalUi.loading(),
          ),
        ],
      );
    }

    if (facilatorSaysList.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          Utility.emptyData(
            context,
            'Facilitator Says list is not available at this moment. Please check later.',
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = LearningGoalUi.contentMaxWidth(constraints.maxWidth);
        return LearningGoalUi.centeredContent(
          maxWidth: maxWidth,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: LearningGoalUi.pagePadding(constraints.maxWidth),
            itemCount: facilatorSaysList.length,
            itemBuilder: (context, index) {
              return generateListRow(
                  facilatorSaysList[index], constraints.maxWidth);
            },
          ),
        );
      },
    );
  }

  Widget generateListRow(FacilatorSaysModel model, double width) {
    return LearningGoalUi.studentCardShell(
      header: LearningGoalUi.studentHeader(
        name: model.Mind,
        subtitle: '${model.Observation.length} observations · $_chosenValue',
        avatar: CircleAvatar(
          radius: 22,
          backgroundColor: kPrimaryLightColor.withValues(alpha: 0.1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              'assets/icons/pentemind/${model.ImgName}.png',
              height: 36,
              width: 36,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.psychology_outlined,
                color: kPrimaryLightColor,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: LearningGoalUi.gridCrossAxisCount(width),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: LearningGoalUi.gridChildAspectRatio(width),
          ),
          itemCount: model.Observation.length,
          itemBuilder: (BuildContext context, int index) {
            return getTermCard(model, model.Observation[index]);
          },
        ),
      ),
    );
  }

  Widget getTermCard(
      FacilatorSaysModel facilatorSaysModel, FacilatorObservation model) {
    final remarksPreview = model.Remarks.isNotEmpty
        ? (model.Remarks.length > 40
            ? '${model.Remarks.substring(0, 40)}…'
            : model.Remarks)
        : 'Tap to add observations';

    return LearningGoalUi.gridTile(
      title: model.RefKey,
      preview: remarksPreview,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FacilatorSaysMindFeedbackScreen(
              term: _chosenValue,
              facilatorSaysModel: facilatorSaysModel,
              Observation: facilatorSaysModel.Observation,
            ),
          ),
        ).then((_) => getFacilatorSaysList());
      },
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: kPrimaryLightColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          model.RefCount.toString(),
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: kPrimaryLightColor,
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
}
