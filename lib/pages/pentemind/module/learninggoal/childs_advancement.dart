import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ekidzee/api/request/pentemind/base_request.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/APIService.dart';
import '../../../../api/request/pentemind/learninggoal/insert_anecdotal.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/learninggoals/child_advancement.dart';
import '../../../../api/response/pentemind/learninggoals/uploadimage.dart';
import '../../../../app_routes.dart';
import '../../../../constants.dart';
import '../../../../firebase/anylatics.dart';
import '../../../../helper/DatabaseHelper.dart';
import '../../../../helper/utils.dart';
import '../../../../main.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import '../../../notification/NotificationService.dart';
import 'learning_goal_ui.dart';

class ChildsAdvancementScreen extends StatefulWidget {
  const ChildsAdvancementScreen({super.key});

  @override
  State<ChildsAdvancementScreen> createState() => _ChildsAdvancementState();
}

class _ChildsAdvancementState extends State<ChildsAdvancementScreen>
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<ChildAdvancementModel> childAdvancementModelList = [];
  bool isLoading = true;
  bool isRefreshing = false;
  bool isOfflineCache = false;
  bool _isUploading = false;

  SharedPreferences? prefs;
  String uid = '';
  String teacherId = '';
  String userType = '';
  String token = '';
  String className = '';
  int programId = 0;

  InsertAnecdotalRequest? anecdotalRequestModel;
  AnecdotalModel? _advancement;
  ChildAdvancementModel? _activeStudent;
  late onClickListener clickListener;
  final ImagePicker _picker = ImagePicker();

  /// Local preview bytes for web / pending uploads (key = studentId|refKey|term).
  final Map<String, Uint8List> _localPreviews = {};

  @override
  void initState() {
    super.initState();
    clickListener = this;
    loadData();
  }

  Future<void> loadData() async {
    await getUserInfo();
  }

  String _previewKey(int studentId, String? refKey, String? term) =>
      '$studentId|${refKey ?? ''}|${term ?? ''}';

  void setAnecdotalRequest(
      ChildAdvancementModel model, Advancement advancement) {
    _activeStudent = model;
    anecdotalRequestModel = InsertAnecdotalRequest(
      TeacherId: teacherId,
      UserId: uid,
      ProgramID: programId,
      InputType: 'ADVMNT',
      anecdotalModel: [],
    );
    _advancement = AnecdotalModel(
      RefKey: advancement.refKey ?? '',
      RefValue: advancement.refValue ?? '',
      StudentID: model.studentID,
      Term: advancement.term ?? '',
    );
  }

  void showImageOption(ChildAdvancementModel model, Advancement advancement) {
    if (_isUploading) {
      Utility.showMessage(context, 'Please wait, upload in progress…');
      return;
    }

    setAnecdotalRequest(model, advancement);
    final hasImage = (advancement.refValue ?? '').isNotEmpty ||
        _localPreviews.containsKey(
            _previewKey(model.studentID, advancement.refKey, advancement.term));

    final options = <String>[
      if (!kIsWeb) 'Camera',
      'Gallery',
      if (hasImage) 'View Image',
    ];

    if (options.length == 1) {
      showImagePicker(0, model);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                  advancement.refKey ?? 'Upload',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  advancement.term ?? '',
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                ...options.map((option) {
                  final icon = option == 'Gallery'
                      ? Icons.photo_library_outlined
                      : option == 'Camera'
                          ? Icons.photo_camera_outlined
                          : Icons.visibility_outlined;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: kPrimaryLightColor.withOpacity(0.12),
                      child: Icon(icon, color: kPrimaryLightColor),
                    ),
                    title: Text(option),
                    onTap: () {
                      Navigator.pop(ctx);
                      if (option == 'Gallery') {
                        showImagePicker(0, model);
                      } else if (option == 'Camera') {
                        showImagePicker(1, model);
                      } else {
                        showImagePicker(3, model);
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showImagePicker(int action, ChildAdvancementModel model) async {
    if (_advancement == null) return;

    if (action == 3) {
      final imageUrl = _advancement!.RefValue;
      if (imageUrl.isEmpty) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => goToImageViewer(imageUrl: imageUrl),
        ),
      );
      return;
    }

    XFile? photo;
    try {
      if (action == 0) {
        photo = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
      } else {
        photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 72,
        );
      }
    } catch (e) {
      if (mounted) {
        Utility.showMessage(context, 'Unable to open picker: $e');
      }
      return;
    }

    if (photo == null) return;

    final previewBytes = await photo.readAsBytes();
    final previewPath = photo.path;
    final key = _previewKey(
      model.studentID,
      _advancement!.RefKey,
      _advancement!.Term,
    );

    _localPreviews[key] = previewBytes;
    _advancement!.RefValue = previewPath;
    updateImage(_advancement!, model.studentID, previewPath);

    if (anecdotalRequestModel != null) {
      anecdotalRequestModel!.anecdotalModel
        ..clear()
        ..add(_advancement!);
    }

    final online = await Utility.isInternet();
    if (!online) {
      if (kIsWeb) {
        if (mounted) {
          Utility.showMessage(
            context,
            'No internet connection. Please connect and try again.',
          );
        }
        return;
      }
      await _queueOfflineUpload();
      return;
    }

    await _uploadSelectedImage(photo);
  }

  Future<void> _queueOfflineUpload() async {
    if (anecdotalRequestModel == null || teacherId.isEmpty) return;

    final dbHelper = DBHelper();
    await dbHelper.insertSyncData(
      anecdotalRequestModel!.toJson(),
      LocalConstant.ACTION_IMAGE_UPLOAD_CHILD_ADV,
      int.parse(teacherId),
    );

    if (!mounted) return;
    Utility.getConfirmationDialog(
      context,
      LocalConstant.LBL_REQUEST_RECEIVED,
      LocalConstant.LBL_REQUEST_SEND,
      this,
    );
    NotificationService().showNotification(
      14,
      LocalConstant.LBL_REQUEST_RECEIVED,
      LocalConstant.LBL_REQUEST_SEND,
      LocalConstant.LBL_REQUEST_SEND,
    );
    initializeService();
  }

  Future<void> _uploadSelectedImage(XFile photo) async {
    if (!mounted) return;
    setState(() => _isUploading = true);
    Utility.showLoaderDialog(context);

    // Always pass XFile — uploadImage expects .name / .path / bytes APIs.
    APIService().uploadImage(uid, photo, listener: this);
  }

  void _dismissLoader() {
    if (!mounted) return;
    try {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    } catch (_) {}
  }

  void updateImage(AnecdotalModel model, int studentId, String path) {
    for (final student in childAdvancementModelList) {
      if (student.studentID != studentId) continue;
      for (final item in student.advancement) {
        if (item.refKey == model.RefKey && item.term == model.Term) {
          item.refValue = path;
        }
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs?.getString(LocalConstant.KEY_UID) ?? '';
    teacherId = prefs?.getString(LocalConstant.KEY_USER_ID) ?? '';
    userType = prefs?.getString(LocalConstant.KEY_USER_TYPE) ?? '';
    token = prefs?.getString(LocalConstant.KEY_APP_TOKEN) ?? '';
    className =
        prefs?.getString(LocalConstant.KEY_CURRENT_PROGRAM_NAME) ?? '';
    programId = prefs?.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) ?? 0;

    // Offline-first: show cached data immediately, then refresh if online.
    final cached = prefs?.getString(getId());
    var hasCache = false;
    if (cached != null && cached.isNotEmpty) {
      hasCache = getLocalData(cached, fromCache: true);
    }

    if (!hasCache) {
      if (mounted) {
        setState(() => isLoading = true);
      }
    }

    final online = await Utility.isInternet();
    if (online) {
      await loadAnecdotalChildAdvancement(showFullLoader: !hasCache);
    } else if (!hasCache && mounted) {
      setState(() {
        isLoading = false;
        isOfflineCache = false;
      });
    }
  }

  bool getLocalData(String data, {bool fromCache = false}) {
    try {
      final response = ChildAdvancementResponse.fromJson(json.decode(data));
      childAdvancementModelList
        ..clear()
        ..addAll(response.advancementModelList);
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

  String getId() => '${uid}_${LocalConstant.MENU_LG_CHILD_ADVANCEMENT}';

  Future<void> savechildAdvancementSummery(String json) async {
    await prefs?.setString(getId(), json);
  }

  Future<void> loadAnecdotalChildAdvancement(
      {bool showFullLoader = true}) async {
    if (showFullLoader && mounted) {
      setState(() {
        isLoading = true;
        isRefreshing = true;
      });
    } else if (mounted) {
      setState(() => isRefreshing = true);
    }

    final request = BasePentemindRequest(Program_ID: programId, userId: uid);
    try {
      final value =
          await APIService().getAnecdotalChildAdvancement(request, token);
      if (!mounted) return;

      if (value is ChildAdvancementResponse) {
        final encoded = jsonEncode(value);
        await savechildAdvancementSummery(encoded);
        childAdvancementModelList
          ..clear()
          ..addAll(value.advancementModelList);
        _localPreviews.clear();
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
        if (childAdvancementModelList.isEmpty) {
          Utility.showMessage(context, 'Data not found');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isRefreshing = false;
      });
      if (childAdvancementModelList.isEmpty) {
        Utility.showMessage(context, 'Unable to load data. Showing offline if available.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent("CHILD'S ADVANCEMENT");
    return Scaffold(
      backgroundColor: LearningGoalUi.pageBackground,
      appBar: LearningGoalUi.appBar(
        title: "CHILD'S ADVANCEMENT",
        subtitle: className.isNotEmpty ? className : null,
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isOfflineCache) LearningGoalUi.offlineBanner(),
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                color: Colors.white,
                backgroundColor: kPrimaryLightColor,
                strokeWidth: 3.0,
                onRefresh: () =>
                    loadAnecdotalChildAdvancement(showFullLoader: false),
                child: getchildAdvancementList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getchildAdvancementList() {
    if (isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [SizedBox(height: MediaQuery.of(context).size.height * 0.35, child: LearningGoalUi.loading())],
      );
    }

    if (childAdvancementModelList.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Utility.emptyData(context, 'Data not applicable'),
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
            itemCount: childAdvancementModelList.length,
            itemBuilder: (context, index) {
              return generateChildAdvancementListRow(
                childAdvancementModelList[index],
                constraints.maxWidth,
              );
            },
          ),
        );
      },
    );
  }

  Widget generateChildAdvancementListRow(
      ChildAdvancementModel model, double width) {
    return LearningGoalUi.studentCardShell(
      header: LearningGoalUi.studentHeader(
        name: model.studentName,
        subtitle: '${model.advancement.length} categories',
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
          itemCount: model.advancement.length,
          itemBuilder: (context, index) {
            return getTermCard(model, model.advancement[index]);
          },
        ),
      ),
    );
  }

  Widget getTermCard(ChildAdvancementModel model, Advancement advancement) {
    final value = advancement.refValue ?? '';
    final previewKey =
        _previewKey(model.studentID, advancement.refKey, advancement.term);
    final hasLocalPreview = _localPreviews.containsKey(previewKey);
    final hasImage = value.isNotEmpty || hasLocalPreview;

    return Material(
      color: const Color(0xFFF8F9FC),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showImageOption(model, advancement),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      advancement.refKey ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 12,
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      advancement.term ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildThumb(
                value: value,
                localBytes: _localPreviews[previewKey],
                hasImage: hasImage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumb({
    required String value,
    required Uint8List? localBytes,
    required bool hasImage,
  }) {
    if (!hasImage) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: kPrimaryLightColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.add_a_photo_outlined,
          size: 22,
          color: kPrimaryLightColor,
        ),
      );
    }

    Widget image;
    if (localBytes != null) {
      image = Image.memory(localBytes, fit: BoxFit.cover);
    } else if (_isNetworkUrl(value)) {
      image = Utility.getImageWidget(value, 'assets/icons/ic_student.png');
    } else if (!kIsWeb && value.isNotEmpty) {
      image = Image.file(File(value), fit: BoxFit.cover);
    } else {
      image = Utility.getImageWidget(value, 'assets/icons/ic_student.png');
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: 42, height: 42, child: image),
    );
  }

  bool _isNetworkUrl(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  DateTime parseDate(String value) {
    var dt = DateTime.now();
    try {
      dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(value);
    } catch (_) {}
    return dt;
  }

  String getParsedShortDate(String value) {
    return DateFormat('MMM-dd').format(parseDate(value));
  }

  Future<void> _saveAdvancementAfterUpload(UploadImageResponse upload) async {
    if (upload.imageModel == null || upload.imageModel!.isEmpty) {
      _dismissLoader();
      if (mounted) {
        Utility.showMessage(context, upload.message);
      }
      setState(() => _isUploading = false);
      return;
    }

    final location = upload.imageModel![0].location;
    _advancement!.RefValue = location;

    if (_activeStudent != null) {
      updateImage(_advancement!, _activeStudent!.studentID, location);
      final key = _previewKey(
        _activeStudent!.studentID,
        _advancement!.RefKey,
        _advancement!.Term,
      );
      _localPreviews.remove(key);
    }

    if (anecdotalRequestModel == null) {
      _dismissLoader();
      setState(() => _isUploading = false);
      return;
    }

    anecdotalRequestModel!.anecdotalModel
      ..clear()
      ..add(_advancement!);

    try {
      final value = await APIService().saveAnecdotalChildAdvancement(
        anecdotalRequestModel!.toJson(),
        token,
      );
      _dismissLoader();
      if (!mounted) return;
      setState(() => _isUploading = false);

      if (value is GenericResponse && value.success == 200) {
        try {
          Utility.getConfirmationDialog(
            context,
            'SUCCESS',
            value.response is String
                ? value.response
                : value.response.response.toString(),
            clickListener,
          );
        } catch (_) {
          Utility.showMessage(
            context,
            value.response is String
                ? value.response
                : value.response.response.toString(),
          );
        }
        await loadAnecdotalChildAdvancement(showFullLoader: false);
      } else {
        Utility.showMessage(context, 'Unable to save…');
      }
    } catch (e) {
      _dismissLoader();
      if (mounted) {
        setState(() => _isUploading = false);
        Utility.showMessage(context, 'Unable to save: $e');
      }
    }
  }

  bool _isUploadSuccess(UploadImageResponse response) {
    final msg = response.message.toLowerCase();
    final hasLocation =
        response.imageModel != null && response.imageModel!.isNotEmpty;
    return hasLocation ||
        msg.contains('success') ||
        msg.contains('uploaded');
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK) {
      if (value is UploadImageResponse) {
        if (_isUploadSuccess(value)) {
          _saveAdvancementAfterUpload(value);
        } else {
          _dismissLoader();
          setState(() => _isUploading = false);
          Utility.showMessageCallback(context, 'Alert', value.message, this);
        }
      }
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR ||
        action == Utility.ACTION_REJECT) {
      _dismissLoader();
      if (mounted) {
        setState(() => _isUploading = false);
        Utility.showMessage(context, value.toString());
      }
    } else if (action == Utility.ACTION_OK) {
      // Confirmation dialog dismissed.
    } else if (value is GenericResponse) {
      _dismissLoader();
      if (value.success == 200) {
        try {
          Utility.showMessage(context, value.response[0].response);
        } catch (_) {
          Utility.showMessage(
            context,
            value.response is String
                ? value.response
                : value.response.toString(),
          );
        }
      }
    }
  }
}
