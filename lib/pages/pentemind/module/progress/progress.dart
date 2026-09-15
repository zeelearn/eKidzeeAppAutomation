import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/pages/pentemind/module/progress/parent_tracker.dart';
import 'package:ekidzee/pages/pentemind/module/progress/reports.dart';
import 'package:flutter/material.dart';

import '../../../../iface/onClick.dart';

class PentemindProgress extends StatefulWidget {
  onClickListener listener;
  String? term;

  PentemindProgress({super.key, required this.listener,required this.term});

  @override
  _PentemindProgressState createState() => _PentemindProgressState();
}

class _PentemindProgressState extends State<PentemindProgress>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Colors.white;
  final _indicatorColor = kPrimaryLightColor;
  final _unselectedColor = Colors.grey;
  dynamic _tabs = [
    const Tab(text: 'Tracker'),
    const Tab(text: 'My Progress'),
  ];

  @override
  void initState() {
    if(widget.term == LocalConstant.TERM_EARLY){
      _tabs = [
        const Tab(text: 'My Progress'),
      ];
    }
    _tabController = TabController(length: _tabs.length, vsync: this);
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
        children: widget.term == LocalConstant.TERM_EARLY ?
        [
          const Center(
            child: MyProgressScreen(),
          ),
        ]
        :
        [
          Center(child: ParentTrackerScreen()),
          const Center(
            child: MyProgressScreen(),
          ),
        ],
      ),
    );
  }
}
