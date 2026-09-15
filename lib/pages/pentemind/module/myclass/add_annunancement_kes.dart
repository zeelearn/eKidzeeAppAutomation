import 'dart:developer';

import 'package:ekidzee/api/request/k12/add_notification.dart';
import 'package:ekidzee/api/request/pentemind/myclass/add_new_annoucement.dart';
import 'package:ekidzee/api/response/k12/notification/notification.dart'
    show NotificationList, StudentList;
import 'package:ekidzee/api/response/pentemind/learninggoals/uploadimage.dart'
    show UploadImageResponse;
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/globals.dart';
import 'package:ekidzee/pages/k12/data/models/general.dart'
    show GeneralResponse;
import 'package:ekidzee/pages/pentemind/module/myclass/student_selection_bs.dart';
import 'package:file_picker/file_picker.dart'
    show FilePickerResult, PlatformFile;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:literaoctave/core/utils.dart' as octaveUtil;
import 'package:saathi/core/utility/utils.dart' as saathiutils;

import '../../../../api/APIService.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../helper/utils.dart';
import '../../../../iface/onClick.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import '../../../../widget/MyWidget.dart';
import '../../../../widget/attachment_legend_widget.dart';

class NewAnnouncement extends StatefulWidget {
  List<StudentList> studentList;
  String token;
  String programId;
  String userId;
  String culminationType;
  String userType;
  NotificationList? notificationList;

  NewAnnouncement(
      {super.key,
      required this.userId,
      required this.programId,
      required this.studentList,
      required this.culminationType,
      required this.token,
      required this.userType,
      this.notificationList});

  @override
  _NewAnnouncementScreen createState() => _NewAnnouncementScreen();
}

class _NewAnnouncementScreen extends State<NewAnnouncement>
    implements onClickListener {
  final TextEditingController _publishDateController = TextEditingController(
      text: DateFormat('dd-MMM-yyyy').format(DateTime.now()));
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime.now().add(Duration(days: 5));
  String attachmentPath = '';

  bool isApiinProgress = false;

  List<StudentList> _selectedStudentList = [];
  String _selectedStudents = '';

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  void setInitialData() {
    if (widget.notificationList != null) {
      _titleController.text = widget.notificationList?.subject ?? '';
      _descriptionController.text = widget.notificationList?.msgBody ?? '';
      _publishDateController.text = widget.notificationList?.publishDate == null
          ? ''
          : DateFormat('dd-MMM-yyyy').format(DateFormat('dd-MM-yyyy')
              .parse(widget.notificationList!.publishDate!));
      _selectedStudentList = widget.notificationList?.toList?.map(
            (e) {
              return StudentList(
                  studentId: e.studentId,
                  sectionId: e.sectionId,
                  studentName: e.studentName,
                  userRoleId: e.userRoleId,
                  userType: e.userRoleName);
            },
          ).toList() ??
          [];
      log('Selected student list is - ${_selectedStudentList.length} - ${widget.notificationList?.toList?.length}  - ${widget.notificationList?.toJson()}');
      update();
      attachmentPath = widget.notificationList?.attachment ?? '';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      // backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Add New Announcement',
          style: LightColors.textHeaderStyleWhite,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kPrimaryLightColor,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyWidget()
                        .richText('Title : ', LightColors.textHeaderStyle),
                    const SizedBox(
                      height: 5,
                    ),
                    MyWidget().normalTextAreaField(
                        context, 'Enter Title here', _titleController,
                        maxLength: 50),
                    const SizedBox(
                      height: 10,
                    ),
                    MyWidget().richText(
                        'Description : ', LightColors.textHeaderStyle),
                    const SizedBox(
                      height: 5,
                    ),
                    MyWidget().normalTextAreaField(context,
                        'Enter Description here', _descriptionController,
                        maxLength: 250),
                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Student List",
                      style: LightColors.textHeaderStyle,
                    ),
                    Container(
                      color: LightColors.kLightGray,
                      constraints: BoxConstraints(maxHeight: 100),
                      child: InkWell(
                        onTap: () {
                          showStudentSelectionSheet(context);
                        },
                        child: ListTile(
                          title: _selectedStudentList.isEmpty
                              ? Text('Please select Students')
                              : Text(_selectedStudents),
                          trailing: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    attachmentPath.isEmpty
                        ? Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryLightColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 16.0),
                                  ),
                                  onPressed: () {
                                    uploadFile();
                                  },
                                  child: Text(
                                    'Pick File',
                                    style: LightColors.textHeaderStyleWhite,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AttachmentLegendWidget(
                                      text: 'Only PDF are allowed.',
                                    ),
                                    AttachmentLegendWidget(
                                      text:
                                          'File size should not exceed 20 MB.',
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Stack(children: [
                            FadeInImage(
                              placeholder: AssetImage(saathiutils
                                  .getAttachmentIcon(attachmentPath)),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              image: NetworkImage(attachmentPath),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return InkWell(
                                  onTap: () => octaveUtil.Utils.onFileTapKidzee(
                                      context,
                                      'Attachment',
                                      attachmentPath,
                                      '',
                                      false),
                                  child: Image(
                                      image: AssetImage(saathiutils
                                          .getAttachmentIcon(attachmentPath))),
                                );
                              },
                            ),
                            Positioned(
                                height: 22,
                                width: 22,
                                right: 0,
                                top: 0,
                                child: IconButton(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.zero,
                                    iconSize: 28,
                                    onPressed: () {
                                      setState(() {
                                        attachmentPath = '';
                                      });
                                    },
                                    icon: Container(
                                      color: Colors.black,
                                      child: Icon(
                                        Icons.clear,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    )))
                          ]),

                    //ADD STUDENT LIST Here

                    const SizedBox(
                      height: 10,
                    ),
                    MyWidget().richText(
                        'Published Date : ', LightColors.textHeaderStyle),
                    const SizedBox(
                      height: 5,
                    ),
                    MyWidget().getDateTime(
                        context,
                        _publishDateController.text.toString().isEmpty
                            ? ''
                            : '',
                        _publishDateController,
                        minDate,
                        maxDate),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    commonButton(size, onTap: () {
                      FocusScope.of(context).unfocus();
                      validate(widget.notificationList != null &&
                              (widget.userType.toLowerCase() == 'cc' ||
                                  widget.userType.toLowerCase() == 'cm')
                          ? 'Approved'
                          : 'Pending');
                    },
                        title: widget.notificationList != null
                            ? 'Approve'
                            : 'Submit',
                        bgColor: kPrimaryLightColor),
                    if ((widget.userType.toLowerCase() == 'cc' ||
                            widget.userType.toLowerCase() == 'cm') &&
                        widget.notificationList != null) ...[
                      SizedBox(
                        height: 10,
                      ),
                      commonButton(size, onTap: () {
                        FocusScope.of(context).unfocus();
                        validate('Reject');
                      },
                          title: 'Reject',
                          bgColor: LightColors.kRed,
                          textColor: Colors.white)
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector commonButton(Size size,
      {required Function() onTap,
      required String title,
      Color? bgColor,
      Color? textColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: size.height / 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: bgColor,
        ),
        child: Text(
          title,
          style: LightColors.textbuttonStyle
              .copyWith(color: textColor ?? Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> uploadFile() async {
    FilePickerResult? result = await Utility.uploadPdfFile();
    if (result != null) {
      if (!Utility.isLargeFile(result, context)) {
        PlatformFile file = result.files.first;

        // debugPrint(file.name);
        // debugPrint(file.bytes);
        // debugPrint(file.size);
        // debugPrint(file.extension);
        // debugPrint(file.path);
        Utility.showKESLoaderDialog(context);
        APIService().uploadImage(widget.userId, kIsWeb ? file : file.path!,
            listener: this);
      }
    }
  }

  Future<void> showStudentSelectionSheet(BuildContext context) async {
    _selectedStudentList = await showModalBottomSheet<List<StudentList>>(
          context: context,
          useSafeArea: true, // 👈 This is important
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: StudentSelectionSheet(
                students: widget.studentList,
                selectedstudents: _selectedStudentList,
              ),
            );
          },
        ) ??
        [];
    update();
  }

  void update() {
    String token = '';
    _selectedStudents = '';
    for (var student in _selectedStudentList) {
      // if (student.isPresent) {
      _selectedStudents += token + (student.studentName ?? '');
      token = ", ";
      // }
    }
    setState(() {});
  }

  Future<void> validate(String status) async {
    if (status.toLowerCase() == 'reject') {
      // Utility.showAlertDialog(context, 'Are you sure want to $status');
      addKESAnnounancement(status);
    } else {
      bool isInternet = await Utility.isInternet();
      if (!isInternet) {
        Utility.noInternetConnection(context);
      } else if (_titleController.text == '' ||
          _titleController.text.toString().trim().isEmpty) {
        Utility.alert(context, 'Alert', 'Please Enter the Title', this);
      } else if (_descriptionController.text.toString().trim().isEmpty) {
        Utility.alert(context, 'Alert', 'Please Enter the description', this);
      } else if (widget.culminationType == 'k12' &&
          _selectedStudentList.isEmpty) {
        Utility.alert(context, 'Alert', 'Please Select Students', this);
      } else if (_publishDateController.text == '') {
        Utility.alert(context, 'Alert', 'Please Enter the publish date', this);
      } else {
        DateTime start = parseDateTime(_publishDateController.text);
        // Utility.showAlertDialog(context, 'Are you sure want to $status');
        addKESAnnounancement(status);
      }
    }
  }

  DateTime parseDateTime(String value) {
    DateTime dt = DateTime.now();
    try {
      if (AppFlavor == 'mlzs')
        dt = DateFormat('yyyy-MM-dd').parse(value);
      else
        dt = DateFormat('dd-MMM-yyyy').parse(value);
    } catch (e) {
      e.toString();
    }
    return dt;
  }

  bool validatingAnnouncement = false;

  void addKESAnnounancement(String status) {
    if (validatingAnnouncement) {
      return;
    }
    validatingAnnouncement = true;
    Utility.showKESLoaderDialog(context);
    AddKesNotification request = AddKesNotification(
        attachmentUrl: attachmentPath,
        approvalStatus: status,
        nId: widget.notificationList == null
            ? 0
            : widget.notificationList?.nId ?? 0,
        msgBody: _descriptionController.text.toString(),
        msgType: 'Alert',
        publishDate: DateFormat('yyyy-MM-dd').format(DateFormat('dd-MMM-yyyy')
            .parse(_publishDateController.text.toString())),
        requestType: 'Announcement',
        studentList: _selectedStudentList,
        subject: _titleController.text.toString(),
        username: widget.userId);

    debugPrint(request.toJson());

    APIService apiService = APIService();
    apiService.addKESNewAnNotification(request, widget.token).then((value) {
      validatingAnnouncement = false;
      Navigator.of(context, rootNavigator: true).pop('dialog');
      if (value != null) {
        if (value == null) {
          Utility.alert(
              context, 'Alert', 'Unable to save new Announcement', this);
        } else if (value is GeneralResponse) {
          GeneralResponse response = value;
          Utility.getConfirmationDialog(
              context, 'SUCCESS', response.data!.msg!, this);
        }
      } else {
        Utility.alert(
            context, 'Alert', "Unable to save new Announcement", this);
        //debugPrint("null value");
      }
    });
  }

  void addAnnounancement(String value) {
    Utility.showKESLoaderDialog(context);
    NewAnnoucementRequest request = NewAnnoucementRequest(
        User_id: widget.userId,
        Program_Id: widget.programId,
        publishDate: _publishDateController.text.toString(),
        title: _titleController.text.toString(),
        description: _descriptionController.text.toString());
    //debugPrint(request.toJson());
    APIService apiService = APIService();
    apiService.addNewAnnouncementList(request, widget.token).then((value) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      if (value != null) {
        if (value == null) {
          Utility.alert(
              context, 'Alert', 'Unable to save new Announcement', this);
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          Utility.getConfirmationDialog(
              context, 'SUCCESS', response.response[0].response, this);
        }
      } else {
        Utility.alert(
            context, 'Alert', "Unable to save new Announcement", this);
        //debugPrint("null value");
      }
    });
  }

  DateTime parseDate(String value) {
    DateTime dt = DateTime.now();
    //2022-07-18T00:00:00
    try {
      dt = DateFormat('yyyy-MM-dd').parse(value);
      //debugPrint('asasdi   ' + dt.day.toString());
    } catch (e) {
      e.toString();
    }
    return dt;
  }

  String getParsedShortDate(String value) {
    DateTime dateTime = parseDate(value);
    return DateFormat("MMM-dd").format(dateTime);
  }

  @override
  void onClick(int action, value) {
    if (value == 'Alert') {
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK) {
      UploadImageResponse response = value;
      attachmentPath = response.imageModel![0].location;
      setState(() {});
      Navigator.of(context, rootNavigator: true).pop('dialog');
    } else if (action == Utility.ACTION_OK) {
      //Navigator.of(context, rootNavigator: true).pop();
      //debugPrint('action close');
      Navigator.pop(context, [1]);
    } else {
      Navigator.pop(context, 'DONE');
    }
  }
}
