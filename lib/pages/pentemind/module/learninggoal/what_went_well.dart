import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/learninggoal/get_whatwentwell.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/learninggoals/whatwentwell.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import 'learning_goal_ui.dart';

class WhatWentWellScreen extends StatefulWidget {
  String type;
  WhatWentWellScreen({super.key, required this.type});

  @override
  _WhatWentWellScreenState createState() => _WhatWentWellScreenState();
}

class _WhatWentWellScreenState extends State<WhatWentWellScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<WhatWentWellResponseModel> wwwModel = [];
  bool isLoading = true;
  late final prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String className = '';
  int programId = 0;
  final TextEditingController _wwwController = TextEditingController();

  WhatWentWellResponseModel? _selectedResponseModel;
  SaveWhatWentWellModel? _wwwRequestModel;

  String get _screenTitle =>
      widget.type == 'EVNBTR' ? 'Even Better If' : 'What Went Well';

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
    _wwwController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getWhatWentWell();
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
      getWhatWentWell();
    } else {
      getLocalData(childAdvancementSummery);
    }
  }

  bool getLocalData(data) {
    bool isLoad = false;
    try {
      wwwModel.clear();
      isLoading = false;
      WhatWentWellResponse response = WhatWentWellResponse.fromJson(
        json.decode(data!),
      );
      wwwModel.addAll(response.data);
      setState(() {});
      isLoad = true;
    } catch (e) {
      isLoad = false;
    }
    return isLoad;
  }

  String getId() {
    return '${uid.toString()}_${LocalConstant.MENU_LG_WWW}';
  }

  Future<void> savechildAdvancementSummery(String json) async {
    prefs.setString(getId(), json);
  }

  void getWhatWentWell() {
    isLoading = true;
    setState(() {});
    wwwModel.clear();
    WhatWentWellRequest request = WhatWentWellRequest(
        ProgramID: programId, InputType: widget.type, UserID: uid);

    APIService apiService = APIService();
    apiService.getWhatWentWell(request, token).then((value) {
      isLoading = false;
      if (value != null) {
        if (value is WhatWentWellResponse) {
          WhatWentWellResponse response = value;
          String json = jsonEncode(response);
          savechildAdvancementSummery(json);
          wwwModel.addAll(response.data);
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('WhatWentWell');
    return Scaffold(
      backgroundColor: LearningGoalUi.pageBackground,
      appBar: LearningGoalUi.appBar(
        title: _screenTitle,
        subtitle: className.isNotEmpty ? className : null,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: kPrimaryLightColor,
          strokeWidth: 3.0,
          onRefresh: () async {
            getWhatWentWell();
            return Future<void>.delayed(const Duration(seconds: 1));
          },
          child: getWWWList(),
        ),
      ),
    );
  }

  Widget getWWWList() {
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

    if (wwwModel.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Utility.emptyData(
            context,
            '$_screenTitle list is not available at this moment. Please check later.',
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
            itemCount: wwwModel.length,
            itemBuilder: (context, index) {
              return generateWWWListRow(wwwModel[index], constraints.maxWidth);
            },
          ),
        );
      },
    );
  }

  Widget generateWWWListRow(WhatWentWellResponseModel model, double width) {
    return LearningGoalUi.studentCardShell(
      header: LearningGoalUi.studentHeader(
        name: model.StudentName,
        subtitle: '${model.whatwentwellModel.length} entries',
        avatar: CircleAvatar(
          radius: 22,
          backgroundColor: LightColors.kLightGray,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: model.iSphoto
                ? GestureDetector(
                    onTap: () =>
                        Utility.viewimage(context, model.studentprofileURL),
                    child: Utility.getImageWidget(
                      model.studentprofileURL,
                      'assets/icons/ic_student.png',
                    ),
                  )
                : Image.asset(
                    'assets/icons/ic_student.png',
                    fit: BoxFit.cover,
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
          itemCount: model.whatwentwellModel.length,
          itemBuilder: (BuildContext context, int index) {
            return getTermCard(model, model.whatwentwellModel[index]);
          },
        ),
      ),
    );
  }

  Widget getTermCard(
      WhatWentWellResponseModel model, WhatWentWellModel wwwModel) {
    final preview = wwwModel.RefValue.isNotEmpty
        ? (wwwModel.RefValue.length > 40
            ? '${wwwModel.RefValue.substring(0, 40)}…'
            : wwwModel.RefValue)
        : 'Tap to add feedback';

    return LearningGoalUi.gridTile(
      title: wwwModel.RefKey ?? '',
      subtitle: wwwModel.Term,
      preview: preview,
      onTap: () {
        _wwwController.text =
            wwwModel.RefValue.isNotEmpty ? wwwModel.RefValue : '';
        setSelection(model, wwwModel);
        showMore('${model.StudentName} · ${wwwModel.RefKey}', wwwModel.RefValue);
      },
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: kPrimaryLightColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.edit_outlined, size: 18, color: kPrimaryLightColor),
      ),
    );
  }

  void setSelection(
      WhatWentWellResponseModel model, WhatWentWellModel wwwModel) {
    _selectedResponseModel = model;
    _wwwRequestModel = SaveWhatWentWellModel(
        RefKey: wwwModel.RefKey,
        RefValue: wwwModel.RefValue,
        StudentID: model.StudentID,
        Term: wwwModel.Term,
        Remarks: '');
  }

  void showMore(String title, String value) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _wwwController,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter feedback here…',
                    filled: true,
                    fillColor: const Color(0xFFF8F9FC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kPrimaryLightColor, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_wwwController.text.trim().isEmpty) {
                        Utility.showAlertDialog(
                            context, 'Please enter feedback and continue');
                      } else {
                        Navigator.of(ctx).pop();
                        saveWhatWentWell();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveWhatWentWell() {
    Utility.showLoaderDialog(context);
    _wwwRequestModel!.RefValue = _wwwController.text;
    List<SaveWhatWentWellModel> list = [];
    list.add(_wwwRequestModel!);
    SaveWhatWentWellRequest request = SaveWhatWentWellRequest(
        TeacherId: teacherId,
        UserId: uid,
        ProgramID: programId,
        InputType: widget.type,
        wwwModel: list);

    APIService apiService = APIService();
    apiService.saveWhatWentWell(request, token).then((value) {
      isLoading = false;
      if (value != null) {
        if (value is GenericResponse) {
          GenericResponse response = value;
          if (response.success == 200) {
            Utility.showMessage(
                context,
                response.response is String
                    ? response.response
                    : response.response.response.toString());
          }
          getWhatWentWell();
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      Navigator.of(context, rootNavigator: true).pop('dialog');
    });
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
