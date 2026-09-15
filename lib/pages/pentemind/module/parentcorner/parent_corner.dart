import 'package:ekidzee/constants.dart';
import 'package:flutter/material.dart';

import '../../../../iface/onClick.dart';
import 'artsy.dart';
import 'elg.dart';

class ParentCornersHome extends StatefulWidget {
  onClickListener listener;

  ParentCornersHome({super.key, required this.listener});

  @override
  _ParentCornersHomeState createState() => _ParentCornersHomeState();
}

class _ParentCornersHomeState extends State<ParentCornersHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Colors.white;
  final _indicatorColor = kPrimaryLightColor;
  final _unselectedColor = Colors.grey;
  final _tabs = [
    const Tab(text: 'ELG'),
    const Tab(text: 'Artsy'),
  ];

  @override
  void initState() {
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
        children: [
          Center(
            child: ElgScreen(),
          ),
          Center(
            child: ArtsyScreen(),
          ),
        ],
      ),
    );
  }
}
