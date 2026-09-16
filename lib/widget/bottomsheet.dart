import 'dart:async';
import 'dart:collection';

import 'package:ekidzee/api/request/pentemind/myclass/day_calendar.dart';
import 'package:ekidzee/helper/LightColor.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/ServiceHandler.dart';
import '../api/response/celibration/zll_celibration_response.dart';
import '../api/response/pentemind/myclass/day_calender.dart';
import '../app_routes.dart';
import '../iface/onResponse.dart';

class KidzeeBottomSheet {
  void showBSCulminationList(
      BuildContext context, int programId, onClickListener clickListener) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) =>
            showCulminationList(context, programId, clickListener));
  }

  void showBSPromo(BuildContext context, CelibrationModel model,
      onClickListener clickListener) {
//     debugPrint('showing the promo');
    CountdownController controller = CountdownController();
    double width = MediaQuery.of(context).size.width;
    Future.delayed(const Duration(milliseconds: 1500), () {
      controller.start();
    });
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: kIsWeb ? true : false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (builder) => FractionallySizedBox(
        //heightFactor: 0.8,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: IntrinsicHeight(
            // Wrap with IntrinsicHeight
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Allow content to determine height
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: width * 0.7,
                        child:
                            Text(model.title, style: LightColors.subTextStyle),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.pause();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Image.asset('assets/icons/ic_close.png', width: 24),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  child: Stack(
                    children: [
                      Image.network(
                        model.contenturl,
                        fit: BoxFit.fitWidth, // Ensure proper image scaling
                      ),
                      if (model.viewurl.isNotEmpty)
                        Positioned.fill(
                          child: Center(
                            child: Image.asset('assets/icons/ic_play.png',
                                width: 75),
                          ),
                        ),
                    ],
                  ),
                  onTap: () async {
//                     debugPrint('on Tap 92');
//                     debugPrint('in 94 ${model.viewurl}');
                    if (model.viewurl.isEmpty) {
                    } else if (model.viewurl.contains('m3u8')) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => goToKltChewieVideo(
                              filePath: model.viewurl, Title: model.title),
                        ),
                      );
                    } else {
//                       debugPrint('in else');
                      await openCelebrationWebsite(
                        context,
                        title: model.title,
                        url: model.viewurl,
                        popCurrent: true,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // showModalBottomSheet(
    //     backgroundColor: Colors.transparent,
    //     isScrollControlled: true,
    //     isDismissible: false,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(20),
    //         topRight: Radius.circular(20),
    //       ),
    //     ),
    //     context: context,
    //     builder: (builder) => FractionallySizedBox(
    //           heightFactor: 0.8,
    //           /*height: MediaQuery.of(context).size.height,*/
    //           child: Card(
    //               color: Colors.white,
    //               margin: const EdgeInsets.only(
    //                   left: 18.0, right: 18.0, bottom: 18.0),
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(15)),
    //               child: Container(
    //                 //height: MediaQuery.of(context).size.height * 0.9,
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Padding(padding: EdgeInsets.only(left: 10),
    //                         child: SizedBox( width:width * 0.7, child: Text(model.title,style: LightColors.subTextStyle,)),),
    //                         InkWell(
    //                           onTap: () {
    //                             _controller.pause();
    //                             Navigator.pop(context);
    //                           },
    //                           child: Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Image.asset('assets/icons/ic_close.png',width: 24,),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     Expanded(
    //                       child: GestureDetector(
    //                           child:  Stack(
    //                                     children: [Image.network(
    //                                       model.contenturl,fit: BoxFit.fill,
    //                                     ),
    //                                       Positioned.fill(
    //                                         child: Center(
    //                                           child: Image.asset('assets/icons/ic_play.png',width: 75,),
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                         onTap: () {
    //                           debugPrint('on Tap 92');
    //                           //_controller.pause();
    //                           debugPrint('in 94 ${model.viewurl}');
    //                           if (model.viewurl.contains('m3u8')) {
    //                             Navigator.pop(context);
    //                             Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       KltChewieDemo(
    //                                           filePath: model.viewurl,
    //                                           Title: model.title)),
    //                             );
    //                           } else {
    //                             debugPrint('in else');
    //                             Navigator.of(context).push(MaterialPageRoute(
    //                             builder: (BuildContext context) =>
    //                                 MyWebsiteView(title: model.title,url: model.viewurl,)));
    //                           }
    //                           //Navigator.pop(context);
    //                         },
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               )),
    //         ));
  }

  void showExitBSPromo(BuildContext context, CelibrationModel model,
      onClickListener clickListener) {
    CountdownController controller = CountdownController();
    double width = MediaQuery.of(context).size.width;
    Future.delayed(const Duration(milliseconds: 1500), () {
      controller.start();
    });
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (builder) => FractionallySizedBox(
              heightFactor: 0.8,
              /*height: MediaQuery.of(context).size.height,*/
              child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                      left: 18.0, right: 18.0, bottom: 18.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    //height: MediaQuery.of(context).size.height * 0.9,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: SizedBox(
                                  width: width * 0.7,
                                  child: Text(
                                    model.title,
                                    style: LightColors.subTextStyle,
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                controller.pause();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/icons/ic_close.png',
                                  width: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Stack(
                              children: [
                                Image.network(
                                  model.contenturl,
                                  fit: BoxFit.cover,
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icons/ic_play.png',
                                      width: 75,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
//                               debugPrint('on Tap 92');
                              //_controller.pause();
//                               debugPrint('in 94 ${model.viewurl}');
                              if (model.viewurl.contains('m3u8')) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => goToKltChewieVideo(
                                        filePath: model.viewurl,
                                        Title: model.title),
                                  ),
                                );
                              } else {
//                                 debugPrint('in else');
                                await openCelebrationWebsite(
                                  context,
                                  title: model.title,
                                  url: model.viewurl,
                                  popCurrent: true,
                                );
                              }
                              //Navigator.pop(context);
                            },
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              clickListener.onClick(100, 'exit');
                            },
                            child: Text(
                              'Exit',
                              style: LightColors.textHeaderStyle13
                                  .copyWith(color: Colors.white),
                            ))
                      ],
                    ),
                  )),
            ));
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  static Widget showCulminationList(
      BuildContext context, int programId, onClickListener clickListener) {
    List<GridModel> list = [];
    list.add(GridModel('Culmination 1', 1, 1, LightColor.lightOrange));
    list.add(GridModel('Culmination 2', 2, 1, LightColor.lightBlue));
    list.add(GridModel('Culmination 3', 3, 1, LightColor.lightpurple));
    list.add(GridModel('Culmination 4', 4, 1, LightColor.lightseeBlue));
    list.add(GridModel('Culmination 5', 5, 1, LightColor.lightGrey));
    list.add(GridModel('Culmination 6', 6, 1, LightColor.lightOrange));

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.41,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Select Culmination',
                  style: LightColors.textHeaderStyle13,
                ),
                Flexible(
                    child: GridView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => CulminationTile(
                      list[index], programId, context, '', clickListener),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                  ),
                )),
              ],
            )),
      ),
    );
  }

  void showBSWeelList(
      BuildContext context,
      int culminationId,
      List<GridModel> list,
      DayCalenderResponse dayResposne,
      onClickListener clickListener) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: showWeekList(
                context, culminationId, list, dayResposne, clickListener),
          );
        }
        /*builder: (builder) =>
            showWeekList(context,culminationId,list,dayResposne,clickListener)*/
        );
  }

  Widget showWeekList(
      BuildContext context,
      int culminationId,
      List<GridModel> list,
      DayCalenderResponse dayResposne,
      onClickListener clickListener) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 1.2,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Select Week',
                  style: LightColors.textHeaderStyle13,
                ),
                SizedBox(
                    height: 230,
                    child: /*Flexible(
                        child:*/
                        GridView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) => CulminationTile(
                          list[index], 0, context, dayResposne, clickListener),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                      ),
                    )), //),
                Text(
                  'Select Floating Day',
                  style: LightColors.textHeaderStyle13,
                ),
                SizedBox(
                    height: 250,
                    child: GridView.builder(
                      itemCount: dayResposne.data.FloatingDay.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: index < LightColor.list.length
                              ? LightColor.list[index].withOpacity(0.3)
                              : LightColors.kLightBlue,
                          onTap: () {
                            Navigator.of(context).pop();
                            clickListener.onClick(
                                Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK,
                                dayResposne.data.FloatingDay[0]);
                          },
                          title: Text(
                            dayResposne.data.FloatingDay[0].AttendanceDate,
                            key: Key(
                                dayResposne.data.FloatingDay[0].AttendanceDate),
                          ),
                          subtitle:
                              Text(dayResposne.data.FloatingDay[0].remark),
                        ),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}

void showBSDayList(BuildContext context, List<CuminationDayModel> dayList,
    onClickListener clickListener) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: showDayList(context, dayList, clickListener),
        );
      }
      /*builder: (builder) =>
            showWeekList(context,culminationId,list,dayResposne,clickListener)*/
      );
}

Widget showDayList(BuildContext context, List<CuminationDayModel> dayList,
    onClickListener clickListener) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 1.2,
    child: Card(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Day',
                style: LightColors.textHeaderStyle13,
              ),
              Flexible(
                  child: ListView.builder(
                itemCount: dayList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: index < LightColor.list.length
                        ? LightColor.list[index].withOpacity(0.3)
                        : LightColors.kLightBlue,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      // debugPrint(dayList[index].toJson());
                      clickListener.onClick(
                          Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK,
                          dayList[index]);
                    },
                    leading: CircleAvatar(
                      backgroundColor: LightColor.list[index].withOpacity(0.2),
                      child: Text(
                        dayList[index].D.toString(),
                        style: LightColors.textStyle,
                      ),
                    ),
                    title: Text(
                      dayList[index].CName,
                      key: Key(dayList[index].CName),
                    ),
                    subtitle: Text(dayList[index].AttendanceDate),
                  ),
                ),
              )),
            ],
          )),
    ),
  );
}

class GridModel {
  final String name;
  final int id;
  final int type;
  final Color color;

  GridModel(this.name, this.id, this.type, this.color);
}

class CulminationTile extends StatelessWidget implements onResponse {
  final GridModel culmination;
  final int programID;
  final BuildContext context;
  final dynamic response;
  onClickListener clickListener;

  CulminationTile(this.culmination, this.programID, this.context, this.response,
      this.clickListener,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        tileColor: culmination.color.withOpacity(0.3),
        onTap: () {
          //Navigator.of(context).pop();
          if (culmination.type == 1) {
            Utility.showLoaderDialog(context);
            GetDayCalenderRequest request =
                GetDayCalenderRequest(C: culmination.id, ProgramId: programID);
            ApiServiceHandler().getCalendarDay(request, this);
            //KidzeeBottomSheet().showBSWeelList(context, culmination.id, clickListener);
          } else {
            if (response is DayCalenderResponse) {
              DayCalenderResponse dayResponse = response;
              List<CuminationDayModel> dayList = [];
              for (int index = 0;
                  index < dayResponse.data.CulDay.length;
                  index++) {
                if (culmination.id == dayResponse.data.CulDay[index].W) {
                  dayList.add(dayResponse.data.CulDay[index]);
                }
              }
              showBSDayList(context, dayList, clickListener);
            }
          }
        },
        title: Text(
          culmination.name,
          key: Key(culmination.name),
          style: LightColors.textHeaderStyle13,
        ),
      ),
    );
  }

  @override
  void onError(int action, value) {
    // TODO: implement onError
    Navigator.of(context, rootNavigator: true).pop('dialog');
    Navigator.of(context).pop();
  }

  @override
  void onResponseStart() {
    // TODO: implement onResponseStart
  }

  @override
  void onSuccess(value) {
    // TODO: implement onSuccess
    Navigator.of(context, rootNavigator: true).pop('dialog');
    Navigator.of(context).pop();
    if (value is DayCalenderResponse) {
      DayCalenderResponse response = value;
      List<GridModel> list = [];
      HashMap<String, String> map = HashMap();
      int iIndex = 0;
      for (int index = 0; index < response.data.CulDay.length; index++) {
        if (!map.containsKey('Week ${response.data.CulDay[index].W}')) {
          list.add(GridModel('Week ${response.data.CulDay[index].W}',
              response.data.CulDay[index].W, 2, LightColor.list[iIndex]));
          iIndex++;
//           debugPrint('Week ${response.data.CulDay[index].W}');
          map.putIfAbsent('Week ${response.data.CulDay[index].W}',
              () => 'Week ${response.data.CulDay[index].W}');
        }
      }
      KidzeeBottomSheet().showBSWeelList(
          context, culmination.id, list, response, clickListener);
    }
  }
}
