import 'package:ekidzee/constants.dart';
import 'package:ekidzee/globals.dart';
import 'package:ekidzee/helper/DatabaseHelper.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/main.dart';
import 'package:ekidzee/pages/notification/DetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:saathi/widget/customUrlText.dart';
import 'package:saathi/zllsaathi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/NotificationModel.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<UserNotification> {
  List<NotificationModel> lessons = [];

  @override
  void initState() {
    NotificationController.resetBadgeCounter();
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    List<Map<String, dynamic>> list =
        await DBHelper().getData(LocalConstant.TABLE_NOTIFICATION);
    final loadedLessons = <NotificationModel>[];
    for (int index = 0; index < list.length; index++) {
      Map<String, dynamic> map = list[index];
      loadedLessons.add(NotificationModel(
        notificationId: index,
        subject: map['title'] ?? '',
        notificationtype: map['type'] ?? '',
        message: map['description'] ?? '',
        image_url: map['imageurl'] ?? '',
        bigImageUrl: map['bigImageUrl'] ?? '',
        logoUrl: map['logoUrl'] ?? '',
        webViewUrl: map['webViewLink'] ?? '',
        time: map['date'] ?? '',
        isSeen: 1,
        indicatorValue: 1.0,
      ));
    }
    if (!mounted) return;
    setState(() => lessons = loadedLessons.reversed.toList());
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    setState(() => lessons.remove(notification));
    await DBHelper().deleteNotification(
      title: notification.subject,
      date: notification.time,
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  String formatNotificationTime(String value) {
    try {
      return DateFormat('MMM d, hh:mm a').format(
        DateFormat('yyyy-MM-dd hh:mm a').parse(value),
      );
    } catch (_) {
      return value;
    }
  }

  Widget _notificationIcon(NotificationModel notification) {
    if (notification.notificationtype == 'td') {
      return Image.asset('assets/images/saathilogo.png');
    }
    return Icon(Icons.notifications_none_rounded, color: kPrimaryLightColor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: const Color(0xFF4F535B),
      fontSize: 14,
      height: 1.45,
    );
    final urlStyle = textStyle?.copyWith(color: kPrimaryLightColor);

    ListTile makeListTile(NotificationModel notificationModel) => ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          leading: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFF5F3F8),
              child: notificationModel.logoUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        notificationModel.logoUrl,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _notificationIcon(notificationModel),
                      ),
                    )
                  : _notificationIcon(notificationModel),
            ),
          ),
          minLeadingWidth: 0,
          title: Text(
            notificationModel.subject,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF171B24),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              UrlText(
                text: notificationModel.message,
                onHashTagPressed: (tag) {},
                style: textStyle,
                urlStyle: urlStyle,
              ),
              if (notificationModel.bigImageUrl.isNotEmpty) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    notificationModel.bigImageUrl,
                    width: double.infinity,
                    height: 190,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 190,
                      color: const Color(0xFFF1F1F3),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatNotificationTime(notificationModel.time),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF8B9099),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          onTap: () async {
            if (notificationModel.notificationtype == 'td') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String userName = prefs.containsKey(LocalConstant.KEY_USER_ID)
                  ? prefs.getString(LocalConstant.KEY_USER_ID) as String
                  : '';
              debugPrint(userName);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ZllTicketDetails(
                            ticketId: notificationModel.webViewUrl,
                            bid: AppFlavor == 'Kidzee' ? '1' : '2',
                            businessUserId: '',
                            userId: userName,
                            mColor: kPrimaryLightColor,
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(notificationModel: notificationModel)));
            }
          },
        );

    Card makeCard(NotificationModel model) => Card(
          elevation: 0,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFF0F0F2)),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: makeListTile(model),
        );

    final makeBody = RefreshIndicator(
      color: kPrimaryLightColor,
      onRefresh: loadData,
      child: lessons.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: lessons.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                    child: Text(
                      'Today',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  );
                }

                final notification = lessons[index - 1];
                return Dismissible(
                  key: ValueKey(
                      '${notification.subject}_${notification.time}_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.white, size: 28),
                  ),
                  onDismissed: (_) => deleteNotification(notification),
                  child: makeCard(notification),
                );
              },
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Center(child: Lottie.asset(no_Notification_Animtion)),
                ),
              ],
            ),
    );
    final topAppBar = AppBar(
      elevation: 1.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: kPrimaryLightColor,

        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      leadingWidth: 30,
      title: Text(
        "Notifications",
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.white),
      ),
      backgroundColor: kPrimaryLightColor,
      iconTheme: const IconThemeData(color: Colors.white),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),

      appBar: topAppBar,
      body: makeBody,
      //bottomNavigationBar: makeBottom,
    );
  }
}
