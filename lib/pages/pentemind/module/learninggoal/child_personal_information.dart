import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/learninggoals/childinfo/ChildInformationResponse.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import 'learning_goal_ui.dart';

class ChildPersonalinformationScreen extends StatefulWidget {
  const ChildPersonalinformationScreen({super.key});

  @override
  _ChildPersonalState createState() => _ChildPersonalState();
}

class _ChildPersonalState extends State<ChildPersonalinformationScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<ChildInformationList> childInformationList = [];
  bool isLoading = true;
  late SharedPreferences prefs;

  String uid = '';
  String teacherId = '';
  String token = '';
  String className = '';
  int programId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _getUserInfo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchChildInformation();
    }
  }

  Future<void> _getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) ?? '';
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) ?? '';
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    className =
        prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? '';
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;

    final String? cachedData = prefs.getString(_getCacheId());
    if (cachedData != null) {
      _loadLocalData(cachedData);
    }

    _fetchChildInformation();
  }

  String _getCacheId() {
    return '${uid}_${LocalConstant.MENU_LG_CHILD_INFORMATION}';
  }

  void _loadLocalData(String data) {
    try {
      final response = ChildInformationResponse.fromJson(json.decode(data));
      setState(() {
        childInformationList = response.childInformationList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Cache parsing error: $e');
    }
  }

  Future<void> _fetchChildInformation() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      if (!await Utility.isInternet()) {
        setState(() => isLoading = false);
        return;
      }

      final request = BasePentemindRequest(Program_ID: programId, userId: uid);
      final response = await APIService().getChildInformation(request, token);

      if (response is ChildInformationResponse) {
        prefs.setString(_getCacheId(), jsonEncode(response));
        setState(() {
          childInformationList = response.childInformationList;
        });
      } else {
        Utility.showMessage(context, 'Data not found');
      }
    } catch (e) {
      debugPrint('API Error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('LG-Child Information');
    return Scaffold(
      backgroundColor: LearningGoalUi.pageBackground,
      appBar: LearningGoalUi.appBar(
        title: "Child's Personal Information",
        subtitle: className.isNotEmpty ? className : null,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: kPrimaryLightColor,
          onRefresh: _fetchChildInformation,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading && childInformationList.isEmpty) {
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

    if (childInformationList.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Utility.emptyData(
              context, 'No information available at this moment.'),
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
            itemCount: childInformationList.length,
            itemBuilder: (context, index) {
              return _buildChildCard(childInformationList[index], index);
            },
          ),
        );
      },
    );
  }

  Widget _buildChildCard(ChildInformationList model, int index) {
    return LearningGoalUi.studentCardShell(
      header: LearningGoalUi.studentHeader(
        name: model.StudentName,
        subtitle: 'Height & weight · academic year',
        avatar: CircleAvatar(
          radius: 22,
          backgroundColor: kPrimaryLightColor.withValues(alpha: 0.1),
          child: Icon(Icons.person_outline, color: kPrimaryLightColor),
        ),
        trailing: Material(
          color: model.isEdit
              ? Colors.green.withValues(alpha: 0.12)
              : kPrimaryLightColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _toggleEdit(index, model),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    model.isEdit ? Icons.check : Icons.edit_outlined,
                    size: 18,
                    color: model.isEdit ? Colors.green : kPrimaryLightColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    model.isEdit ? 'Save' : 'Edit',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: model.isEdit ? Colors.green : kPrimaryLightColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 480) {
              return _buildWideMetrics(model);
            }
            return _buildNarrowMetrics(model);
          },
        ),
      ),
    );
  }

  Widget _buildWideMetrics(ChildInformationList model) {
    return Row(
      children: [
        Expanded(child: _metricBlock('Height (cm)', model, isHeight: true)),
        const SizedBox(width: 12),
        Expanded(child: _metricBlock('Weight (kg)', model, isHeight: false)),
      ],
    );
  }

  Widget _buildNarrowMetrics(ChildInformationList model) {
    return Column(
      children: [
        _metricBlock('Height (cm)', model, isHeight: true),
        const SizedBox(height: 10),
        _metricBlock('Weight (kg)', model, isHeight: false),
      ],
    );
  }

  Widget _metricBlock(
    String label,
    ChildInformationList model, {
    required bool isHeight,
  }) {
    final startVal = isHeight ? model.StartTermHeight : model.StartTermWeight;
    final endVal = isHeight ? model.EndTermHeight : model.EndTermWeight;
    final onStart = isHeight
        ? (String v) => model.StartTermHeight = v
        : (String v) => model.StartTermWeight = v;
    final onEnd = isHeight
        ? (String v) => model.EndTermHeight = v
        : (String v) => model.EndTermWeight = v;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kPrimaryLightColor,
            ),
          ),
          const SizedBox(height: 10),
          _metricRow('Start - AY', startVal, onStart, model.isEdit),
          const SizedBox(height: 8),
          _metricRow('End - AY', endVal, onEnd, model.isEdit),
        ],
      ),
    );
  }

  Widget _metricRow(
    String termLabel,
    String value,
    Function(String) onChanged,
    bool isEdit,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            termLabel,
            style: GoogleFonts.roboto(fontSize: 12, color: Colors.black54),
          ),
        ),
        Expanded(
          flex: 2,
          child: isEdit
              ? _buildInputField(value, onChanged)
              : Text(
                  value.isEmpty ? 'NA' : value,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _toggleEdit(int index, ChildInformationList model) async {
    if (model.isEdit) {
      await _submitUpdate(model);
    }
    setState(() {
      model.isEdit = !model.isEdit;
    });
  }

  Widget _buildInputField(String initialValue, Function(String) onChanged) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: GoogleFonts.roboto(fontSize: 14),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'(^\d{0,3}\.?\d{0,2})')),
      ],
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kPrimaryLightColor),
        ),
      ),
      onChanged: (val) {
        onChanged(val);
        setState(() {});
      },
    );
  }

  Future<void> _submitUpdate(ChildInformationList model) async {
    Utility.showLoaderDialog(context);

    try {
      final List<SaveWhatWentWellModel> data = [
        SaveWhatWentWellModel(
          RefKey: 'Height',
          RefValue: model.StartTermHeight,
          StudentID: int.parse(model.StudentID),
          Term: 'Term 1',
          Remarks: '',
        ),
        SaveWhatWentWellModel(
          RefKey: 'Height',
          RefValue: model.EndTermHeight,
          StudentID: int.parse(model.StudentID),
          Term: 'Term 3',
          Remarks: '',
        ),
        SaveWhatWentWellModel(
          RefKey: 'Weight',
          RefValue: model.StartTermWeight,
          StudentID: int.parse(model.StudentID),
          Term: 'Term 1',
          Remarks: '',
        ),
        SaveWhatWentWellModel(
          RefKey: 'Weight',
          RefValue: model.EndTermWeight,
          StudentID: int.parse(model.StudentID),
          Term: 'Term 3',
          Remarks: '',
        ),
      ];

      final request = SaveWhatWentWellRequest(
        TeacherId: teacherId,
        UserId: uid,
        ProgramID: programId,
        InputType: 'CHILDINFO',
        wwwModel: data,
      );

      final response =
          await APIService().insertStudentAnecdotal(request, token);

      if (response is GenericResponse && response.success == 200) {
        Utility.showMessage(
            context,
            response.response is String
                ? response.response
                : 'Information updated successfully');
      } else {
        Utility.showMessage(context, 'Update failed');
      }
    } catch (e) {
      debugPrint('Submission error: $e');
      Utility.showMessage(context, 'An error occurred during update');
    } finally {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utility.showMessage(context, value.toString());
    }
  }
}
