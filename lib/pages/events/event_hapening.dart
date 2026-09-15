import 'package:ekidzee/api/request/EventHappeningImagesRequest.dart';
import 'package:ekidzee/api/request/eventhappening_request.dart';
import 'package:ekidzee/api/response/EventHappeningResponse.dart';
import 'package:ekidzee/api/response/event_happening_images_response.dart';
import 'package:ekidzee/utils/ImageSlider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/APIService.dart';
import '../../helper/LightColor.dart';
import '../../helper/LocalConstant.dart';
import '../../helper/utils.dart';
import '../../ui/theme.dart';
import '../../utils/QuadClipper.dart';

class EventAndHappeningScreen extends StatefulWidget {
  EventAndHappeningScreen({Key? key}) : super(key: key);

  late DateTime selectedDate = DateTime.now();
  final DateTime initialDate = DateTime.now();

  @override
  _EventAndHappening createState() => _EventAndHappening();
}

class _EventAndHappening extends State<EventAndHappeningScreen> {
  String userId = '';
  String userType = '';
  String _currentEventType = "EVT";
  String _eventType = "Event";
  late EventHappeningResponse eventHappeningInfo;
  List<DisplayEvent> _eventList = [];
  List<DisplayHappenings> _happeningList = [];
  List<String> eventTypeList = ['Event', 'Happening'];

  @override
  void initState() {
    widget.selectedDate = widget.initialDate;
    _eventList.add(DisplayEvent(
        title: '----',
        type: '-',
        eventDate: 'date',
        eventText: '-',
        createdBy: '-',
        postedDate: '-',
        username: '-',
        display: '-'));
    super.initState();
    //loadEventAndHappening();
    _eventList.clear();
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => getUserInfo());
    } catch (e) {
      //debugPrint(e.toString());
    }
    //debugPrint(userId);
  }

  Future<void> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(LocalConstant.KEY_UID) as String;
    userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
    //debugPrint('uid  is ${userId}');
    loadEventAndHappening();
  }

  Future<void> _onPressed({
    required BuildContext context,
  }) async {
    /*showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: widget.selectedDate,
      locale: Locale("en"),
    ).then((date) {
      if (date != null) {
        setState(() {
          widget.selectedDate = date;
          loadEventAndHappening();
        });
      }
    });*/
    /*
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2023)
    );
    if (selected != null) {
      setState(() {
        widget.selectedDate = selected;
        loadEventAndHappening();
      });
    }*/
  }

  void loadEventAndHappening() {
    //Utility.showLoaderDialog(context);
    String academicYearId = new DateFormat('yy').format(widget.selectedDate);
    int _currentMonth = widget.selectedDate.month;
    //debugPrint('load Event Happening ');
    //userId='3038662';
    //debugPrint('userId ${userId} ');
    APIService apiService = APIService();

    EventHappeningRequest request = EventHappeningRequest(
        Year: academicYearId.toString(),
        Event_Type: _currentEventType,
        Month: _currentMonth.toString(),
        User_ID: userId);
    apiService.getEventHappening(request).then((value) {
      if (value != null) {
        _eventList.clear();
        eventHappeningInfo = value;
        if (_currentEventType == 'EVT') {
          //debugPrint('EVT -----');
          _eventList.addAll(eventHappeningInfo.displayEvent);
        } else if (_currentEventType == 'HPN') {
          _happeningList.addAll(eventHappeningInfo.displayHappenings);
        }
        setState(() {});
        //debugPrint(_eventList.toString());
      } else {
        //Utility.showMessage(context, "Unable to get Events at this movement please try again later.");
        //debugPrint("null value");
      }
      //Navigator.pop(context);
    });
  }

  void loadEventAndHappeningImages(String eventId, String title) {
    Utility.showLoaderDialog(context);
    String academicYearId = new DateFormat('yy').format(widget.selectedDate);
    int _currentMonth = widget.selectedDate.month;
    //userId='3038662';
    //debugPrint('load Event Happening -- ${userId}');

    APIService apiService = APIService();

    EventHappeningImagesRequest request = EventHappeningImagesRequest(
        EventHappenings_ID: eventId, UserType: userType, UserID: userId);
    apiService.getEventHappeningImages(request).then((value) {
      if (value != null) {
        //Navigator.pop(context);
        EventHappeningImagesResponse imagesResponse = value;
        List<String> imageList = [];
        if (imagesResponse.eventsAndHappeningsImages.length > 0) {
          for (int index = 0;
              index < imagesResponse.eventsAndHappeningsImages.length;
              index++) {
            imageList.add(
                imagesResponse.eventsAndHappeningsImages[index].largeImage);
          }
        } else {}
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ImageSliderWidget(imageList: imageList, title: title);
            },
          ),
        );
      } else {
        //Utility.showMessage(context, "Unable to get Events at this movement please try again later.");
        //debugPrint("null value");
      }
    });
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  Widget _categoryRow(BuildContext context, String title) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20),
      height: 68,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: TextStyle(
                  color: LightColor.extraDarkPurple,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SizedBox(width: 20),
                  _chip(
                    'DATE_SEL',
                    new DateFormat('MMM yyyy').format(widget.selectedDate),
                    LightColor.lightOrange,
                    height: 6,
                  ),
                  SizedBox(width: 10),
                  /*_chip('',"Event", LightColor.orange, height: 6),*/
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: _eventType,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black, // <-- SEE HERE
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _eventType = newValue!;
                          if (_eventType == 'Event') {
                            _currentEventType = 'EVT';
                          } else {
                            _currentEventType = 'HPN';
                          }
                          loadEventAndHappening();
                        });
                      },
                      items: eventTypeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  void _onChanged(String _onChanged) {
    loadEventAndHappening();
  }

  dynamic getCurrentModel(index) {
    if (_currentEventType == 'EVT') {
      return _eventList[index];
    } else {
      return _happeningList[index];
    }
  }

  Widget getData() {
    if (_currentEventType == 'EVT' && _eventList.length > 0) {
      return ListView.builder(
        itemCount: _eventList.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _EventInfo(context, _eventList[index],
              _decorationContainerA(Colors.redAccent, -110, -85),
              background: LightColor.seeBlue);
        },
      );
    } else if (_currentEventType == 'HPN' && _happeningList.length > 0) {
      return ListView.builder(
        itemCount: _happeningList.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _Happening(context, _happeningList[index],
              _decorationContainerA(Colors.redAccent, -110, -85),
              background: LightColor.seeBlue);
        },
      );
    } else {
      return Utility.emptyDataSet(context);
    }
  }

  Widget _courseList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            getData(),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context,
      {Color primaryColor = Colors.redAccent, required Widget backWidget}) {
    return Card(
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: backWidget,
        ),
      ),
    );
  }

  void onHappeningItemClick(DisplayHappenings model) {
    loadEventAndHappeningImages(
        model.mEventsHappeningsId.toString(), model.title);
  }

  void onEventItemClick(DisplayEvent model) {
    loadEventAndHappeningImages(
        model.mEventsHappeningsId.toString(), model.title);
  }

  Widget _EventInfo(BuildContext context, DisplayEvent model, Widget decoration,
      {required Color background}) {
    return Card(
        child: GestureDetector(
      onTap: () {
        onEventItemClick(model);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12.0),
        ),
        height: 150,
        width: MediaQuery.of(context).size.width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .2,
              child: _card(context,
                  primaryColor: background, backWidget: decoration),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Text(model.title,
                            style: const TextStyle(
                                color: LightColor.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: background,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                          model.type.toString() == "EVT"
                              ? "EVENT"
                              : 'HAPPENING',
                          style: const TextStyle(
                            color: LightColor.grey,
                            fontSize: 14,
                          )),
                      const SizedBox(width: 10)
                    ],
                  ),
                ),
                Text(model.username,
                    style: AppTheme.h6Style.copyWith(
                      fontSize: 12,
                      color: LightColor.grey,
                    )),
                const SizedBox(height: 15),
                Text(model.eventText,
                    style: AppTheme.h6Style.copyWith(
                        fontSize: 12, color: LightColor.extraDarkPurple)),
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Text('Event Date : ',
                        style: AppTheme.h6Style.copyWith(
                            fontSize: 12, color: LightColor.extraDarkPurple)),
                    _chip('', model.eventDate, LightColor.darkOrange,
                        height: 5),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Post Date : ',
                        style: AppTheme.h6Style.copyWith(
                            fontSize: 12, color: LightColor.extraDarkPurple)),
                    _chip('', model.postedDate, LightColor.seeBlue, height: 5),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    ));
  }

  Widget _Happening(
      BuildContext context, DisplayHappenings model, Widget decoration,
      {required Color background}) {
    return Card(
      child: GestureDetector(
        onTap: () {
          onHappeningItemClick(model);
        },
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width - 20,
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: .2,
                child: _card(context,
                    primaryColor: background, backWidget: decoration),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Text(model.title,
                              style: TextStyle(
                                  color: LightColor.purple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: background,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            model.type.toString() == "EVT"
                                ? "EVENT"
                                : 'HAPPENING',
                            style: TextStyle(
                              color: LightColor.grey,
                              fontSize: 14,
                            )),
                        SizedBox(width: 10)
                      ],
                    ),
                  ),
                  Text(model.username as String,
                      style: AppTheme.h6Style.copyWith(
                        fontSize: 12,
                        color: LightColor.grey,
                      )),
                  SizedBox(height: 15),
                  Text(model.eventText as String,
                      style: AppTheme.h6Style.copyWith(
                          fontSize: 12, color: LightColor.extraDarkPurple)),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Text('Event Date : ',
                          style: AppTheme.h6Style.copyWith(
                              fontSize: 12, color: LightColor.extraDarkPurple)),
                      _chip(
                          '', model.eventDate as String, LightColor.darkOrange,
                          height: 5),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Post Date : ',
                          style: AppTheme.h6Style.copyWith(
                              fontSize: 12, color: LightColor.extraDarkPurple)),
                      _chip('', model.postedDate as String, LightColor.seeBlue,
                          height: 5),
                    ],
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String actionString, String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return GestureDetector(
      //onTap: clipClick(actionString),
      onTap: () => clipClick(actionString),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: textColor.withAlpha(isPrimaryCard ? 150 : 50),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
        ),
      ),
    );
  }

  Widget _decorationContainerA(Color primaryColor, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: LightColor.darkseeBlue,
          ),
        ),
        _smallContainer(LightColor.yellow, 40, 20),
        Positioned(
          top: -30,
          right: -10,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        ),
        Positioned(
          top: 110,
          right: -50,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: LightColor.darkseeBlue,
            child:
                CircleAvatar(radius: 40, backgroundColor: LightColor.seeBlue),
          ),
        ),
      ],
    );
  }

  Widget _decorationContainerB() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -65,
          left: -65,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: LightColor.lightOrange2,
            child: CircleAvatar(
                radius: 30, backgroundColor: LightColor.darkOrange),
          ),
        ),
        Positioned(
            bottom: -35,
            right: -40,
            child:
                CircleAvatar(backgroundColor: LightColor.yellow, radius: 40)),
        Positioned(
          top: 50,
          left: -40,
          child: _circularContainer(70, Colors.transparent,
              borderColor: Colors.white),
        ),
      ],
    );
  }

  Widget _decorationContainerC() {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: -65,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Color(0xfffeeaea),
          ),
        ),
        Positioned(
            bottom: -30,
            right: -25,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: LightColor.yellow, radius: 40))),
        _smallContainer(
          Colors.yellow,
          35,
          70,
        ),
      ],
    );
  }

  Positioned _smallContainer(Color primaryColor, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primaryColor.withAlpha(255),
        ));
  }

  BottomNavigationBarItem _bottomIcons(IconData icon) {
    return BottomNavigationBarItem(
        //  backgroundColor: kPrimaryLightColor,
        icon: Icon(icon),
        label: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*bottomNavigationBar: BottomNavigationBar(
        backgroundColor: LightColor.background,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: LightColor.purple,
        unselectedItemColor: Colors.grey.shade300,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        items: [
          _bottomIcons(Icons.home),
          _bottomIcons(Icons.star_border),
          _bottomIcons(Icons.book),
          _bottomIcons(Icons.person),
        ],
        onTap: (index) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SplashScreen()));
        },
      ),*/
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              /*_header(context),*/
              SizedBox(height: 10),
              _categoryRow(context, "Event and Happening"),
              _courseList(context)
            ],
          ),
        ),
      ),
    );
  }

  clipClick(String actionString) {
    //debugPrint(actionString);
    if (actionString == 'DATE_SEL') {
      _onPressed(context: context);
    }
  }
}
