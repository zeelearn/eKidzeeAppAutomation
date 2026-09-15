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
  const UserNotification({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<UserNotification> {
  late List lessons = [];

  @override
  void initState() {
    NotificationController.resetBadgeCounter();
    loadData();
    super.initState();
  }

  void loadData() async {
    List<Map<String, dynamic>> list =
        await DBHelper().getData(LocalConstant.TABLE_NOTIFICATION);
    //debugPrint('----${list.length}');
    for (int index = 0; index < list.length; index++) {
      Map<String, dynamic> map = list[index];
      //debugPrint('----${map['title']}');
      debugPrint(map['date']);
      lessons.add(NotificationModel(
          notificationId: 0,
          subject: map['title'],
          notificationtype: map['type'],
          message: map['description'],
          image_url: map['imageurl'],
          bigImageUrl: map['bigImageUrl'] ?? '',
          logoUrl: map['logoUrl'] ?? '',
          webViewUrl: map['webViewLink'] ?? '',
          time: map['date'],
          isSeen: 1,
          indicatorValue: 1.0));
    }
    lessons = lessons.reversed.toList();
    setState(() {});
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400);
    TextStyle urlStyle = TextStyle(
        color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w400);

    TextStyle textHeaderStyle = TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400);
    TextStyle urlHeaderStyle = TextStyle(
        color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500);

    ListTile makeListTile(NotificationModel notificationModel) => ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: notificationModel.image_url.isNotEmpty
                ? Image.network(
                    notificationModel.logoUrl,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        notificationModel.notificationtype == 'td'
                            ? Image.asset(
                                'assets/image/saathilogo.png',
                                width: 32,
                                height: 32,
                              )
                            : const Icon(Icons.notifications,
                                color: Colors.grey),
                  )
                : const Icon(Icons.notifications, color: Colors.grey),
          ),

          minLeadingWidth: 0,
          // isThreeLine: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  notificationModel.subject,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: UrlText(
                  text: notificationModel.message,
                  onHashTagPressed: (tag) {
                    //cprint(tag);
                  },
                  style: textStyle,
                  urlStyle: urlStyle,
                ),
              ),
              // RichText(
              //   overflow: TextOverflow.ellipsis,
              //   maxLines: 2, // this will show dots(...) after 3 lines
              //   strutStyle: const StrutStyle(fontSize: 10.0),
              //   text: TextSpan(
              //       style: GoogleFonts.lato(
              //         textStyle: Theme.of(context).textTheme.labelLarge,
              //       ),
              //       text: removeAllHtmlTags(notificationModel.message)),
              // ),
              const SizedBox(
                height: 6,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('MMM/dd, hh:mm a').format(
                      DateFormat('yyyy-MM-dd hh:mm a')
                          .parse(notificationModel.time)),
                  textAlign: TextAlign.end,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.lightBlueAccent),
                ),
              )
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
                            //businessUserID: receivedAction.payload!['business_user_id']!,
                            //userID: routingData['u_id'],
                            //role: routingData['r'],
                            //dashboardClickListener: arguments?.$2,
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
          elevation: 8.0,
          // shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(5))),
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: makeListTile(model),
        );

    final makeBody = lessons.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // reverse: true,
            itemCount: lessons.length,
            itemBuilder: (BuildContext context, int index) {
              return makeCard(lessons[index]);
            },
          )
        : Lottie.asset(no_Notification_Animtion);

    final makeBottom = SizedBox(
      height: 55.0,
      child: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
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
      backgroundColor: Colors.white,

      appBar: topAppBar,
      body: makeBody,
      //bottomNavigationBar: makeBottom,
    );
  }
}
