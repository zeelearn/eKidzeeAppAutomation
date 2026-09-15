import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../api/response/pentemind/parent/myhomework.dart';
import '../constants.dart';

///Code starts here
class CalendarAppBar extends StatefulWidget implements PreferredSizeWidget {
  ///accent color of UI
  final Color? accent;

  ///definiton of your specific shade of white
  final Color? white;

  ///definiton of your specific shade of black
  final Color? black;

  ///the last date shown on the calendar
  final MyHomeworkModel lastDate;

  ///the first date shown on the calendar
  final MyHomeworkModel? firstDate;

  //the selected date shown on the calendar
  final MyHomeworkModel? selectedDate;

  ///list of dates with specific event (shown as a dot above the date)
  final List<MyHomeworkModel>? events;

  ///function which returns currently selected date
  final Function onDateChanged;

  ///definition of your custom padding
  final double? padding;

  ///definition of the atribute which shows full calendar view when pressing on date
  final bool? fullCalendar;

  ///[backButton] shows BackButton in set to true
  final bool? backButton;

  ///definiton of the calendar language
  final String? locale;

  ///initialization of [CalendarAppBar]
  CalendarAppBar({
    super.key,
    required this.lastDate,
    this.firstDate,
    required this.onDateChanged,
    this.selectedDate,
    this.events,
    this.fullCalendar,
    this.backButton,
    this.accent,
    this.white,
    this.black,
    this.padding,
    this.locale,
  }) {
    firstDate ?? DateTime(1950);
  }

  @override

  ///creating state
  _CalendarAppBarState createState() => _CalendarAppBarState();

  @override

  ///creating a getter for [preferredSize]
  Size get preferredSize => Size.fromHeight(250.0);
}

class _CalendarAppBarState extends State<CalendarAppBar> {
  ///defininon of [selectedDate] variable of current selected date
  late MyHomeworkModel selectedDate;

  ///defininon of [firstDate] variable of current selected date
  late MyHomeworkModel firstDate;

  ///defininon of [position] variable of current selected calendar card
  late int position;

  ///definition of the last selected date
  late MyHomeworkModel referenceDate;

  ///list of dates with specific event (shown as a dot above the date)
  List<String> datesWithEnteries = [];

  ///definiton of your specific shade of white
  late Color white;

  ///accent color of UI
  late Color accent;

  ///definiton of your specific shade of black
  late Color black;

  ///definition of your custom padding
  late double padding;

  ///definition of the atribute which shows full calendar view when pressing on date
  late bool fullCalendar;

  ///[backButton] shows BackButton in set to true
  late bool backButton;

  ///[locale] is used for current local language of the library
  String get _locale => widget.locale ?? 'en';

  ///intializing values of atributes which were not defined by user
  @override
  void initState() {
    setState(() {
      ///initializing accent
      accent = widget.accent ?? kPrimaryLightColor; //Color(0xFF0039D9);

      ///initilizing first date
      firstDate = widget.firstDate!; // ?? DateTime(1950);

      ///initializing white
      white = widget.white ?? Colors.white;

      ///initializing black
      black = widget.black ?? Colors.black87;

      ///initializing padding
      padding = widget.padding ?? 25.0;

      ///initializing backbutton
      backButton = widget.backButton ?? true;

      ///initializing fullCalendar
      fullCalendar = widget.fullCalendar ?? true;

      ///initializing firstDate
      selectedDate = widget.selectedDate ?? widget.lastDate;

      ///initializing referenceDate
      referenceDate = selectedDate;

      ///initializing language
      initializeDateFormatting(_locale);

      ///initializing position to 1
      position = 1;
    });

    ///changing event list to specific form
    if (widget.events != null) {
      ///for each item from event list, add just date String without time
      for (var element in widget.events!) {
        datesWithEnteries.add(element.toString().split(" ").first);
      }
    }
    super.initState();
  }

  ///definition of scroll controller
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ///changing all dates to correct form for easier

    ///intitializing first date and setting it to midnight
    /*DateTime first =
    DateTime.parse("${firstDate.toString().split(" ").first} 00:00:00.000");

    ///intitializing last date and setting it to 11 pm due to the time saving
    DateTime last = DateTime.parse(
        "${widget.lastDate.toString().split(" ").first} 23:00:00.000");

    ///creating date for List generation
    DateTime basicDate =
    DateTime.parse("${first.toString().split(" ").first} 12:00:00.000");*/

    ///List of all dates that will be shown in scroller
    List<MyHomeworkModel> pastDates = widget
        .events!; /* List.generate(
        (last.difference(first).inHours / 24).round(),
            (index) => basicDate.add(Duration(days: index)));*/

    ///Sorting dates in descending order
    //pastDates.sort((b, a) => a.compareTo(b));
    parseCname(String value) {
      int day = 0;
      try {
        List<String> obj = value.split("D");
        day = int.parse(obj[1].replaceAll('D', ''));
      } catch (e) {}
      return day;
    }

    ///creating function which return date scroller
    Widget calendarView() {
      ///UI for calendar scrollview
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 105.0,
        alignment: Alignment.bottomCenter,
        child: NotificationListener(
          onNotification: (dynamic notification) {
            ///scrolling mechanism defined
            double width = MediaQuery.of(context).size.width;

            ///defining widthUnit which presents one fifth of the screen minus
            ///4.0 px of padding between two date cards
            double widthUnit = width / 5 - 4.0;

            ///definition of offset which is the distance from scrolling beggining
            double offset = scrollController.offset;

            ///handeling situation if user finnished drag when scrolling but scrollview
            ///is still moving
            if (notification is UserScrollNotification &&
                notification.direction == ScrollDirection.idle &&

                // ignore_for_file: invalid_use_of_visible_for_testing_member
                // ignore_for_file: invalid_use_of_protected_member
                scrollController.position.activity is! HoldScrollActivity) {
              ///in case that scrollview is not at the beggining, then align it
              ///so all five date cards are fully visible on the screen
              if (offset > 0) {
                //animated scroll
                scrollController.animateTo(
                    (offset / widthUnit).round() * (widthUnit),
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut);
              }

              ///compare last last selected date with curren selected date
              ///if date has changed return new selected date
              if (referenceDate.toString().split(" ").first !=
                  selectedDate.toString().split(" ").first) {
                ///wait that animation is finnished and than call function [onDateChange]
                Future.delayed(Duration(milliseconds: 100), () {
                  widget.onDateChanged(selectedDate);
                });
                setState(() {
                  ///safe last selected date to referenceDate
                  referenceDate = selectedDate;
                });
              }
            }

            ///if the position of current selected card is out of screen when
            ///scrolling to the left
            if (offset > position * widthUnit - (widthUnit / 2)) {
              setState(() {
                ///increase position by one
                position = position + 1;

                ///set selectedDate on previous date
                //selectedDate = selectedDate.subtract(Duration(days: 1));

                ///adding hapric feedback in the future
                //HapticFeedback.lightImpact();
              });
            }

            ///if the position of current selected card is out of screen when
            ///scrolling to the right
            else if (offset + width < position * widthUnit - (widthUnit / 2)) {
              setState(() {
                ///decrease position by one
                position = position - 1;

                ///set selectedDate on previous date
                //selectedDate = selectedDate.add(Duration(days: 1));

                ///adding hapric feedback in the future
                //HapticFeedback.lightImpact();
              });
            }
            //unnecesary return
            return true;
          },

          ///UI for calendar scrollview
          child: ListView.builder(
              padding: pastDates.length < 5
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width *
                          (5 - pastDates.length) /
                          10)
                  : const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              reverse: true,
              controller: scrollController,
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: pastDates.length,
              itemBuilder: (context, index) {
                ///definition date which is set to the current building date from dates list
                MyHomeworkModel date = pastDates[index];

                ///if position of currently selected is equal to index + 1 (counting of positions starts with 1)
                bool isSelected = position == index + 1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    ///if pressed on specific date, set it as selected
                    onTap: () {
                      setState(() {
                        ///if user taps on this card set all parameters to this date
//                         debugPrint('date selected');
                        selectedDate = date;
                        referenceDate = selectedDate;
                        position = index + 1;
                      });
                      widget.onDateChanged(selectedDate);
                    },

                    ///different UI for nonselected containers and the selected ones
                    ///this is the definition of the main container of calendar card
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 5 - 4.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: Container(
                            height: 80.0,
                            width: MediaQuery.of(context).size.width / 5 - 4.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: isSelected ? white : null,
                              boxShadow: [
                                isSelected
                                    ? BoxShadow(
                                        color: LightColors.kLightBlueMaterial,
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      )
                                    : BoxShadow(
                                        color: Colors.grey.withOpacity(0.0),
                                        spreadRadius: 5,
                                        blurRadius: 20,
                                        offset: Offset(0, 3),
                                      )
                              ],
                            ),

                            ///definition of content inside of calendar card
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ///indicators of event on specific date
                                datesWithEnteries.contains(
                                        date.toString().split(" ").first)
                                    ? Container(
                                        width: 10.0,
                                        height: 10.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: datesWithEnteries.contains(date
                                                  .toString()
                                                  .split(" ")
                                                  .first)
                                              ? LightColors.kRed
                                              : isSelected
                                                  ? LightColors.kRed
                                                  : white.withOpacity(0.6),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 5.0,
                                      ),
                                SizedBox(height: 10),

                                ///date number
                                Text(
                                  '${parseCname(date.CName)}' /*DateFormat("dd").format(date)*/,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: datesWithEnteries.contains(
                                              date.toString().split(" ").first)
                                          ? LightColors.kRed
                                          : isSelected
                                              ? accent
                                              : white.withOpacity(0.6),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),

                                ///day of the week
                                Text(
                                  'Day' /*DateFormat.E(Locale(_locale).toString())
                                      .format(date)*/
                                  ,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: isSelected
                                          ? datesWithEnteries.contains(date
                                                  .toString()
                                                  .split(" ")
                                                  .first)
                                              ? LightColors.kRed
                                              : accent
                                          : white.withOpacity(0.6),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }

    ///this function show full calendar view currently shown as modal bottom sheet
    showFullCalendar(String locale) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        builder: (BuildContext context) {
          double height;
          MyHomeworkModel? endDate = widget.lastDate;

          /*if (firstDate.year == endDate.year &&  firstDate.month == endDate.month) {
            height =
                ((MediaQuery.of(context).size.width - 2 * padding) / 7) * 5 +
                    150.0;
          } else {*/
          height = (MediaQuery.of(context).size.height - 100.0);
          //}
          return SizedBox(
            height: height,

            ///usage of full calender widget, which is defined below
            child: FullCalendar(
              height: height,
              startDate: firstDate,
              endDate: endDate,
              padding: padding,
              accent: accent,
              black: black,
              white: white,
              events: widget.events,
              selectedDate: referenceDate,
              locale: locale,
              onDateChange: (value) {
                ///systematics of selecting specific date
                //HapticFeedback.lightImpact();

                ///hide modal bottom sheet
                Navigator.pop(context);

                ///define new variables
                //DateTime referentialDate = DateTime.parse("${value.toString().split(" ").first} 12:00:00.000");

                ///definition of [oldPosition]
                int? oldPosition;

                ///definition of [positionDifference]
                late int positionDifference = 1;

                ///calculate new position of scrollview
                setState(() {
                  ///setting current position to old position
                  oldPosition = position;

                  ///counting the difference between dates
                  //positionDifference = -((referentialDate.difference(referenceDate).inHours / 24) .round());
                });

                ///saving current offset
                double offset = scrollController.offset;

                ///counting card width (similar to above)
                double widthUnit = MediaQuery.of(context).size.width / 5 - 4.0;

                ///wait to modal bottom sheet to hide
                Future.delayed(Duration(milliseconds: 100), () {
                  ///definition maximal offset based on maxScrollExtent
                  double maxOffset = scrollController.position.maxScrollExtent;

                  ///definition of minimal offset
                  double minOffset = 0.0;

                  ///counting current offset based of curren positon
                  double newOffset =
                      (offset + (widthUnit * positionDifference));

                  ///if current offset is out of bounderies set it to maximal or minimal offset
                  if (newOffset > maxOffset)
                    newOffset = maxOffset;
                  else if (newOffset < minOffset) newOffset = minOffset;

                  ///scroll the calendar scroller to the selected date
                  scrollController.animateTo(newOffset,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);

                  ///wait on animation to be finished
                  Future.delayed(Duration(milliseconds: 550), () {
                    setState(() {
                      ///set slected date to current value
                      selectedDate = value;

                      ///set refernece date to selected date
                      referenceDate = selectedDate;

                      ///change position to current position
                      position = oldPosition! + positionDifference;
                    });
                  });
                });

                ///call function to return new selected date
                widget.onDateChanged(value);
              },
            ),
          );
        },
      );
    }

    ///UI of the whole appbar
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 140.0,

      ///it is based on stack of widgets
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150.0,
              color: accent,
            ),
          ),
          Positioned(
              top: 10.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - (padding * 2),
                  child: backButton
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: white,
                                ),
                                onTap: () => Navigator.pop(context)),
                            GestureDetector(
                              onTap: () => fullCalendar
                                  ? showFullCalendar(_locale)
                                  : null,
                              child: Text(
                                'Full View', //DateFormat.yMMMM(Locale(_locale).toString()).format(selectedDate),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => fullCalendar
                                  ? showFullCalendar(_locale)
                                  : null,
                              child: Text(
                                selectedDate
                                    .CName, //DateFormat.yMMMM(Locale(_locale).toString()).format(selectedDate),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                ),
              )),
          Positioned(
            bottom: 0.0,

            /// call calendarView function from above
            child: calendarView(),
          ),
        ],
      ),
    );
  }
}

///definition of full calendar shown in modal bottom sheet
class FullCalendar extends StatefulWidget {
  ///same variables as in CalendarAppBar class
  ///the first date shown on the calendar
  final MyHomeworkModel startDate;

  ///the last date shown on the calendar
  final MyHomeworkModel? endDate;

  ///currently selected date
  final MyHomeworkModel? selectedDate;

  ///definiton of your specific shade of black
  final Color? black;

  ///accent color of UI
  final Color? accent;

  ///definiton of your specific shade of white
  final Color? white;

  ///definition of your custom padding
  final double? padding;

  ///definition of height
  final double? height;

  ///definition of locale
  final String? locale;

  ///list of dates with specific event (shown as a dot above the date)
  final List<MyHomeworkModel>? events;

  ///function which returns currently selected date
  final Function onDateChange;

  const FullCalendar({
    super.key,
    this.accent,
    this.endDate,
    required this.startDate,
    required this.padding,
    this.events,
    this.black,
    this.white,
    this.height,
    this.locale,
    this.selectedDate,
    required this.onDateChange,
  });
  @override
  _FullCalendarState createState() => _FullCalendarState();
}

class _FullCalendarState extends State<FullCalendar> {
  ///definition of [endDate]
  late MyHomeworkModel endDate;

  ///definition of [startDate]
  late MyHomeworkModel startDate;

  ///definition of [events]
  List<MyHomeworkModel>? events = [];

  ///transforming variables to correct form
  @override
  void initState() {
    setState(() {
      ///parsing [startDate] String to DateTime
      startDate = widget.events![
          0]; //DateTime.parse("${widget.startDate.toString().split(" ").first} 00:00:00.000");

      ///parsing [endDate] String to DateTime
      endDate = widget.events![widget.events!.length -
          1]; //DateTime.parse("${widget.endDate.toString().split(" ").first} 23:00:00.000");

      ///initializing [events]
      events = widget.events!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///transforming variables to correct form

    ///creating List of parts [partsStart] of DateTime String format
    //List<String> partsStart = startDate.toString().split(" ").first.split("-");

    ///parsing [partsStart] List of Strings to DateTime
    //DateTime firstDate = DateTime.parse("${partsStart.first}-${partsStart[1].padLeft(2, '0')}-01 00:00:00.000");

    ///creating List of parts [partsEnd] of DateTime String format
    //List<String> partsEnd = endDate.toString().split(" ").first.split("-");

    ///parsing [partsStart] List of Strings to DateTime
    //DateTime lastDate = DateTime.parse( "${partsEnd.first}-${(int.parse(partsEnd[1]) + 1).toString().padLeft(2, '0')}-01 23:00:00.000") .subtract(Duration(days: 1));

    ///calculating the height based of the screen height
    double width = MediaQuery.of(context).size.width - (1 * widget.padding!);

    ///definition of DateTime list dates
    //List<MyHomeworkModel?> dates = [];

    /// definition of [referenceDate]
    //MyHomeworkModel referenceDate = firstDate;

    ///creating list for calendar matrix
    /*while (referenceDate.isBefore(lastDate)) {
      List<String> referenceParts = referenceDate.toString().split(" ");
      DateTime newDate = DateTime.parse("${referenceParts.first} 12:00:00.000");
      dates.add(newDate);

      ///adding next date
      referenceDate = newDate.add(Duration(days: 1));
    }*/

    ///check if range is in the same month
    if (true /*firstDate.year == lastDate.year && firstDate.month == lastDate.month*/) {
      return Padding(
        padding:
            EdgeInsets.fromLTRB(widget.padding!, 40.0, widget.padding!, 0.0),
        child: month(events!, events![0], width, widget.locale),
      );
    } else {
      ///creating the list of the month in the range
      List<String?> months = [];
      //months.add('Culmination 1');
      //months.add('Culmination 2');
      /*for (int i = 0; i < dates.length; i++) {
        if (i == 0 || (dates[i]!.month != dates[i - 1]!.month)) {
          months.add(dates[i]);
        }
      }*/

      ///sort months
      months.sort((b, a) => a!.compareTo(b!));
      return Padding(
        padding:
            EdgeInsets.fromLTRB(widget.padding!, 40.0, widget.padding!, 0.0),
        child: Container(
          ///scrolling of calendar
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: events!.length,
              itemBuilder: (context, index) {
                //String? date = months[index];
                List<String?> daysOfMonth = [];
                for (int index = 0; index < 1; index++ /*var item in dates*/) {
                  //if (date!.month == item!.month && date.year == item.year) {
                  daysOfMonth.add('$index');
                  //}
                }

                ///check if the date is the last
                bool isLast = index == 0;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0.0 : 25.0),
                  child: month(events!, events![index], width, widget.locale),
                );
              }),
        ),
      );
    }
  }

  ///definiton of week row that shows the day of the week for specific week
  Widget daysOfWeek(double width, String? locale) {
    List daysNames = [];
    for (var day = 12; day <= 19; day++) {
      daysNames.add(DateFormat.E(locale.toString())
          .format(DateTime.parse('1970-01-$day')));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        dayName(width / 7, daysNames[0]),
        dayName(width / 7, daysNames[1]),
        dayName(width / 7, daysNames[2]),
        dayName(width / 7, daysNames[3]),
        dayName(width / 7, daysNames[4]),
        dayName(width / 7, daysNames[5]),
        dayName(width / 7, daysNames[6]),
      ],
    );
  }

  ///definition of day widget
  Widget dayName(double width, String text) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: widget.black!.withOpacity(0.8)),
      ),
    );
  }

  parseCname(String value) {
    int day = 0;
    try {
      List<String> obj = value.split("D");
      day = int.parse(obj[1].replaceAll('D', ''));
    } catch (e) {}
    return day;
  }

  ///definition of date in Calendar widget
  Widget dateInCalendar(
      MyHomeworkModel day, bool outOfRange, double width, bool event) {
    ///comparing the date of current building widget with selected widget
    bool isSelectedDate = day.CName.toString().split(" ").first ==
        widget.selectedDate.toString().split(" ").first;
    bool isSelected = day.CName.contains('55') ? false : true;
//     debugPrint('${day.CName} ${isSelected}');
    return Container(
      child: GestureDetector(
        onTap: () => outOfRange ? null : widget.onDateChange(day),
        child: true
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 5 - 4.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width / 5 - 4.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: LightColors.kLightGrayM,
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),

                      ///definition of content inside of calendar card
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///indicators of event on specific date
                          Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  event ? LightColors.kRed : kPrimaryLightColor,
                            ),
                          ),

                          SizedBox(height: 10),

                          ///date number
                          Text(
                            '${parseCname(day.CName)}' /*DateFormat("dd").format(date)*/,
                            style: TextStyle(
                                fontSize: 22.0,
                                color: event ? Colors.red : Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),

                          ///day of the week
                          Text(
                            'Day' /*DateFormat.E(Locale(_locale).toString())
                                      .format(date)*/
                            ,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: LightColors.kRed,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                width: width / 7,
                height: width / 7,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelectedDate ? widget.accent : Colors.transparent),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${parseCname(day.CName)}',
                        style: TextStyle(

                            ///UI of full calendar shows also the dates that are out
                            ///of the range defined by first and last date, although
                            ///the UI is different for the dates out of range
                            color: outOfRange
                                ? isSelectedDate
                                    ? widget.white!.withOpacity(0.9)
                                    : widget.black!.withOpacity(0.4)
                                : isSelectedDate
                                    ? widget.white
                                    : widget.black),
                      ),
                    ),

                    ///if there is an event on the specific date, UI will show dot in accent color
                    event
                        ? Container(
                            height: 5.0,
                            width: 5.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelectedDate
                                    ? widget.white
                                    : widget.accent),
                          )
                        : SizedBox(height: 5.0),
                  ],
                ),
              ),
      ),
    );
  }

  ///definition of month widget

  Widget month(List<MyHomeworkModel> dates, MyHomeworkModel model, double width,
      String? locale) {
    ///definition of first and initializing it on the first date int the month
    //String first = dates.first;
    /*while (DateFormat("E").format(dates.first) != "Mon") {
      ///add "empty fields" to the list to get offset of the days
      dates.add(dates.first.subtract(Duration(days: 1)));

      ///sort all the dates
      dates.sort();
    }*/

    ///logically show all the dates in the month
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///name of the month
          Text(
            'My Homework Status',
            //DateFormat.MMMM(Locale(locale!).toString()).format(first),
            style: TextStyle(
                fontSize: 18.0,
                color: widget.black,
                fontWeight: FontWeight.w400),
          ),
          /*Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: daysOfWeek(width, widget.locale),
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              ///calculate the number of rows with dates based on number of days in the month
              height: MediaQuery.of(context).size.height *
                  0.7 /*dates.length > 28
                  ? dates.length > 35
                  ? 6 * width / 7
                  : 5 * width / 7
                  : 4 * width / 7*/
              ,
              width: MediaQuery.of(context).size.width - 2 * widget.padding!,

              ///show all days in the month
              child: GridView.builder(
                itemCount: dates.length,

                ///Since each calendar is drawn separatly it shouldn't be scrollable
                //physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  ///create date for each day in the month
                  // debugPrint(dates[index]);
                  //String day = dates[index];

                  ///check if it is empty field
                  bool outOfRange =
                      false; //date.isBefore(startDate) || date.isAfter(endDate);

                  ///if it is empty field return empty container
                  return dateInCalendar(
                    dates[index],
                    outOfRange,
                    width,
                    dates[index].CName.contains('55') ? false : true,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

///end of code
