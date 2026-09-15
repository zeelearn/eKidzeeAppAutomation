import 'dart:convert';

import 'package:ekidzee/api/APIService.dart' show APIService;
import 'package:ekidzee/api/request/k12/general_request.dart';
import 'package:ekidzee/api/response/k12/notification/notification.dart'
    show GetNotificationResponse, NotificationList, StudentList, ToList;
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart' show LocalConstant;
import 'package:ekidzee/iface/onClick.dart' show onClickListener;
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:saathi/core/utility/utils.dart' as saathiutils;
import 'package:literaoctave/core/utils.dart' as octaveUtil;
import 'package:saathi/core/utility/utils.dart' hide Utility;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import '../../../../helper/utils.dart';
// import '../../../k12/core/utils.dart';
import 'add_annunancement_kes.dart';

class KESNotificationScreen extends StatefulWidget {
  int sectinId;
  String userName;

  KESNotificationScreen(
      {super.key, required this.sectinId, required this.userName});

  @override
  _KESNotificationState createState() => _KESNotificationState();
}

class _KESNotificationState extends State<KESNotificationScreen>
    with TickerProviderStateMixin
    implements onClickListener {
  bool isLoading = false;
  GetNotificationResponse? response;
  List<StudentList> studentList = [];
  List<NotificationList> notificationList = [];
  List<NotificationList> notificationPendingList = [];
  List<NotificationList> notificationApprovedList = [];
  List<NotificationList> notificationRejectList = [];
  List<NotificationList> notificationOriginalList = [];
  String token = '';
  SharedPreferences? prefs;
  String userType = '';
  String userName = '';
  String carriculumn = '';
  bool showRejectTab = false;

  late TabController _tabController;

  final _tabs = [
    const Tab(text: 'Approved'),
    const Tab(text: 'Pending'),
  ];

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  bool canApprove() =>
      userType.toLowerCase() == 'cc' || userType.toLowerCase() == 'cm';

  Future<void> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString(LocalConstant.KEY_APP_TOKEN) as String;
    userType = prefs!.getString(LocalConstant.KEY_USER_TYPE_NAME) as String;
    userName = prefs!.getString(LocalConstant.KEY_USER_NAME) as String;
    carriculumn = prefs!.containsKey(LocalConstant.KEY_CURRENT_CURRICULAMTYPE)
        ? prefs!.getString(LocalConstant.KEY_CURRENT_CURRICULAMTYPE) as String
        : '';

    _tabController = TabController(length: _tabs.length, vsync: this);
    debugPrint('in Notification UserType $userType carricu $carriculumn');
    // if (canApprove()) {

    // }
    loadNotification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getUserInfo();
    }
  }

  String getId() {
    return '${widget.userName.toString()}_${LocalConstant.MENU_MYCALSS_ANNOUNANCEMENT}';
  }

  void saveMessageSummery(json) {
    prefs!.setString(getId(), json);
  }

  void loadNotification() {
    isLoading = true;
    setState(() {});
    studentList.clear();
    // notificationList.clear();
    notificationOriginalList.clear();
    KesSimpleRequest request =
        KesSimpleRequest(sectionId: widget.sectinId, username: widget.userName);
    APIService apiService = APIService();
    apiService.getKesNotification(request, token).then((value) {
      isLoading = false;
      GetNotificationResponse response = value;
      String json = jsonEncode(response);
      saveMessageSummery(json);
      if (response.data != null &&
          response.data!.isNotEmpty &&
          response.data![0].notificationList != null) {
        notificationList.addAll(response.data![0].notificationList!);
        notificationOriginalList
            .addAll([...response.data![0].notificationList!]);
      }
      if (response.data != null &&
          response.data!.isNotEmpty &&
          response.data![0].studentList != null) {
        studentList.addAll(response.data![0].studentList!);
      }
      notificationList.sort((a, b) {
        return b.publishDate!
            .toLowerCase()
            .compareTo(a.publishDate!.toLowerCase());
      });
      notificationOriginalList.sort((a, b) {
        return b.publishDate!
            .toLowerCase()
            .compareTo(a.publishDate!.toLowerCase());
      });
      showRejectTab = notificationOriginalList.any(
        (element) =>
            element.approvalStatus?.toLowerCase().contains('reject') ?? false,
      );
      if (showRejectTab &&
          !_tabs.any(
            (element) => element.text == 'Rejected',
          )) {
        _tabs.add(Tab(text: 'Rejected'));
        _tabController.dispose();
        _tabController = TabController(length: _tabs.length, vsync: this);
      }

      setState(() {});
      //Navigator.of(context).pop();
      setState(() {});
    });
  }

  bool canGoToAddAnnouncement() =>
      Utility.isKES(carriculumn) &&
      (userType == 'TEACH' || userType.toLowerCase() == 'cc');

  bool showAnnouncementTab() =>
      Utility.isKES(carriculumn) &&
      (userType == 'TEACH' ||
          userType.toLowerCase() == 'cc' ||
          userType.toLowerCase() == 'cm');

  bool canViewStudent() => Utility.isKES(carriculumn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "Announcements",
            style: LightColors.textHeaderStyleWhite.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          actions: canGoToAddAnnouncement()
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.add,
                            size: 18, color: kPrimaryLightColor),
                        label: Text(
                          'Add New',
                          style: LightColors.subTextStyle.copyWith(
                            color: kPrimaryLightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: LightColors.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewAnnouncement(
                                studentList: studentList,
                                token: token,
                                userId: widget.userName,
                                userType: userType,
                                programId: widget.sectinId.toString(),
                                culminationType: 'k12',
                              ),
                            ),
                          ).then((value) {
                            _tabController.animateTo(1);
                            loadNotification();
                          });
                        },
                      ),
                    ),
                  )
                ]
              : null,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(LightColors.primaryColor),
                ),
              )
            : Column(
                children: [
                  if (showAnnouncementTab()) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        tabs: _tabs,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        labelColor: kPrimaryLightColor,
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                        dividerColor: Colors.transparent,
                      ),
                    ),
                  ],
                  Expanded(
                    child: showAnnouncementTab()
                        ? TabBarView(
                            controller: _tabController,
                            children: [
                              getNotificationList('app'),
                              getNotificationList('pend'),
                              if (showRejectTab) getNotificationList('reject')
                            ],
                          )
                        : getNotificationList('all'),
                  )
                ],
              ));
  }

  Widget getNotificationList(String type) {
    if (type == 'all') {
      notificationList.clear();
      notificationList.addAll(notificationOriginalList);
      return getNotificationCommonList(type, notificationList);
    } else if (type == 'app') {
      notificationApprovedList.clear();
      for (var element in notificationOriginalList) {
        if (element.approvalStatus?.toLowerCase() == 'approved')
          notificationApprovedList.add(element);
      }
      return getNotificationCommonList(type, notificationApprovedList);
    } else if (type == 'pend') {
      notificationPendingList.clear();
      for (var element in notificationOriginalList) {
        /* Condition to show only pending data */
        if (element.approvalStatus?.toLowerCase() == 'pending')
          notificationPendingList.add(element);
      }
      return getNotificationCommonList(type, notificationPendingList);
    } else if (type == 'reject') {
      notificationRejectList.clear();
      for (var element in notificationOriginalList) {
        /* Condition to show only pending data */
        if (element.approvalStatus?.toLowerCase() == 'reject')
          notificationRejectList.add(element);
      }
      return getNotificationCommonList(type, notificationRejectList);
    }
    return SizedBox.shrink();
  }

  Widget getNotificationCommonList(
      String type, List<NotificationList> notificationListLocal) {
// Final sort
    try {
      if (type == 'pend' || type == 'reject') {
        notificationListLocal.sort((a, b) => b.nId!.compareTo(a.nId!));
      } else {
        notificationListLocal.sort(
          (a, b) => DateFormat('dd-MM-yyyy')
              .parse(b.publishDate!)
              .compareTo(DateFormat('dd-MM-yyyy').parse(a.publishDate!)),
        );
      }
    } catch (e) {}

    return notificationListLocal.isEmpty
        ? Center(
            child: Text(
              'No Announcement',
              style: LightColors.textHeaderStyle13,
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              final int crossAxisCount = width > 1200
                  ? 3
                  : width > 700
                      ? 2
                      : 1;
              final double horizontalPadding = width > 1200
                  ? 40
                  : width > 700
                      ? 24
                      : 8;

              if (crossAxisCount > 1) {
                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: width > 1200 ? 1.45 : 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: notificationListLocal.length,
                  itemBuilder: (context, index) {
                    return notificationCard(notificationListLocal[index],
                        isGrid: true);
                  },
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: notificationListLocal.length,
                  itemBuilder: (context, index) {
                    return notificationCard(notificationListLocal[index]);
                  },
                );
              }
            },
          );
  }

  Widget notificationCard(NotificationList notification,
      {bool isGrid = false}) {
    Color statusColor;
    IconData statusIcon;
    switch (notification.approvalStatus?.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case '':
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.error_outline;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
    }

    bool isFutureDate = false;
    if (notification.publishDate != null &&
        notification.publishDate!.isNotEmpty) {
      try {
        DateTime itemDate =
            DateFormat('yyyy-MM-dd').parse(notification.publishDate!);
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        if (itemDate.isAfter(today)) {
          isFutureDate = true;
        }
      } catch (_) {}
    }

    if (notification.approvalStatus?.toLowerCase() == 'pending' &&
        !isFutureDate) {
      statusColor = Colors.redAccent;
      statusIcon = Icons.error_outline;
    }

    return InkWell(
      onTap: !isFutureDate
          ? null
          : () {
              if (canApprove() &&
                  notification.approvalStatus?.toLowerCase() == 'pending') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewAnnouncement(
                      studentList: studentList,
                      token: token,
                      userType: userType,
                      notificationList: notification,
                      userId: widget.userName,
                      programId: widget.sectinId.toString(),
                      culminationType: 'k12',
                    ),
                  ),
                ).then((value) {
                  loadNotification();
                });
              }
            },
      child: Container(
        height: isGrid ? double.infinity : null,
        margin: EdgeInsets.symmetric(horizontal: isGrid ? 0 : 16, vertical: 8),
        decoration: BoxDecoration(
          color: isFutureDate ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Status and Ref Id
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            notification.approvalStatus?.toLowerCase() ==
                                        'pending' &&
                                    !isFutureDate
                                ? 'Out of date'
                                : notification.approvalStatus ?? 'Pending',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Ref ID: ${notification.nId}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Attachment/Icon Section
                    if (notification.attachment != null &&
                        notification.attachment!.isNotEmpty)
                      Container(
                        width: 56,
                        height: 56,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => octaveUtil.Utils.onFileTapKidzee(
                                context,
                                'Attachment',
                                notification.attachment!,
                                '',
                                true),
                            child: FadeInImage(
                              placeholder: AssetImage(
                                  getAttachmentIcon(notification.attachment!)),
                              fit: BoxFit.cover,
                              image: NetworkImage(notification.attachment!),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Image.asset(
                                    getAttachmentIcon(notification.attachment!),
                                    width: 32,
                                    height: 32,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 56,
                        height: 56,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: LightColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/ic_announancement.png',
                            width: 32,
                            height: 32,
                            color: LightColors.primaryColor,
                          ),
                        ),
                      ),

                    // Content Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.subject ?? 'No Subject',
                            style: LightColors.textHeaderStyle16.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: const Color(0xFF1A1A1A),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notification.msgBody?.toString().trim() ?? '',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              height: 1.4,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (isGrid) const Spacer(),

              // Footer Section
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.1))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          notification.publishDate != null
                              ? DateFormat('dd MMM yyyy').format(
                                  DateFormat('dd-MM-yyyy')
                                      .parse(notification.publishDate!))
                              : '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (canViewStudent() && notification.toList != null)
                      InkWell(
                        onTap: () => showStudentList(context,
                            notification.subject!, notification.toList!),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.people_outline,
                                  size: 14, color: Colors.blue),
                              const SizedBox(width: 6),
                              Text(
                                "${notification.toList?.length ?? '0'} Students",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAnnouncementBottomSheet(BuildContext context) {
    final List<String> students = [
      'John Doe',
      'Jane Smith',
      'Alice Johnson',
      'Bob Lee',
      'Charlie Davis',
    ];

    showModalBottomSheet(
      useSafeArea: true, // 👈 This is important
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text("Title: Announcement Title",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Subtitle: Important notice for parents",
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text("Date: 24 July 2025",
                          style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 8),
                      Text("Status: Active",
                          style: TextStyle(color: Colors.green)),
                      SizedBox(height: 16),
                      ExpansionTile(
                        title: Text("Students"),
                        children: students
                            .map((student) => ListTile(
                                  title: Text(student),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      Text("Announcement Status: Unread",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent)),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle read mode logic here
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Read Mode Activated")));
                          },
                          child: Text("Read Mode"),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void showStudentList(
      BuildContext context, String title, List<ToList> students) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: students.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor:
                              LightColors.primaryColor.withOpacity(0.1),
                          child: Text(
                            student.studentName!.isEmpty
                                ? '-'
                                : student.studentName![0].toUpperCase(),
                            style: const TextStyle(
                              color: LightColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          student.studentName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        // trailing: const Icon(Icons.arrow_forward_ios,
                        //     size: 12, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBSDayList(BuildContext context, List<ToList>? list, String title,
      onClickListener clickListener) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Text(
                  title,
                  style: LightColors.textHeaderStyle13,
                ),
                // Flexible(child: ListView.builder(itemBuilder: (context, index) => ListTile(title: Text(list![index].studentName!),),))
              ],
            ),
          );
        }
        /*builder: (builder) =>
            showWeekList(context,culminationId,list,dayResposne,clickListener)*/
        );
  }

  @override
  void onClick(int action, value) {
    // TODO: implement onClick
  }
}
