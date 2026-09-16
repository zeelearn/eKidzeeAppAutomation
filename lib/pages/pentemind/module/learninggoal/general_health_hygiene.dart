import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_termrequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/request/pentemind/learninggoal/GetAnecdotalGeneralHealthAndHygieneResponse.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import 'helthhygine_feedback.dart';
import 'learning_goal_ui.dart';

class GeneralHealthAndHygieneScreen extends StatefulWidget {
  const GeneralHealthAndHygieneScreen({super.key});

  @override
  _GeneralHealthAndHygieneState createState() =>
      _GeneralHealthAndHygieneState();
}

class _GeneralHealthAndHygieneState extends State<GeneralHealthAndHygieneScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<HealthAndHygieneModel> mList = [];
  bool isLoading = true;
  String uid = '';
  String teacherId = '';
  String token = '';
  String className = '';
  int programId = 0;
  String _chosenValue = 'Select Term';

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initData();
  }

  Future<void> _initData() async {
    await _getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchHealthAndHygieneData();
    }
  }

  Future<void> _getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString(LocalConstant.KEY_UID) ?? '';
      teacherId = prefs.getString(LocalConstant.KEY_USER_ID) ?? '';
      token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
      className = prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? '';
      programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;
    });

    final String? cachedData = prefs.getString(_getCacheId());
    if (cachedData != null) {
      _parseLocalData(cachedData);
    }

    _fetchHealthAndHygieneData();
  }

  void _parseLocalData(String data) {
    try {
      final response = GetAnecdotalGeneralHealthAndHygieneResponse.fromJson(
        json.decode(data),
      );
      setState(() {
        mList = response.data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error parsing local data: $e');
    }
  }

  String _getCacheId() {
    return '${uid}_${LocalConstant.MENU_LG_HELTHHYGINE}';
  }

  Future<void> _fetchHealthAndHygieneData() async {
    if (_chosenValue == 'Select Term') {
      setState(() => isLoading = false);
      return;
    }

    if (!await Utility.isInternet()) {
      if (mList.isEmpty) {
        Utility.showMessage(context, 'No Internet Connection');
      }
      setState(() => isLoading = false);
      return;
    }

    setState(() => isLoading = true);

    try {
      final request = BasePentemindTermRequest(
        Program_ID: programId,
        userId: uid,
        term: _chosenValue,
      );

      final response =
          await APIService().getAnecdotalGeneralHealthAndHygiene(request, token);

      if (response is GetAnecdotalGeneralHealthAndHygieneResponse) {
        prefs.setString(_getCacheId(), jsonEncode(response));
        setState(() {
          mList = response.data;
        });
      } else {
        Utility.showMessage(context, 'Data not found');
      }
    } catch (e) {
      debugPrint('API Error: $e');
      Utility.showMessage(context, 'Failed to fetch data');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Health and Hygiene');

    return Scaffold(
      backgroundColor: LearningGoalUi.pageBackground,
      appBar: LearningGoalUi.appBar(
        title: 'Health and Hygiene Chart',
        subtitle: className.isNotEmpty ? className : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LearningGoalUi.termSelector(
              value: _chosenValue,
              items: const [
                'Select Term',
                'Term 1',
                'Term 2',
                'Term 3',
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _chosenValue = value);
                _fetchHealthAndHygieneData();
              },
            ),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                color: Colors.white,
                backgroundColor: kPrimaryLightColor,
                onRefresh: _fetchHealthAndHygieneData,
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
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

    if (mList.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          Utility.emptyData(
            context,
            _chosenValue == 'Select Term'
                ? 'Please select a term to view hygiene records.'
                : 'No records found for this term.',
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = LearningGoalUi.contentMaxWidth(constraints.maxWidth);
        final crossCount = constraints.maxWidth >= 900 ? 2 : 1;
        return LearningGoalUi.centeredContent(
          maxWidth: maxWidth,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: LearningGoalUi.pagePadding(constraints.maxWidth),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: crossCount == 2 ? 2.8 : 2.4,
            ),
            itemCount: mList.length,
            itemBuilder: (context, index) => _buildHealthCard(mList[index]),
          ),
        );
      },
    );
  }

  Widget _buildHealthCard(HealthAndHygieneModel model) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _navigateToFeedback(model),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      model.RefKey,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryLightColor,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreItem(
                      'assets/icons/pentemind/Smile1.png', model.S1Count),
                  _buildScoreItem(
                      'assets/icons/pentemind/Smile2.png', model.S2Count),
                  _buildScoreItem(
                      'assets/icons/pentemind/Smile3.png', model.S3Count),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String asset, int? count) {
    return Column(
      children: [
        Image.asset(asset, height: 28, width: 28),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: kPrimaryLightColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            (count ?? 0).toString(),
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: kPrimaryLightColor,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToFeedback(HealthAndHygieneModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelthHygineFeedbackScreen(
          term: _chosenValue,
          model: model,
          refKey: model.RefKey,
        ),
      ),
    ).then((_) => _fetchHealthAndHygieneData());
  }

  @override
  void onClick(int action, value) {
    if (value is GenericResponse && value.success == 200) {
      Utility.showMessage(context, value.response[0].response);
    }
  }
}
