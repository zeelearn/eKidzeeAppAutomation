import 'package:dropdown_search/dropdown_search.dart';
import 'package:ekidzee/api/request/pentemind/myclass/add_new_annoucement.dart';
import 'package:ekidzee/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../api/APIService.dart';
import '../../../../api/request/pentemind/myclass/StudentListRequest.dart';
import '../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../api/response/pentemind/myclass/student_list_response.dart';
import '../../../../helper/utils.dart';
import '../../../../iface/onClick.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import '../../../../widget/MyWidget.dart';

class NewAnnouncement extends StatefulWidget {
  final String token;
  final String programId;
  final String userId;
  final bool isKes;
  final String userName;

  const NewAnnouncement.KES(
      {super.key,
      required this.userId,
      required this.programId,
      required this.token,
      required this.userName})
      : isKes = true;

  const NewAnnouncement({
    super.key,
    required this.userId,
    required this.programId,
    required this.token,
  })  : isKes = false,
        userName = '';

  @override
  _NewAnnouncementScreen createState() => _NewAnnouncementScreen();
}

class _NewAnnouncementScreen extends State<NewAnnouncement>
    implements onClickListener {
  final _dropDownCustomBGKey =
      GlobalKey<DropdownSearchState<StudentInfoModel>>();
  final TextEditingController _studentDateController = TextEditingController();
  final TextEditingController _publishDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 5);

  List<StudentInfoModel> studentList = <StudentInfoModel>[];
  List<StudentInfoModel> selectedstudentList = <StudentInfoModel>[];

  String? selectedImageUrl;

  bool isLoading = false;

  set setLoading(bool value) => setState(() {
        isLoading = value;
      });

  @override
  void initState() {
    super.initState();
    loadStudentList();
  }

  Future<void> loadStudentList() async {
    StudentListRequest request = StudentListRequest(
        User_ID: widget.userId,
        D: /*_day==0 ? -1 : */ -1,
        Program_Id: int.parse(widget.programId),
        AttendanceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    APIService apiService = APIService();
    apiService.getMyClassStudentList(request, widget.token).then((value) {
      debugPrint('Response from student list api is - $value');
      if (value != null) {
        if (value is int) {
        } else {
          StudentListResponse studentListResponse =
              value as StudentListResponse;
          if (studentListResponse.success == 200) {
            if (studentListResponse.data.isNotEmpty) {
              studentList.addAll(studentListResponse.data);

              setState(() {});
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      // backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
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
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyWidget().richText('Title : ', LightColors.textHeaderStyle),
                  const SizedBox(
                    height: 5,
                  ),
                  MyWidget().normalTextField(
                      context, 'Enter Title here', _titleController),
                  const SizedBox(
                    height: 10,
                  ),
                  MyWidget()
                      .richText('Description : ', LightColors.textHeaderStyle),
                  const SizedBox(
                    height: 5,
                  ),
                  MyWidget().normalTextAreaField(context,
                      'Enter Description here', _descriptionController),
                  const SizedBox(
                    height: 10,
                  ),
                  if (widget.isKes) ...[
                    MyWidget().richText(
                        'Select Student : ', LightColors.textHeaderStyle),
                    SizedBox(
                      height: 5,
                    ),
                    studentMultiSelect(),
                  ],
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
                      _publishDateController.text.toString().isEmpty ? '' : '',
                      _publishDateController,
                      minDate,
                      maxDate,
                      prefixIconColor: kPrimaryLightColor),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.isKes) ...[
                    Utility.commonAttachmentLoad(context,
                        onSelectedImage: (p0) {
                      debugPrint('Selected Image is - $p0');
                      setState(() {
                        selectedImageUrl = p0;
                      });
                    }, isLoading: (p0) {
                      setLoading = p0;
                    },
                        selectedImageUrl: selectedImageUrl,
                        showLoader: isLoading),
                  ],
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  announcement_button(size, onTap: () {
                    validate();
                  }, title: 'Submit'),
                  SizedBox(
                    height: 10,
                  ),
                  announcement_button(size, onTap: () {
                    validate();
                  }, title: 'Reject', color: Colors.grey.shade200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownSearch<StudentInfoModel> studentMultiSelect() {
    return DropdownSearch<StudentInfoModel>.multiSelection(
      mode: Mode.form,
      key: _dropDownCustomBGKey,
      onSaved: (newValue) {
        debugPrint('on Search select is - ${newValue?.length}');
      },
      onChanged: (value) {
        selectedstudentList.clear();
        selectedstudentList.addAll(value);
        debugPrint('on Search select is - ${value.length}');
      },
      items: (f, cs) => studentList,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(),
        baseStyle: LightColors.textHeaderStyle13.copyWith(color: Colors.white),
      ),
      popupProps: PopupPropsMultiSelection.bottomSheet(
        bottomSheetProps: BottomSheetProps(
          backgroundColor: Colors.blueGrey[50],
        ),
        containerBuilder: (ctx, popupWidget) {
          return Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: FilledButton(
                      onPressed: () {
                        // How should I unselect all items in the list?
                        _dropDownCustomBGKey.currentState
                            ?.closeDropDownSearch();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: OutlinedButton(
                      onPressed: () {
                        // How should I select all items in the list?
                        _dropDownCustomBGKey.currentState
                            ?.popupSelectAllItems();
                      },
                      child: const Text('All'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: OutlinedButton(
                      onPressed: () {
                        // How should I unselect all items in the list?
                        _dropDownCustomBGKey.currentState
                            ?.popupDeselectAllItems();
                      },
                      child: const Text('None'),
                    ),
                  ),
                ],
              ),
              Expanded(child: popupWidget),
            ],
          );
        },
        // validationBuilder: (context, items) => SizedBox.shrink(),
        validationBuilder: (context, items) => Container(
          height: 50,
          alignment: Alignment.bottomRight,
          width: 80,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ElevatedButton(
            child: Text(
              'OK',
              style:
                  LightColors.textHeaderStyle13.copyWith(color: Colors.white),
            ),
            onPressed: () =>
                _dropDownCustomBGKey.currentState?.popupValidate(items),
          ),
        ),

        errorBuilder: (context, searchEntry, exception) => Center(
          child: Text(exception.toString()),
        ),
        emptyBuilder: (context, searchEntry) => Center(
          child: Text('No Data Found'),
        ),
        showSearchBox: true,
        itemBuilder: (context, item, isDisabled, isSelected) => ListTile(
          title: Text(item.studentName),
        ),
      ),
      compareFn: (item1, item2) => item1.studentName
          .toLowerCase()
          .contains(item2.studentName.toLowerCase()),
      filterFn: (item, filter) =>
          item.studentName.toLowerCase().contains(filter.toLowerCase()),
      dropdownBuilder: (ctx, selectedItem) {
        return Container(
          constraints: BoxConstraints(maxHeight: 100),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              children: selectedItem.map((data) {
                return Chip(
                  label: Text(data.studentName),
                  onDeleted: () {
                    setState(() {
                      selectedItem.remove(data);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  GestureDetector announcement_button(Size size,
      {Function()? onTap, required String title, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: size.height / 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: color ?? kPrimaryLightColor,
        ),
        child: Text(
          title,
          style: LightColors.textbuttonStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> validate() async {
    bool isInternet = await Utility.isInternet();
    if (!isInternet) {
      Utility.noInternetConnection(context);
    } else if (_titleController.text == '' ||
        _titleController.text.toString().trim().isEmpty) {
      Utility.alert(context, 'Alert', 'Please Enter the Title', this);
    } else if (_descriptionController.text.trim() == '') {
      Utility.alert(context, 'Alert', 'Please Enter the description', this);
    } else if (_publishDateController.text == '') {
      Utility.alert(context, 'Alert', 'Please Enter the publish date', this);
    } else {
      DateTime start = parseDateTime(_publishDateController.text);
      addAnnounancement();
    }
  }

  DateTime parseDateTime(String value) {
    DateTime dt = DateTime.now();
    try {
      dt = DateFormat('dd-MMM-yyyy').parse(value);
    } catch (e) {
      e.toString();
    }
    return dt;
  }

  void addAnnounancement() {
    Utility.showLoaderDialog(context);
    NewAnnoucementRequest request = widget.isKes
        ? NewAnnoucementRequest.KES(
            User_id: widget.userId,
            Program_Id: widget.programId,
            publishDate: DateFormat('yyyy-MM-dd').format(
                DateFormat('dd-MMM-yyyy')
                    .parse(_publishDateController.text.toString())),
            title: _titleController.text.toString(),
            description: _descriptionController.text.toString(),
            studentList: selectedstudentList
                .map(
                  (e) => {
                    'user_role_id': e.studentID,
                    'section_id': widget.programId,
                    'user_id': widget.userId
                  },
                )
                .toList(),
            attachmentUrl: selectedImageUrl,
            userName: widget.userName)
        : NewAnnoucementRequest(
            User_id: widget.userId,
            Program_Id: widget.programId,
            publishDate: _publishDateController.text.toString(),
            title: _titleController.text.toString(),
            description: _descriptionController.text.toString(),
          );
    //debugPrint(request.toJson());
    APIService apiService = APIService();
    apiService.addNewAnnouncementList(request, widget.token).then((value) {
      debugPrint('Response from send announcement is - $value');
      Navigator.of(context, rootNavigator: true).pop('dialog');
      if (value != null) {
        if (value == null) {
          Utility.alert(
              context, 'Alert', 'Unable to save new Announcement', this);
        } else if (value is GenericResponse) {
          GenericResponse response = value;
          Utility.getConfirmationDialog(
              context,
              'SUCCESS',
              widget.isKes
                  ? response.response.toString()
                  : response.response[0].response,
              this);
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
    if (action == Utility.ACTION_OK) {
      //Navigator.of(context, rootNavigator: true).pop();
      //debugPrint('action close');
      Navigator.pop(context, [1]);
    } else {
      Navigator.pop(context, 'DONE');
    }
  }
}
