import 'package:ekidzee/pages/pentemind/module/dailyactivity/worksheet.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../iface/onClick.dart';
import 'homework.dart';
import 'mid_termworksheet.dart';

class DailyActiviyHome extends StatefulWidget {
  onClickListener listener;
  String programName;
  String userType;
  bool? deepLinkingEnabled;
  String? programId;
  String? day;
  String? pageType;
  DailyActiviyHome(
      {super.key,
      required this.userType,
      required this.programName,
      required this.listener,
      this.deepLinkingEnabled,
      this.programId,
      this.day,
      this.pageType});

  @override
  _DailyActiviyHomeState createState() => _DailyActiviyHomeState();
}

class _DailyActiviyHomeState extends State<DailyActiviyHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Colors.white;
  final _indicatorColor = kPrimaryLightColor;
  final _unselectedColor = Colors.grey;
  final _tabs = [
    const Tab(text: 'Worksheet'),
    const Tab(text: 'Homework'),
  ];

  @override
  void initState() {
    if ((widget.userType == 'TEACH' ||
        widget.userType == 'SRTEA' ||
        widget.userType == 'CC' ||
        widget.userType == 'CM' ||
        widget.userType == 'F')) {
      if (widget.programName.toLowerCase().contains('mid')) {
        _tabs.add(const Tab(text: 'MIDterm Worksheets'));
      }
    }
    _tabController = TabController(length: _tabs.length, vsync: this);
    if (widget.deepLinkingEnabled != null && widget.pageType == 'dahomework') {
      _tabController.index = 1;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        leadingWidth: 0,
        backgroundColor: _selectedColor,
        title: TabBar(
          controller: _tabController,
          tabs: _tabs,
          isScrollable: false,
          // tabAlignment: TabAlignment.center,
          dividerColor: Colors.blueGrey,
          labelColor: _indicatorColor,
          indicatorColor: _indicatorColor,
          unselectedLabelColor: _unselectedColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: WorksheetScreen(
              deepLinkingEnabled: widget.deepLinkingEnabled,
              programID: widget.programId,
              day: widget.day,
            ),
          ),
          Center(
            child: HomeworkScreen(
              deepLinkingEnabled: widget.deepLinkingEnabled,
              programID: widget.programId,
              day: widget.day,
              isToolbar: false,
            ),
          ),
          Center(
            child: MidTermWorksheetScreen(),
          )
        ],
      ),
    );
  }
}
