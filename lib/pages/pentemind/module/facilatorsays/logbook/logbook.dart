import 'dart:convert';

import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../api/response/pentemind/facilatortool/logbookResponse.dart';
import '../../../../../api/response/pentemind/get_day_response.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/KidzeePref.dart';
import '../../../../../helper/utils.dart';
import '../../../../home/model/StatusModel.dart';
import '../../../../notification/NotificationService.dart';
import 'logbook_details.dart';

class LogbookScreen extends StatefulWidget {
  final String cName;
  final int day;
  final bool isToolbar;
  final bool? deepLinkingEnabled;
  final String? programId;
  final String? culminationDay;
  final String? refId;
  final int? hiveIndex;

  static final ValueNotifier<bool> relaod = ValueNotifier(false);

  const LogbookScreen({
    super.key,
    required this.cName,
    required this.day,
    required this.isToolbar,
    this.deepLinkingEnabled,
    this.programId,
    this.culminationDay,
    this.refId,
    this.hiveIndex,
  });

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dayController = TextEditingController();

  SharedPreferences? prefs;
  bool isLoading = true;
  bool isRefreshing = false;
  bool isOfflineCache = false;
  bool isInternet = false;

  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String className = '';
  String displayCName = '';
  int programId = 0;
  int currentDay = 1;

  List<LogbookModel> mLogbookList = [];
  LogbookResponse? response;
  bool _deepLinkOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    displayCName = widget.cName;
    currentDay = widget.day > 0 ? widget.day : 1;
    _dayController.text = currentDay.toString();
    _bootstrap();
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
      _resumeDay();
    }
  }

  Future<void> _bootstrap() async {
    await _resolveDay();
    await getUserInfo();
  }

  Future<void> _resolveDay() async {
    if (widget.deepLinkingEnabled != null) {
      currentDay = int.tryParse(widget.culminationDay ?? '') ?? currentDay;
      _dayController.text = currentDay.toString();
      if (mounted) setState(() {});
      return;
    }

    if (displayCName.isEmpty || widget.day <= 0) {
      try {
        final GetDayResponse dayModel = await KidzeePref.getDay(context);
        currentDay = dayModel.data.D == 0 ? 1 : dayModel.data.D;
        displayCName = dayModel.data.CName;
      } catch (_) {
        currentDay = currentDay > 0 ? currentDay : 1;
      }
    }

    _dayController.text = currentDay.toString();
    if (mounted) setState(() {});
  }

  Future<void> _resumeDay() async {
    try {
      final GetDayResponse dayModel = await KidzeePref.getDay(context);
      currentDay = dayModel.data.D == 0 ? 1 : dayModel.data.D;
      displayCName = dayModel.data.CName;
      _dayController.text = currentDay.toString();
      await getUserInfo();
    } catch (_) {}
  }

  String getId() =>
      '${uid}_${programId}_${_dayController.text}_${LocalConstant.MENU_LOGBOOK}';

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs?.getString(LocalConstant.KEY_UID) ?? '';
    teacherId = prefs?.getString(LocalConstant.KEY_USER_ID) ?? '';
    userType = prefs?.getString(LocalConstant.KEY_USER_TYPE) ?? '';
    token = prefs?.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    className = prefs?.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? '';
    programId = prefs?.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;

    isInternet = await Utility.isInternet();
    final cached = prefs?.getString(getId());
    final isOfflineEligible = await Utility.isOfflineEligble(
      context,
      prefs?.getString('sync_${getId()}') ?? '',
    );

    var hasCache = false;
    if (cached != null && cached.isNotEmpty) {
      hasCache = getLocalData(cached, fromCache: true);
    }

    if (widget.deepLinkingEnabled != null) {
      await getLogbook(showFullLoader: !hasCache);
      return;
    }

    if (!hasCache && !isInternet) {
      if (mounted) {
        setState(() {
          isLoading = false;
          mLogbookList.clear();
        });
      }
      return;
    }

    if (isOfflineEligible || !isInternet) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isOfflineCache = hasCache;
        });
      }
      return;
    }

    await getLogbook(showFullLoader: !hasCache);
  }

  bool getLocalData(String data, {bool fromCache = false}) {
    try {
      response = LogbookResponse.fromJson(json.decode(data));
      mLogbookList
        ..clear()
        ..addAll(response?.logbookModel ?? []);
      if (mLogbookList.isNotEmpty) {
        displayCName = mLogbookList.first.CName;
      }
      if (mounted) {
        setState(() {
          isLoading = false;
          isOfflineCache = fromCache;
        });
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> savechildSummery(String jsonBody) async {
    await prefs?.setString(getId(), jsonBody);
    await prefs?.setString('sync_${getId()}', Utility.formatDate());
  }

  Future<void> getLogbook({bool showFullLoader = true}) async {
    final online = await Utility.isInternet();
    isInternet = online;

    if (!online) {
      if (mLogbookList.isEmpty && mounted) {
        Utility.showMessage(context, 'Please check Internet Connection..');
        setState(() => isLoading = false);
      }
      return;
    }

    if (mounted) {
      setState(() {
        if (showFullLoader) isLoading = true;
        isRefreshing = true;
      });
    }

    final request = BasePentemindRequest(
      Program_ID: widget.deepLinkingEnabled == null
          ? programId
          : int.tryParse(widget.programId ?? '0') ?? 0,
      userId: uid,
    );

    try {
      final value = await APIService().getFacilitatorLogBook(
        request,
        _dayController.text,
        token,
      );

      if (!mounted) return;

      if (value is LogbookResponse) {
        response = value;
        await savechildSummery(jsonEncode(response));

        mLogbookList.clear();
        if (widget.deepLinkingEnabled == null || widget.refId == null) {
          mLogbookList.addAll(value.logbookModel);
        } else {
          for (final item in value.logbookModel) {
            if (item.LogBookID == widget.refId) {
              mLogbookList.add(item);
              if (!_deepLinkOpened) {
                _deepLinkOpened = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _openDetails(item);
                });
              }
            }
          }
        }

        if (mLogbookList.isNotEmpty) {
          displayCName = mLogbookList.first.CName;
        }

        setState(() {
          isLoading = false;
          isRefreshing = false;
          isOfflineCache = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isRefreshing = false;
        });
        if (mLogbookList.isEmpty) {
          Utility.showMessage(context, 'data not found');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isRefreshing = false;
      });
      if (mLogbookList.isEmpty) {
        Utility.showMessage(context, 'Unable to load logbook');
      }
    }
  }

  Future<void> _openDetails(LogbookModel logbookModel) async {
    final result = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (context) => LogbookDetailsScreen(
          logbookModel: logbookModel,
          day: _dayController.text,
          programId: widget.programId,
        ),
      ),
    );

    if (!mounted) return;

    if (result is LogbookModel) {
      await _onDetailsUpdated(result);
    } else if (result == true) {
      await getLogbook(showFullLoader: false);
    }
  }

  Future<void> _onDetailsUpdated(LogbookModel model) async {
    await _updateHiveStatusIfNeeded();

    if (response != null) {
      for (var i = 0; i < response!.logbookModel.length; i++) {
        if (response!.logbookModel[i].LogBookID == model.LogBookID) {
          response!.logbookModel[i] = model;
        }
      }
      await savechildSummery(jsonEncode(response));
    }

    // Reload list from server so status/remarks are fresh.
    await getLogbook(showFullLoader: false);
  }

  Future<void> _updateHiveStatusIfNeeded() async {
    try {
      final statusBox = await Hive.openBox(LocalConstant.logbookStatus);

      if (widget.hiveIndex != null) {
        await statusBox.deleteAt(widget.hiveIndex!);
      }

      final statusList = statusBox.values.toList();
      for (var i = 0; i < statusList.length; i++) {
        final item = statusList[i];
        if (item is! StatusModel) continue;

        final matchesProgram = widget.programId != null
            ? item.programID == int.tryParse(widget.programId!)
            : item.programID == programId;
        final matchesDay = item.day == int.tryParse(_dayController.text);

        if (!(matchesProgram && matchesDay)) continue;

        await statusBox.putAt(
          i,
          StatusModel(
            programID: item.programID,
            classID: item.classID,
            day: item.day,
            logbookStatus: true,
            className: item.className,
          ),
        );

        final scheduleNotification =
            prefs?.getBool(LocalConstant.KEY_SCHEDULE_NOTIFICATION) ?? false;
        if (!scheduleNotification) continue;

        final notificationService = NotificationService();
        notificationService
            .cancelNotification(LocalConstant.LOGBOOK_NOTIFICATION_ID);
        notificationService
            .cancelNotification(LocalConstant.FINAL_NOTIFICATION_ID);

        final now = DateTime.now();
        final payload = StatusModel(
          programID: item.programID,
          classID: item.classID.toString(),
          day: item.day,
          logbookStatus: true,
          className: item.className,
        );
        final message =
            'Kindly fill the Learning Goal for ${item.className}  Day - ${item.day}';

        notificationService.showNotificationAtSchedulePreciseDate(
          LocalConstant.LEARNINGOAL_NOTIFICATION_ID_1,
          'fill your Learning Goal',
          message,
          payload,
          now.add(const Duration(minutes: 1)),
        );
        notificationService.showNotificationAtSchedulePreciseDate(
          LocalConstant.LEARNINGOAL_NOTIFICATION_ID_2,
          'fill your Learning Goal',
          message,
          payload,
          now.add(const Duration(minutes: 2)),
        );
        notificationService.showNotificationAtSchedulePreciseDate(
          LocalConstant.FINAL_NOTIFICATION_ID,
          'fill your Learning Goal',
          message,
          payload,
          DateTime(now.year, now.month, now.day, 4),
        );
      }
    } catch (_) {}
  }

  void _applyDay(String day) {
    final parsed = int.tryParse(day.trim());
    if (parsed == null || parsed <= 0) {
      Utility.showMessage(context, 'Please enter a valid day');
      return;
    }
    currentDay = parsed;
    _dayController.text = parsed.toString();
    getLogbook(showFullLoader: true);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('FacilatorTool:Logbook');
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: widget.isToolbar
          ? AppBar(
              title: Text(
                'Logbook',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: kPrimaryLightColor,
              elevation: 0,
              actions: [
                if (isRefreshing)
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            if (isOfflineCache) _offlineBanner(),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                color: Colors.white,
                backgroundColor: kPrimaryLightColor,
                strokeWidth: 3,
                onRefresh: () => getLogbook(showFullLoader: false),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _offlineBanner() {
    return Material(
      color: const Color(0xFFFFF4E5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, size: 18, color: Color(0xFFB76E00)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Showing saved offline data. Pull to refresh when online.',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: const Color(0xFF8A5A00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: Lottie.asset('assets/json/kidzee_loader.json'));
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: [
        _buildHeader(),
        const SizedBox(height: 8),
        if (mLogbookList.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: !isInternet
                ? Utility.noInternet(context)
                : Utility.emptyData(
                    context,
                    'Data are not available at this moment please check later',
                  ),
          )
        else
          ...mLogbookList.map(_buildLogbookCard),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Culmination Day',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _showDayBottomSheet,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F5FA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 16, color: kPrimaryLightColor),
                        const SizedBox(width: 8),
                        Text(
                          'Day ${_dayController.text}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.edit_outlined, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: kPrimaryLightColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              displayCName.isEmpty ? className : displayCName,
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kPrimaryLightColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogbookCard(LogbookModel model) {
    final preview = model.BroadFlowActivity.length > 100
        ? '${model.BroadFlowActivity.substring(0, 100)}...'
        : model.BroadFlowActivity;
    final statusLabel = _statusLabel(model.StatusCode);
    final statusColor = _statusColor(model.StatusCode);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openDetails(model),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Session: ${model.SessionName}',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Text(
                      'Ref: ${model.LogBookID}',
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  model.Topic,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4B39EF),
                  ),
                ),
                const SizedBox(height: 6),
                Html(
                  data: preview,
                  style: {
                    'body': Style(
                      fontSize: FontSize(12),
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      color: Colors.black54,
                    ),
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (statusLabel.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusLabel,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel(String code) {
    switch (code) {
      case 'C':
        return 'Completed';
      case 'PC':
        return 'Partially Completed';
      case 'NC':
        return 'Not Completed';
      default:
        return 'Pending';
    }
  }

  Color _statusColor(String code) {
    switch (code) {
      case 'C':
        return Colors.green.shade700;
      case 'PC':
        return Colors.orange.shade700;
      case 'NC':
        return Colors.red.shade600;
      default:
        return LightColors.kRed;
    }
  }

  void _showDayBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
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
                Text(
                  'Culmination Day',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dayController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Enter day number',
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFFF3F5FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Culmination Day can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
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
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.pop(ctx);
                        _applyDay(_dayController.text);
                      }
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      try {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      } catch (_) {}
      Utility.showMessage(context, value.toString());
    } else if (action == Utility.ACTION_OK) {
      // no-op
    } else if (value is GenericResponse && value.success == 200) {
      try {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      } catch (_) {}
      Utility.showMessage(context, value.response[0].response);
    }
  }
}
