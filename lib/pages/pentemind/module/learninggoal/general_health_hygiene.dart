import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_termrequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/request/pentemind/learninggoal/GetAnecdotalGeneralHealthAndHygieneResponse.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/facilatorsays/get_facilator_says.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import 'helthhygine_feedback.dart';

/// Screen to display and manage Child's General Health and Hygiene Chart.
/// 
/// This screen allows teachers to view health and hygiene anecdotal records
/// filtered by academic terms.
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

  // State variables
  List<HealthAndHygieneModel> mList = [];
  bool isLoading = true;
  String uid = '';
  String teacherId = '';
  String userType = '';
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

  /// Initial entry point to load configuration and data.
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
    // Refresh data when app returns to foreground
    if (state == AppLifecycleState.resumed) {
      _fetchHealthAndHygieneData();
    }
  }

  /// Retrieves user session details from SharedPreferences.
  Future<void> _getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString(LocalConstant.KEY_UID) ?? '';
      teacherId = prefs.getString(LocalConstant.KEY_USER_ID) ?? '';
      userType = prefs.getString(LocalConstant.KEY_USER_TYPE) ?? '';
      token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
      className = prefs.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? '';
      programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;
    });

    // Check for cached data locally before hitting the API
    final String? cachedData = prefs.getString(_getCacheId());
    if (cachedData != null) {
      _parseLocalData(cachedData);
    }
    
    // Always fetch fresh data to ensure accuracy
    _fetchHealthAndHygieneData();
  }

  /// Parses locally stored JSON data into the model list.
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

  /// Fetches Health and Hygiene data from the remote server.
  Future<void> _fetchHealthAndHygieneData() async {
    if (_chosenValue == 'Select Term') {
      setState(() => isLoading = false);
      return;
    }

    if (!await Utility.isInternet()) {
      Utility.showMessage(context, 'No Internet Connection');
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

      final response = await APIService().getAnecdotalGeneralHealthAndHygiene(request, token);

      if (response is GetAnecdotalGeneralHealthAndHygieneResponse) {
        // Cache data for offline usage
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
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Health and Hygiene');
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Health and Hygiene Chart',
          style: GoogleFonts.roboto(fontSize: 16.0, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kPrimaryLightColor,
        elevation: 2,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _fetchHealthAndHygieneData,
          child: _buildBody(),
        ),
      ),
    );
  }

  /// Build the main UI content based on state.
  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust layout based on screen width
        final double horizontalPadding = constraints.maxWidth > 600 ? 32 : 16;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildTermDropdown(horizontalPadding),
            Expanded(
              child: mList.isEmpty
                  ? _buildEmptyState()
                  : _buildHealthList(horizontalPadding),
            ),
          ],
        );
      },
    );
  }

  /// Build the term selection dropdown.
  Widget _buildTermDropdown(double padding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
           Icon(Icons.calendar_month, color: kPrimaryLightColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _chosenValue,
                isExpanded: true,
                items: <String>['Select Term', 'Term 1', 'Term 2', 'Term 3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _chosenValue = value!);
                  _fetchHealthAndHygieneData();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// UI for empty data state.
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 400,
        alignment: Alignment.center,
        child: Utility.emptyData(
          context,
          _chosenValue == 'Select Term'
              ? 'Please select a term to view hygiene records.'
              : "No records found for this term.",
        ),
      ),
    );
  }

  /// Build the scrollable list of health records.
  Widget _buildHealthList(double padding) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      itemCount: mList.length,
      itemBuilder: (context, index) {
        return _buildHealthCard(mList[index]);
      },
    );
  }

  /// Individual card representing a hygiene category.
  Widget _buildHealthCard(HealthAndHygieneModel model) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToFeedback(model),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.RefKey,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: kPrimaryLightColor),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScoreItem("assets/icons/pentemind/Smile1.png", model.S1Count),
                  _buildScoreItem("assets/icons/pentemind/Smile2.png", model.S2Count),
                  _buildScoreItem("assets/icons/pentemind/Smile3.png", model.S3Count),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper to build the smiley icon and its count.
  Widget _buildScoreItem(String asset, int? count) {
    return Row(
      children: [
        Image.asset(asset, height: 24, width: 24),
        const SizedBox(width: 8),
        Text(
          (count ?? 0).toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  /// Handles navigation to the feedback/entry screen.
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
