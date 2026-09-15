import 'dart:math';

import 'package:ekidzee/helper/app_assets.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/widget/KidzeeWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../../api/response/pentemind/myclass/day_calender.dart';
import '../../../../api/response/pentemind/myclass/student_list_response.dart';
import '../../../../constants.dart';
import '../../../../helper/LocalConstant.dart';
import '../../../../helper/LocalStrings.dart';
import '../../../../iface/onClick.dart';
import '../../../../utils/theme/colors/light_colors.dart';
import '../../../../widget/MyWebSiteView.dart';
import '../../../../widget/MyWidget.dart';
import 'almanac_menu.dart';
import 'my_class_controller.dart';

class MyClassModule extends StatelessWidget {
  final onClickListener listener;
  final CuminationDayModel culminationModel;

  const MyClassModule({
    super.key,
    required this.listener,
    required this.culminationModel,
  });

  @override
  Widget build(BuildContext context) {
    final MyClassController controller = Get.put(MyClassController(),
        tag: (Random().nextInt(100) + 1).toString());
    ScreenUtil.init(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: TabBar(
            labelPadding: EdgeInsets.zero,
            tabs: const [
              Tab(text: 'Attendance '),
              Tab(text: 'Student Profile'),
              Tab(text: 'Almanac'),
            ],
            tabAlignment: TabAlignment.fill,
            dividerColor: Colors.blueGrey,
            labelColor: kPrimaryLightColor,
            indicatorColor: kPrimaryLightColor,
            unselectedLabelColor: Colors.grey,
            onTap: (index) {
              Future.delayed(Duration.zero, () {
                controller.selectedIndex.value = index;
              });
            },
          ),
        ),
        body: Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return getAttandanceView(context, controller, true);
            case 1:
              return getAttandanceView(context, controller, false);
            case 2:
              return AlmanacMenu(listener: listener);
            default:
              return Container();
          }
        }),
      ),
    );
  }

  // Helper method to keep UI clean, similar to original but using controller
  Widget getAttandanceView(BuildContext context, MyClassController controller,
      bool isAttendanceTab) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: controller.isFilterApplied.value &&
                controller.selectedIndex.value == 0 &&
                !controller.isLoading.value &&
                ((kIsWeb
                        ? DateFormat('yyyy-MM-dd')
                            .parse(controller.selectedDate.value)
                            .isBefore(DateTime.now())
                        : controller.selectedDate.value ==
                            DateFormat('yyyy-MM-dd').format(DateTime.now())) ||
                    controller.isAttendanceAllowed.value == 1)
            ? FloatingActionButton(
                onPressed: () => controller.saveAttendance(listener,
                    widgetListener: listener),
                backgroundColor: kPrimaryLightColor,
                child: const Icon(Icons.save_as, color: Colors.white),
              )
            : null,
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              await controller.loadStudentList();
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.APP_BACKGROUND),
                  fit: BoxFit.cover,
                ),
              ),
              child: Obx(() => getScreen(context, controller, isAttendanceTab)),
            ),
          ),
        ));
  }

  Widget getScreen(BuildContext context, MyClassController controller,
      bool isAttendanceTab) {
    if (!controller.isInternet.value) {
      return Utility.noInternet(context);
    } else if (controller.isLoading.value) {
      return Center(child: Lottie.asset('assets/json/kidzee_loader.json'));
    } else if (!isAttendanceTab) {
      // Student Profile Tab logic
      return Column(
        children: [
          Expanded(child: _buildAttendanceList(context, controller, false)),
        ],
      );
    } else if (!controller.isFilterApplied.value) {
      // Culmination Selection logic
      return Column(
        children: [
          _buildHeader(controller),
          controller.chosenValue.value == 'Culmination'
              ? Expanded(
                  child:
                      Utility.filter(context, 'Please Select The Culmination'))
              : Expanded(
                  child: SingleChildScrollView(
                      child: _buildWeeklyView(context, controller))),
        ],
      );
    } else {
      // Attendance Entry logic
      return Column(
        children: [
          _buildHeader(controller),
          _buildDateAndStatsHeader(context, controller, isAttendanceTab),
          if (controller.day.value == 0)
            MyWidget().getDropdown(
                'Select Floating Day',
                controller.floatingDay.value.isNotEmpty
                    ? controller.floatingDay.value
                    : 'Select Floating Day',
                controller
                    .floatingDayOptions, // This needs to be in controller or passed
                Utility.ACTION_OBSERVATION,
                _OnClickProxy(
                    onClicked: (val) => controller.floatingDay.value = val)),
          if (!kIsWeb && controller.lastSyncDate.value.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'Last Sync : ${Utility.parseFullDate(controller.lastSyncDate.value)} ',
                  style: LightColors.textvSmallStyle,
                ),
              ),
            ),
          Expanded(
              child:
                  _buildAttendanceList(context, controller, isAttendanceTab)),
        ],
      );
    }
  }

  Widget _buildHeader(MyClassController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: MyWidget().getDropdownButton(
                'Culmination',
                controller.chosenValue.value,
                controller.options,
                Utility.ACTION_CULMINATION,
                _OnClickProxy(
                    onClicked: (val) => controller.onChosenValueChange(val))),
          ),
          Expanded(
            child: MyWidget().getDropdownButton(
                'All Week',
                controller.chosenWeekValue.value,
                controller.weekOptions,
                Utility.ACTION_CULMINATION_WEEK,
                _OnClickProxy(
                    onClicked: (val) =>
                        controller.onChosenWeekValueChange(val))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryLightColor,
                minimumSize: const Size(80, 40),
              ),
              onPressed: () {
                if (!controller.isFilterApplied.value) {
                  controller.enableFloatingDay();
                } else {
                  controller.isFilterApplied.value = false;
                }
              },
              child: Text(
                controller.isFilterApplied.value ? 'Back' : 'Add Floating Day',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyView(BuildContext context, MyClassController controller) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.culDay.length,
            gridDelegate: Utility.getGridViewStyle8(),
            itemBuilder: (context, index) {
              var dayItem = controller.culDay[index];
              return GestureDetector(
                onTap: () async {
                  controller.isFilterApplied.value = true;
                  controller.day.value = dayItem.D;
                  controller.selectedDay.value = dayItem.CName;
                  controller.floatingDay.value = '';
                  controller.selectedDate.value =
                      dayItem.AttendanceDate == '1900-01-01' ||
                              dayItem.AttendanceDate.isEmpty
                          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                          : dayItem.AttendanceDate;
                  await controller.gsOfflineData();
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: dayItem.IsDisabled
                          ? LightColors.kLightGreen
                          : (dayItem.AttendanceDate == '1900-01-01' ||
                                  dayItem.AttendanceDate.isEmpty
                              ? Colors.white
                              : Colors.green),
                    ),
                    child: ListTile(
                      title: Text(dayItem.CName,
                          style: LightColors.textHeaderStyle13),
                      subtitle: (dayItem.AttendanceDate == '1900-01-01' ||
                              dayItem.AttendanceDate.isEmpty)
                          ? null
                          : Text(dayItem.AttendanceDate,
                              style: LightColors.subTextStyle),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Card(
          color: LightColors.kLightGray1,
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0), child: Text('Floating Days'))),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.floatingDays.length,
          itemBuilder: (context, index) {
            var fDay = controller.floatingDays[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: GestureDetector(
                onTap: () async {
                  controller.isFilterApplied.value = true;
                  controller.day.value = 0;
                  controller.selectedDay.value = fDay.CName;
                  controller.floatingDay.value = fDay.remark;
                  controller.selectedDate.value =
                      fDay.AttendanceDate == '1900-01-01'
                          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                          : fDay.AttendanceDate;
                  await controller.gsOfflineData();
                },
                child: Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                        backgroundColor: LightColors.kLightGray,
                        child: Text('F')),
                    title: Text(fDay.AttendanceDate),
                    subtitle: Text(fDay.remark),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateAndStatsHeader(BuildContext context,
      MyClassController controller, bool isAttendanceTab) {
    return Container(
      color: LightColors.kLightGray,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => controller.selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(controller.selectedDate.value,
                  style: LightColors.subTextStyle),
            ),
          ),
          if (controller.day.value != 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('  ${controller.day.value}  ',
                  style: LightColors.smallTextStyle),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(controller.selectedDay.value,
                style: LightColors.smallTextStyle),
          ),
          if (isAttendanceTab)
            Row(
              children: [
                KidzeeWidget.getRoundedText(
                    'T',
                    kPrimaryLightColor,
                    LightColors.absentRoundedStyle,
                    controller.totalStudent.value),
                const SizedBox(width: 4),
                KidzeeWidget.getRoundedText(
                    'P',
                    LightColors.kGreen,
                    LightColors.absentRoundedStyle,
                    controller.totalPresentStudent.value),
                const SizedBox(width: 4),
                KidzeeWidget.getRoundedText(
                    'A',
                    LightColors.kRed,
                    LightColors.absentRoundedStyle,
                    controller.totalAbsentStudent.value),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList(BuildContext context,
      MyClassController controller, bool isAttendanceTab) {
    if (controller.studentList.isEmpty) {
      return Utility.emptyData(
          context, "Student Information not found, please check again");
    }
    return ListView.builder(
      itemCount: controller.studentList.length,
      itemBuilder: (context, index) {
        var student = controller.studentList[index];
        return _buildStudentRow(context, controller, student, isAttendanceTab);
      },
    );
  }

  Widget _buildStudentRow(BuildContext context, MyClassController controller,
      StudentInfoModel student, bool isAttendanceTab) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: LightColors.kLightGray,
          backgroundImage: student.studentprofileURL.isNotEmpty
              ? NetworkImage(student.studentprofileURL)
              : null,
          child: student.studentprofileURL.isEmpty
              ? Image.asset('assets/icons/ic_student.png')
              : null,
        ),
        title: Text(student.studentName, style: LightColors.textStyle),
        subtitle: Text('Parent : ${student.parentName}',
            style: LightColors.subTextStyle),
        trailing: isAttendanceTab
            ? Checkbox(
                value: student.isPresent,
                onChanged: (val) {
                  student.isPresent = val ?? false;
                  controller.updateCounts();
                  controller.studentList.refresh();
                },
              )
            : InkWell(
                onTap: () async {
                  int academicYear = controller.ayId;
                  String url = '${LocalConstant.URL_PRINT_PENTEMIND}/studentreportList/${student.studentID}&${controller.programId}&${controller.userType}&${controller.classId}&${controller.entityId}&${controller.uid}&mobile&$academicYear';

                  if (kIsWeb) {
                    Utility.launchURL(url);
                  } else {
                    Get.to(
                        () => MyWebsiteView(title: 'Student Report', url: url));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(221, 40, 81, 0.18)),
                  child: const Icon(Icons.bar_chart,
                      color: Colors.black, size: 20),
                ),
              ),
      ),
    );
  }
}

class _OnClickProxy implements onClickListener {
  final Function(dynamic) onClicked;
  _OnClickProxy({required this.onClicked});
  @override
  void onClick(int action, value) => onClicked(value);
}
