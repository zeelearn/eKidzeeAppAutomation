import 'package:either_dart/either.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_model.dart';
import 'package:ekidzee/pages/k12/data/models/get_homework_student_model.dart'
    as getHomeworkStudentModelPlaceholder;
import 'package:ekidzee/pages/k12/data/models/update_daily_homework_model.dart';
import 'package:ekidzee/pages/k12/data/repository/homework_repository_impl.dart';
import 'package:ekidzee/pages/k12/domain/entities/update_daily_homework_entity.dart';
import 'package:ekidzee/pages/pentemind/module/homework/review/homework_review_card.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:literaoctave/core/toast_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeworkReviewScreen extends StatefulWidget {
  const HomeworkReviewScreen({super.key, required this.homework});
  final Homework homework;

  @override
  State<HomeworkReviewScreen> createState() => _HomeworkReviewScreenState();
}

class _HomeworkReviewScreenState extends State<HomeworkReviewScreen> {
  List<getHomeworkStudentModelPlaceholder.Data> studentList = [];
  late final prefs;
  String uid = '';
  String username = '';
  String teacherId = '';
  String token = '';
  int classId = 0;
  int programId = 0;
  int studentId = 0;
  int? businessId;

  bool isLoading = true;
  String? error;

  List<String> ccStatusoptions = [
    'All',
    'Published',
    'Pending',
  ];

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  bool markAllCorrect = false;

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LocalConstant.KEY_UID) as String;
    teacherId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    token = prefs.getString(LocalConstant.KEY_APP_TOKEN) as String;
    classId = prefs.getInt(LocalConstant.KEY_CURRENT_CLASS_ID) as int;
    programId = prefs.getInt(LocalConstant.KEY_CURRENT_PROGRAM_ID) as int;
    businessId = prefs.getInt(LocalConstant.KEY_BUSINESS_ID);

    username = prefs.getString(LocalConstant.KEY_USER_NAME) as String;

    try {
      studentId = prefs.getInt(LocalConstant.KEY_STUDENT_ID) as int;
    } catch (e) {}
    setState(() {});

    getStudentList();
  }

  set setLoading(bool value) => setState(() {
        isLoading = value;
      });

  Future<void> getStudentList() async {
    debugPrint(
        'User id - $uid username is - $username ${programId.toString()}');

    getHomeworkStudentModelPlaceholder.GetHomeworkStudentModel
        getHomeworkStudentModel =
        getHomeworkStudentModelPlaceholder.GetHomeworkStudentModel(
            businessID: businessId ?? 0,
            sectionID: programId,
            username: username,
            homeworkID: widget.homework.homeworkID ?? 0);

    setLoading = true;
    var response = HomeworkRepositoryImpl().getHomeworkStudentList(
        getHomeworkStudentModel: getHomeworkStudentModel);
    setLoading = false;
    response.either(
      (left) => setState(() {
        error = 'Something went wrong.' /* left */;
      }),
      (right) {
        debugPrint('Response from gethomework is - $right');
        getHomeworkStudentModel =
            getHomeworkStudentModelPlaceholder.GetHomeworkStudentModel.fromJson(
                right,
                businessID: businessId ?? 0,
                homeworkID: widget.homework.homeworkID ?? 0,
                sectionID: programId,
                username: username);
        studentList.addAll(getHomeworkStudentModel.data ?? []);

        setState(() {});
      },
    );
  }

  void toggleMarkAll(bool value) {
    setState(() {
      markAllCorrect = value;
      for (var s in studentList) {
        if (s.is_teacher_homework_checked == 1 ||
            s.uploadUrl == null ||
            s.uploadUrl!.isEmpty) {
          continue; // Skip if no submission
        }
        s.isChecked = true;
        s.isCorrect = value;
      }
    });
  }

  void submitReview() {
    // API call / Firebase / backend logic
    List<InputData> inputDataList = [];
    for (var s in studentList) {
      if (s.is_teacher_homework_checked == 1 ||
          s.uploadUrl == null ||
          s.uploadUrl!.isEmpty) {
        continue; // Skip if no submission
      }
      debugPrint(
          "${s.studentName} -> ${s.isCorrect ?? false ? "Correct" : "Wrong"} | Remark: ${s.remark}");
      if (s.isChecked ?? false) {
        if (s.isCorrect == null) {
          ToastUtility.showError(
              'Please mark all selected submissions as correct or wrong');
          return;
        }
        inputDataList.add(InputData(
            studentId: s.studentId ?? 0,
            statusCode: s.isCorrect ?? false ? 'C' : 'W',
            remarks: s.remark ?? ''));
      }
    }

    if (inputDataList.isEmpty) {
      ToastUtility.showError('No submissions selected for review');
      return;
    }
    UpdateDailyHomeworkModel updateHomeworkModel = UpdateDailyHomeworkModel(
        businessId: businessId ?? 1,
        homeworkId: widget.homework.homeworkID ?? 0,
        inputData: inputDataList,
        sectionId: programId,
        username: username);

    // setLoading = true;
    Utility.showAdaptiveLoader(context);
    var response = HomeworkRepositoryImpl().updateDailyHomeworkCorrection(
        updateDailyHomeworkModel: updateHomeworkModel);
    Navigator.pop(context);
    // setLoading = false;
    response.either(
      (left) {
        debugPrint('Error updating homework correction: $left');
      },
      (right) {
        debugPrint('Successfully updated homework correction: $right');
        Navigator.pop(context);
        ToastUtility.showSuccess(
            right['data']['msg'] ?? 'Homework Updated Successfully');
      },
    );
  }

  Widget reviewList(BuildContext context) {
    return /* !Responsive.isMobile(context)
        ? GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Utility.getCrossAxisCountHomework(context),
              childAspectRatio: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              return HomeworkScreenCard(
                submission: studentList[index],
                onChanged: () => setState(() {}),
              );
            },
          )
        : */
        ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
      padding: const EdgeInsets.all(16),
      itemCount: studentList.length,
      itemBuilder: (context, index) {
        return HomeworkScreenCard(
          submission: studentList[index],
          onChanged: () => setState(() {}),
        );
      },
    );
  }

  bool notshowMarkAllCorrect() => !studentList.any((element) =>
      (element.is_teacher_homework_checked == 0) &&
      (element.uploadUrl != null && element.uploadUrl!.isNotEmpty));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.homework.chapterName ?? "",
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            Text(
              widget.homework.subjectName ?? "",
              style: GoogleFonts.inter(
                fontSize: 10.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          notshowMarkAllCorrect()
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilledButton(
                    onPressed: () => toggleMarkAll(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kPrimaryLightColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Mark All Correct',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              )
            : error != null
                ? Center(
                    child: Text(error ?? "Error loading homework"),
                  )
                : Hero(
                    tag: 'homework_${1}',
                    flightShuttleBuilder: Utility.heroFlightBuilder,
                    child: reviewList(context)),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: notshowMarkAllCorrect()
              ? SizedBox.shrink()
              : ElevatedButton(
                  onPressed: submitReview,
                  child: Text(
                    "Submit Review",
                    style: LightColors.textHeaderStyleWhite,
                  ),
                ),
        ),
      ),
    );
  }
}
