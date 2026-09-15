import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/api/request/pentemind/learninggoal/www/SaveWhatWentWellRequest.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/learninggoals/childinfo/ChildInformationResponse.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/utils.dart';
import '../../../../utils/theme/colors/light_colors.dart';

/// Screen for managing Child's Personal Information (Height, Weight, etc.).
/// 
/// Adheres to professional coding standards with modular structure, 
/// responsive UI, and optimized logic.
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

  // State Variables
  List<ChildInformationList> childInformationList = [];
  bool isLoading = true;
  late SharedPreferences prefs;
  
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
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

  /// Entry point to load user info and initial list.
  Future<void> _initializeData() async {
    await _getUserInfo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchChildInformation();
    }
  }

  /// Fetches essential user details from persistent storage.
  Future<void> _getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) ?? "";
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) ?? "";
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) ?? "";
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) ?? "";
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;

    // Load from local cache if available for offline responsiveness
    final String? cachedData = prefs.getString(_getCacheId());
    if (cachedData != null) {
      _loadLocalData(cachedData);
    }
    
    // Refresh with fresh data from API
    _fetchChildInformation();
  }

  /// Returns unique ID for caching child information based on user.
  String _getCacheId() {
    return "${uid}_${LocalConstant.MENU_LG_CHILD_INFORMATION}";
  }

  /// Processes cached data to populate UI instantly.
  void _loadLocalData(String data) {
    try {
      final response = ChildInformationResponse.fromJson(json.decode(data));
      setState(() {
        childInformationList = response.childInformationList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Cache parsing error: $e");
    }
  }

  /// Fetches updated child information from the server.
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
        // Update cache
        prefs.setString(_getCacheId(), jsonEncode(response));
        setState(() {
          childInformationList = response.childInformationList;
        });
      } else {
        Utility.showMessage(context, "Data not found");
      }
    } catch (e) {
      debugPrint("API Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent("LG-Child Information");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: kPrimaryLightColor,
          onRefresh: _fetchChildInformation,
          child: _buildBody(),
        ),
      ),
    );
  }

  /// Modular AppBar construction.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: Text(
        "Child's Personal Information",
        style: GoogleFonts.roboto(fontSize: 14.0, color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: kPrimaryLightColor,
      elevation: 4,
    );
  }

  /// Builds the main content area with responsive checks.
  Widget _buildBody() {
    if (isLoading && childInformationList.isEmpty) {
      return Center(child: Lottie.asset("assets/json/kidzee_loader.json"));
    }

    if (childInformationList.isEmpty) {
      return Utility.emptyData(context, "No information available at this moment.");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust padding for tablets/wide screens
        final horizontalPadding = constraints.maxWidth > 600 ? 32.0 : 8.0;
        
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
          itemCount: childInformationList.length,
          itemBuilder: (context, index) {
            return _buildChildCard(childInformationList[index], index);
          },
        );
      },
    );
  }

  /// Individual card for each child.
  Widget _buildChildCard(ChildInformationList model, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildCardHeader(model, index),
          const Divider(height: 1),
          _buildInformationTable(model, index),
        ],
      ),
    );
  }

  /// Header section of the child card with edit toggle.
  Widget _buildCardHeader(ChildInformationList model, int index) {
    return ListTile(
      title: Text(
        model.StudentName,
        style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: kPrimaryLightColor),
      ),
      trailing: IconButton(
        icon: Icon(
          model.isEdit ? Icons.check_circle : Icons.edit,
          color: model.isEdit ? Colors.green : Colors.grey,
          size: 28,
        ),
        onPressed: () => _toggleEdit(index, model),
      ),
    );
  }

  /// Toggles editing state and submits if switching from edit to view.
  Future<void> _toggleEdit(int index, ChildInformationList model) async {
    if (model.isEdit) {
      // Switched from edit to save
      await _submitUpdate(model);
    }
    
    setState(() {
      model.isEdit = !model.isEdit;
    });
  }

  /// Build the data table for height and weight entries.
  Widget _buildInformationTable(ChildInformationList model, int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text("Metric", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Start - AY", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("End - AY", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          _buildDataRow(
            "Height (cm)",
            model.StartTermHeight,
            model.EndTermHeight,
            (val) => model.StartTermHeight = val,
            (val) => model.EndTermHeight = val,
            model.isEdit,
          ),
          _buildDataRow(
            "Weight (kg)",
            model.StartTermWeight,
            model.EndTermWeight,
            (val) => model.StartTermWeight = val,
            (val) => model.EndTermWeight = val,
            model.isEdit,
          ),
        ],
      ),
    );
  }

  /// Helper to create a single DataRow (view or edit mode).
  DataRow _buildDataRow(
    String label,
    String startVal,
    String endVal,
    Function(String) onStartChange,
    Function(String) onEndChange,
    bool isEdit,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(label)),
        DataCell(
          isEdit
              ? _buildInputField(startVal, onStartChange)
              : Text(startVal.isEmpty ? "NA" : startVal),
        ),
        DataCell(
          isEdit
              ? _buildInputField(endVal, onEndChange)
              : Text(endVal.isEmpty ? "NA" : endVal),
        ),
      ],
    );
  }

  /// Customized input field for the data table.
  Widget _buildInputField(String initialValue, Function(String) onChanged) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 13),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"(^\d{0,3}\.?\d{0,2})")),
        ],
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          border: UnderlineInputBorder(),
        ),
        onChanged: (val) {
          onChanged(val);
          setState(() {}); // Reflect updates locally
        },
      ),
    );
  }

  /// Submits the updated height/weight data for a specific student.
  Future<void> _submitUpdate(ChildInformationList model) async {
    Utility.showLoaderDialog(context);
    
    try {
      final List<SaveWhatWentWellModel> data = [
        SaveWhatWentWellModel(
          RefKey: "Height",
          RefValue: model.StartTermHeight,
          StudentID: int.parse(model.StudentID),
          Term: "Term 1",
          Remarks: "",
        ),
        SaveWhatWentWellModel(
          RefKey: "Height",
          RefValue: model.EndTermHeight,
          StudentID: int.parse(model.StudentID),
          Term: "Term 3",
          Remarks: "",
        ),
        SaveWhatWentWellModel(
          RefKey: "Weight",
          RefValue: model.StartTermWeight,
          StudentID: int.parse(model.StudentID),
          Term: "Term 1",
          Remarks: "",
        ),
        SaveWhatWentWellModel(
          RefKey: "Weight",
          RefValue: model.EndTermWeight,
          StudentID: int.parse(model.StudentID),
          Term: "Term 3",
          Remarks: "",
        ),
      ];

      final request = SaveWhatWentWellRequest(
        TeacherId: teacherId,
        UserId: uid,
        ProgramID: programId,
        InputType: "CHILDINFO",
        wwwModel: data,
      );

      final response = await APIService().insertStudentAnecdotal(request, token);

      if (response is GenericResponse && response.success == 200) {
        Utility.showMessage(context, response.response is String ? response.response : "Information updated successfully");
      } else {
        Utility.showMessage(context, "Update failed");
      }
    } catch (e) {
      debugPrint("Submission error: $e");
      Utility.showMessage(context, "An error occurred during update");
    } finally {
      Navigator.of(context, rootNavigator: true).pop("dialog");
    }
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Navigator.of(context, rootNavigator: true).pop("dialog");
      Utility.showMessage(context, value.toString());
    }
  }
}
