import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:flutter/material.dart';

import '../../../../iface/onClick.dart';
import '../myclass/announancement.dart';
import '../myclass/leave_record.dart';
import '../myclass/parent_note.dart';
import 'notification.dart';

class ParentAlmanac extends StatefulWidget {
  onClickListener listener;
  String? term;

  ParentAlmanac({super.key, required this.listener,required this.term});

  @override
  _ParentAlmanacState createState() => _ParentAlmanacState();
}

class _ParentAlmanacState extends State<ParentAlmanac>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Colors.white;
  final _indicatorColor = kPrimaryLightColor;
  final _unselectedColor = Colors.grey;
  dynamic _tabs = [
    const Tab(
      text: 'Notification',
    ),
    const Tab(text: 'Announcement'),
    const Tab(text: 'Parent Note Resource'),
    const Tab(text: 'Leave Record'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    if(widget.term == LocalConstant.TERM_EARLY){
      _tabs = [
        const Tab(
          text: 'Notification',
        ),
        const Tab(text: 'Announcement'),
        //const Tab(text: 'Parent Note Resource'),
        const Tab(text: 'Leave Record'),
      ];
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
        toolbarHeight: 50,
        leadingWidth: 0,
        backgroundColor: _selectedColor,
        title: TabBar(
          isScrollable: true,
          // tabAlignment: TabAlignment.fill,
          controller: _tabController,
          tabs: _tabs,
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
          Center(
            child: AlmanacNotification(),
          ),
          Center(child: AnnoucementListScreen()),
          // Center(
          //   child: ParentNoteScreen(
          //     isToolbar: false,
          //   ),
          // ),
          Center(
            child: LeaveRecordScreen(
              isAppbar: false,
            ),
          )
        ]
        :
        [
          Center(
            child: AlmanacNotification(),
          ),
          Center(child: AnnoucementListScreen()),
          Center(
            child: ParentNoteScreen(
              isToolbar: false,
            ),
          ),
          Center(
            child: LeaveRecordScreen(
              isAppbar: false,
            ),
          )
        ],
      ),
    );
  }
}
