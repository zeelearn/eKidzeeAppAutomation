import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/pages/k12/data/data_sources/logbook/logbook_remote_data_source.dart';
import 'package:ekidzee/pages/k12/data/models/logbook/timetable.dart';
import 'package:ekidzee/pages/k12/data/repository/logbook_repository_impl.dart';
import 'package:ekidzee/pages/k12/domain/usecases/logbook/logbook_usecase.dart';
import 'package:ekidzee/pages/k12/presentation/pages/folders/dropdownexample.dart';
import 'package:ekidzee/pages/k12/presentation/pages/logbook/logbook_list.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/pageddatatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';

class LogbookPage extends StatefulWidget {
  String userName;
  String classId;

  LogbookPage({super.key, required this.userName, required this.classId});

  @override
  _LogbookPageState createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  late final GetLogbook getLogbook;
  DateTime selectedDate = DateTime.now();
  List<LogbookTimeTableModel> timeTableList = [];
  final tableController =
      PagedDataTableController<String, LogbookTimeTableModel>();
  String currentDate = Utility.getSimpleDate();
  bool isLoading = true;
  final TextEditingController _dateController = TextEditingController();
  DateTime minDate = DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
  DateTime maxDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getLogbook = GetLogbook(LogbookRepository(LogbookRemoteDataSource()));
    fetchTimeTable();
  }

  Future<void> fetchTimeTable() async {
    timeTableList.clear();
    setState(() {
      isLoading = true;
    });
    final list = await getLogbook.getTimeTable(widget.userName, currentDate);
    // debugPrint(list);
    setState(() {
      timeTableList.addAll(list);
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchTimeTable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //MyWidget().getDateTimePicker(context, 'Select Date', _dateController, minDate, maxDate),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: defaultPadding, right: defaultPadding),
                    child: Center(
                        child: Text(
                      'Select Date',
                      style: LightColors.textHeaderStyle13,
                    )),
                  ),
                ),
                SizedBox(
                    height: 45,
                    width: 200,
                    child: TextField(
                        style: LightColors.textSmallStyle,
                        controller: _dateController,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: SizedBox(
                                height: 12.0,
                                width: 12.0,
                                child: IconButton(
                                  padding: const EdgeInsets.all(0.0),
                                  color: LightColors.kLightBlueMaterial,
                                  icon: const Icon(Icons.calendar_today,
                                      size: 12.0),
                                  onPressed: () {},
                                )),
                            //label: Text('Select Date'),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Select Date' //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: minDate,
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: const Color(0xFF8CE7F1),
                                    //accentColor: const Color(0xFF8CE7F1),
                                    colorScheme: ColorScheme.light(
                                        primary: kPrimaryLightColor),
                                    buttonTheme: ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary),
                                  ),
                                  child: child!,
                                );
                              },
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: maxDate);

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            _dateController.text = formattedDate;
                            currentDate = formattedDate;
                            fetchTimeTable();
                          }
                        })),
              ],
            ),
          ),
          isLoading
              ? Utility.showLoader()
              : timeTableList.isEmpty
                  ? Utility.emptyData(
                      context, 'TimeTable not avaliable at this time')
                  : Expanded(
                      child: MyDataTable(
                        headers: ['Periods', 'Classes', 'Subject'],
                        title: 'Zll Documents',
                        tableController: tableController,
                        items: timeTableList,
                        displayFunction: (index, item) {
                          switch (index) {
                            case 0:
                              return Text(
                                item.periodName,
                                style: LightColors.smallTextStyle,
                                textScaler: TextScaler.linear(
                                    ScaleSize.textScaleFactor(context)),
                              );
                            case 1:
                              return Text(
                                item.className,
                                style: LightColors.smallTextStyle,
                                textScaler: TextScaler.linear(
                                    ScaleSize.textScaleFactor(context)),
                              );
                            case 2:
                              return Text(
                                item.subjectName,
                                style: LightColors.smallTextStyle,
                                textScaler: TextScaler.linear(
                                    ScaleSize.textScaleFactor(context)),
                              );
                          }
                          return Text('');
                        },
                        onClick: (index, value) {
//                 debugPrint('onclick called....');
                          navigateLogbook(value);
                          //onFileTapped(context,value.url!);
                        },
                        fetch: (pageSize, sortModel, filterModel,
                            pageToken) async {
                          return timeTableList;
                        },
                        getColoumSize: (index) {
                          if (index == 0)
                            return const FixedColumnSize(100);
                          else
                            return RemainingColumnSize();
                        },
                      ),
                    )
        ],
      ),
    );
  }

  navigateLogbook(LogbookTimeTableModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KESLogbookPage(
              userName: widget.userName,
              classId: model.classId,
              date: currentDate,
              timeTableModel: model)),
    ).then((value) {
      if (value != null && value is String) {
        //updateAttandanceForDay(value);
      }
    });
  }
}
