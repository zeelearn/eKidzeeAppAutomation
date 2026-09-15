import 'package:ekidzee/api/request/pentemind/facilatortool/insert_logbook.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/facilatortool/logbookResponse.dart';
import '../../../../../constants.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/DatabaseHelper.dart';
import '../../../../../helper/utils.dart';
import '../../../../notification/NotificationService.dart';

class LogbookDetailsScreen extends StatefulWidget {
  final LogbookModel logbookModel;
  final String day;
  final String? programId;

  const LogbookDetailsScreen({
    required this.logbookModel,
    required this.day,
    this.programId,
    super.key,
  });

  @override
  State<LogbookDetailsScreen> createState() => _LogbookDetailsScreenState();
}

class _LogbookDetailsScreenState extends State<LogbookDetailsScreen>
    implements onClickListener {
  final TextEditingController _remarkController = TextEditingController();

  static const List<String> _options = [
    'Select',
    'Completed',
    'Partially Completed',
    'Not Completed',
  ];

  String _chosenValue = 'Select';
  bool isLoading = false;
  bool isSubmitting = false;

  SharedPreferences? prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  int programId = 0;

  bool get _canEdit =>
      userType == 'TEACH' ||
      userType == 'SRTEA' ||
      userType == 'CC' ||
      userType == 'CM' ||
      userType == 'F';

  @override
  void initState() {
    super.initState();
    _chosenValue = _mapStatusToLabel(widget.logbookModel.StatusCode);
    if ((widget.logbookModel.Remarks ?? '').isNotEmpty) {
      _remarkController.text = widget.logbookModel.Remarks!;
    }
    _loadUserInfo();
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  String _mapStatusToLabel(String code) {
    switch (code) {
      case 'C':
        return 'Completed';
      case 'PC':
        return 'Partially Completed';
      case 'NC':
        return 'Not Completed';
      default:
        return 'Select';
    }
  }

  String _mapLabelToCode(String label) {
    switch (label) {
      case 'Completed':
        return 'C';
      case 'Partially Completed':
        return 'PC';
      case 'Not Completed':
        return 'NC';
      default:
        return '';
    }
  }

  Color _statusColor(String label) {
    switch (label) {
      case 'Completed':
        return Colors.green.shade700;
      case 'Partially Completed':
        return Colors.orange.shade700;
      case 'Not Completed':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Future<void> _loadUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs?.getString(LocalConstant.KEY_UID) ?? '';
    teacherId = prefs?.getString(LocalConstant.KEY_USER_ID) ?? '';
    userType = prefs?.getString(LocalConstant.KEY_USER_TYPE) ?? '';
    token = prefs?.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    programId = prefs?.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('FacilatorTool:Logbook');
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.logbookModel.Topic,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kPrimaryLightColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: Lottie.asset('assets/json/kidzee_loader.json'))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                      child: Column(
                        children: [
                          _headerCard(),
                          const SizedBox(height: 10),
                          _sectionCard(
                            'Broad Flow',
                            widget.logbookModel.BroadFlowActivity,
                          ),
                          _sectionCard(
                            'Kit Material(s)',
                            widget.logbookModel.KitMaterial,
                          ),
                          _sectionCard(
                            'Other Material(s)',
                            widget.logbookModel.OtherMaterial,
                          ),
                          _sectionCard(
                            'Worksheet(s)',
                            widget.logbookModel.Worksheet,
                          ),
                          _sectionCard(
                            'Observation(s)',
                            widget.logbookModel.Observations,
                          ),
                          _sectionCard(
                            'Learning Outcome(s)',
                            widget.logbookModel.LearningOutcome,
                          ),
                          const SizedBox(height: 8),
                          _canEdit ? _editorCard() : _readOnlyStatusCard(),
                        ],
                      ),
                    ),
                  ),
                  if (_canEdit) _submitBar(),
                ],
              ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Session: ${widget.logbookModel.SessionName}',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
              Text(
                'Ref: ${widget.logbookModel.LogBookID}',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.logbookModel.Topic,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4B39EF),
            ),
          ),
          if (_chosenValue != 'Select') ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor(_chosenValue).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _chosenValue,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _statusColor(_chosenValue),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionCard(String label, String material) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4B39EF),
              ),
            ),
            const SizedBox(height: 6),
            material.isEmpty
                ? Text(
                    'NA',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  )
                : Html(
                    data: material,
                    style: {
                      'body': Style(
                        fontSize: FontSize(13),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        color: Colors.black87,
                      ),
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _editorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Status',
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _chosenValue,
            decoration: InputDecoration(
              labelText: 'Status',
              filled: true,
              fillColor: const Color(0xFFF3F5FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: _options
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _chosenValue = value);
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _remarkController,
            maxLines: 4,
            minLines: 3,
            decoration: InputDecoration(
              labelText: 'Remark',
              alignLabelWithHint: true,
              hintText: 'Enter remark',
              filled: true,
              fillColor: const Color(0xFFF3F5FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readOnlyStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _chosenValue,
            style: GoogleFonts.roboto(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text(
            'Remark',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _remarkController.text.isEmpty ? 'NA' : _remarkController.text,
            style: GoogleFonts.roboto(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _submitBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryLightColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: isSubmitting ? null : _onSubmitPressed,
          child: isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Submit',
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  void _onSubmitPressed() {
    if (_chosenValue.isEmpty || _chosenValue == 'Select') {
      Utility.confirmalert(context, 'Alert', 'Please Select the Status', this);
      return;
    }
    if (_chosenValue != 'Completed' &&
        _remarkController.text.trim().isEmpty) {
      Utility.showMessage(context, 'Please Enter Remark');
      return;
    }
    updateLogbookRemark();
  }

  Future<void> updateLogbookRemark() async {
    widget.logbookModel.Remarks = _remarkController.text.trim();
    widget.logbookModel.StatusCode = _mapLabelToCode(_chosenValue);

    final request = InsertLogbookRequest(
      TeacherId: teacherId,
      UserId: uid,
      ProgramID: widget.programId ?? programId.toString(),
      CID: widget.day,
      InputDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      remarkModel: widget.logbookModel,
    );

    final online = await Utility.isInternet();
    final dbHelper = DBHelper();
    await dbHelper.insertSyncData(
      request.toJson(),
      LocalConstant.ACTION_LOGBOOK,
      int.tryParse(teacherId) ?? 0,
    );

    if (!online) {
      if (!mounted) return;
      Utility.confirm(
        context,
        'Logbook Update Request Received!',
        'Logbook Request is received, it will be processed once Internet connection is established.',
        this,
      );
      NotificationService().showNotification(
        113,
        'Logbook Update Request Received!',
        'Logbook Request is received, it will be processed once Internet connection is established.',
        'Logbook Request is received, it will be processed once Internet connection is established.',
      );
      return;
    }

    if (mounted) {
      setState(() {
        isSubmitting = true;
        isLoading = true;
      });
    }

    await clearLearningGoal();

    try {
      final value =
          await APIService().insertLogbookRemark(request.toJson(), token);

      if (!mounted) return;

      setState(() {
        isSubmitting = false;
        isLoading = false;
      });

      if (value is GenericResponse && value.success == 200) {
        final message = value.response is String
            ? value.response.toString()
            : value.response.response.toString();
        Utility.showMessage(context, message);
        // Return updated model so list screen reloads.
        Navigator.pop(context, widget.logbookModel);
      } else {
        Utility.showMessage(context, 'Unable to update logbook');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isSubmitting = false;
        isLoading = false;
      });
      Utility.showMessage(context, 'Unable to update logbook: $e');
    }
  }

  Future<void> clearLearningGoal() async {
    final localPrefs = await SharedPreferences.getInstance();
    final keys = localPrefs.getKeys().toList();
    for (final key in keys) {
      if (key.contains('${LocalConstant.MENU_LG_FACILATOR_SAYS}') ||
          key.contains('${LocalConstant.MENU_TRACKER}')) {
        await localPrefs.remove(key);
      }
    }
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_CONFIRM) {
      // Offline queue accepted — return updated model so list reloads/patches.
      Navigator.pop(context, widget.logbookModel);
    } else if (action == Utility.ACTION_OK) {
      // Alert acknowledged; no further action.
    } else if (action == LocalConstant.ACTION_DROPDOWN) {
      setState(() => _chosenValue = value.toString());
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      try {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      } catch (_) {}
      Utility.showMessage(context, value.toString());
    } else if (value is GenericResponse && value.success == 200) {
      try {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      } catch (_) {}
      Utility.showMessage(context, value.response[0].response);
    }
  }
}
