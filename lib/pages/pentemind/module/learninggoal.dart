import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/pages/pentemind/module/learninggoal/developmental/developmental.dart';
import 'package:flutter/material.dart';

import '../../../iface/onClick.dart';
import 'learninggoal/Academic/AcademicScreen.dart';
import 'learninggoal/Additional/additional.dart';
import 'learninggoal/anecdotalhome.dart';

class PentemindLearningGoal extends StatefulWidget {
  onClickListener listener;
  String? day;
  String? observation;
  String? session;
  String? domain;
  String? skill;
  bool? deepLinkingEnabled;
  String? page;
  String? programId;
  String? term;
  PentemindLearningGoal(
      {super.key,
      required this.listener,
        required this.term,
      this.deepLinkingEnabled,
      this.day,
      this.observation,
      this.session,
      this.domain,
      this.skill,
      this.page,
      this.programId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PentemindLearningGoal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Colors.white;
  final _indicatorColor = kPrimaryLightColor;
  final _unselectedColor = Colors.grey;
  var _tabs = [
    const Tab(text: 'Developmental'),
    const Tab(text: 'Academic'),
    const Tab(text: 'Anecdotal'),
    const Tab(text: 'Additional Observation'),
  ];

  final _iconTabs = [
    const Tab(icon: Icon(Icons.home)),
    const Tab(icon: Icon(Icons.search)),
    const Tab(icon: Icon(Icons.settings)),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    if(widget.term == LocalConstant.TERM_EARLY){
      _tabs = [
        const Tab(text: 'Academic')
      ];
    }
    if (widget.deepLinkingEnabled != null && widget.page == 'add') {
      _tabController.index = 3;
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
      appBar: AppBar(
        leading: null,
        toolbarHeight: 50,
        leadingWidth: 0,
        backgroundColor: _selectedColor,
        title: TabBar(
          controller: _tabController,
          tabs: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.blueGrey,
          labelColor: _indicatorColor,
          indicatorColor: _indicatorColor,
          unselectedLabelColor: _unselectedColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.term == LocalConstant.TERM_EARLY  ?
        [
          Center(
            child: AcademicScreen(),
          ),
        ]
        :
        [
          Center(
            child: widget.deepLinkingEnabled != null && widget.page == 'dev'
                ? DevelopmentalScreen(
                    deepLinkingenabled: true,
                    listener: widget.listener,
                    cName: '',
                    day: widget.day != null ? int.parse(widget.day!) : 1,
                    isToolbar: false,
                    observation: widget.observation ?? '',
                    observationType: widget.session,
                    domain: widget.domain,
                    skill: widget.skill)
                : DevelopmentalScreen(
                    listener: widget.listener,
                    cName: widget.day != null ? 'fill_btn_click' : '',
                    day: int.parse(widget.day ?? '0'),
                    programId: widget.programId,
                    isToolbar: false,
                    observation: ''),
          ),
          Center(
            child: AcademicScreen(),
          ),
          Center(
            child: AnecdotalHomeScreen(
              listener: widget.listener,
            ),
          ),
          Center(
            child: widget.deepLinkingEnabled != null && widget.page == 'add'
                ? LGAdditionalScreen(
                    cName: '',
                    day: 1,
                    isToolbar: false,
                    observation: widget.observation!,
                    deepLinkingEnabled: true,
                    term: widget.session,
                  )
                : LGAdditionalScreen(
                    cName: '', day: 1, isToolbar: false, observation: ''),
          )
        ],
      ),
    );
  }
}
