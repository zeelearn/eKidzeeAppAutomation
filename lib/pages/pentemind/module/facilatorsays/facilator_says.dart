import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:flutter/material.dart';

import '../../../../iface/onClick.dart';
import 'guidelinescreen.dart';
import 'lessonplanscreen.dart';
import 'logbook/logbook.dart';

class FacilatorSaysHome extends StatefulWidget {
  onClickListener listener;
  bool? deepLinkingEnabled;
  bool? isKes;
  String? programId;
  String? culminationDay;
  String? refId;
  int? hiveIndex;
  String? term;

  FacilatorSaysHome(
      {super.key,
      required this.listener,
      this.deepLinkingEnabled,
      required this.isKes,
      this.programId,
      required this.term,
      this.culminationDay,
      this.refId,
      this.hiveIndex});

  @override
  _FacilatorSaysHomeState createState() => _FacilatorSaysHomeState();
}

class _FacilatorSaysHomeState extends State<FacilatorSaysHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Colors.white;
  final _indicatorColor = kPrimaryLightColor;
  final _unselectedColor = Colors.grey;
  dynamic _tabs = [];

  @override
  void initState() {
    if (widget.isKes!) {
      _tabs = [
        const Tab(text: 'Logbook'),
      ];
    } else if (widget.term == LocalConstant.TERM_EARLY) {
      _tabs = [
        const Tab(text: 'Lesson Plan'),
      ];
    } else {
      _tabs = [
        const Tab(text: 'Logbook'),
        const Tab(text: 'Guideline'),
        const Tab(text: 'Lesson Plan'),
      ];
    }
    _tabController = TabController(length: 3, vsync: this);
    //debugPrint('in logbook isKES ${widget.isKes}');
    // _tabs = [
    //   if(!widget.isKes!) const Tab(text: 'Logbook'),
    //   const Tab(text: 'Guideline'),
    //   const Tab(text: 'Lesson Plan'),
    // ];
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
      appBar: AppBar(
        toolbarHeight: 50,
        leadingWidth: 0,
        backgroundColor: _selectedColor,
        title: TabBar(
          controller: _tabController,
          tabs: _tabs,
          // isScrollable: true,
          // tabAlignment: TabAlignment.fill,
          dividerColor: Colors.blueGrey,
          labelColor: _indicatorColor,
          indicatorColor: _indicatorColor,
          unselectedLabelColor: _unselectedColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.isKes!
            ? [
                Center(
                  child: LogbookScreen(
                    cName: '',
                    day: 1,
                    isToolbar: false,
                    deepLinkingEnabled: widget.deepLinkingEnabled,
                    culminationDay: widget.culminationDay,
                    programId: widget.programId,
                    refId: widget.refId,
                    hiveIndex: widget.hiveIndex,
                  ),
                ),
              ]
            : widget.term == LocalConstant.TERM_EARLY
                ? [
                    Center(
                      child: LessonPlanScreen(),
                    )
                  ]
                : [
                    Center(
                      child: LogbookScreen(
                        cName: '',
                        day: 1,
                        isToolbar: false,
                        deepLinkingEnabled: widget.deepLinkingEnabled,
                        culminationDay: widget.culminationDay,
                        programId: widget.programId,
                        refId: widget.refId,
                        hiveIndex: widget.hiveIndex,
                      ),
                    ),
                    Center(
                      child: GuideLineScreen(),
                    ),
                    Center(
                      child: LessonPlanScreen(),
                    )
                  ],
      ),
    );
  }
}
