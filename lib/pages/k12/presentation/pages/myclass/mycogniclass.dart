import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/classmastermodel.dart';
import 'package:ekidzee/pages/k12/data/models/myclass/get_calendar.dart';
import 'package:ekidzee/pages/k12/presentation/pages/myclass/studentlist.dart';
import 'package:ekidzee/pages/k12/presentation/providers/myclass_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../pentemind/module/myclass/almanac_menu.dart';

class MyCogniClassPage extends StatefulWidget {
  final int sectinId;
  final onClickListener listener;
  final int classId;
  final String userUID;
  final String userName;

  const MyCogniClassPage(
      {super.key,
      required this.sectinId,
      required this.listener,
      required this.classId,
      required this.userUID,
      required this.userName});

  @override
  _MyCogniClassPageState createState() => _MyCogniClassPageState();
}

class _MyCogniClassPageState extends State<MyCogniClassPage>
    with SingleTickerProviderStateMixin
    implements onClickListener {
  bool isFloatingDay = false;
  bool isloading = false;
  String? error;

  TermMonthList? mSelectedTerm;
  AttandanceDaysResponse? response;
  Month? mSelectedMonth;
  List<FloatingDayRemarks> mFloatingDayRemarks = [];
  late TabController _tabController;
  ClassMasterModel? classMasterModel;

  final List<AttandanceDays> _attandanceCalendar = [];
  final List<FloatingDay> _floatingDay = [];
  Future<ClassMasterModel>? _terms;

  final Color _primaryColor = const Color(0xFF65318E); // Enterprise Purple
  final Color _backgroundColor = const Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    loadDefaultData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {}); // Rebuild when tab changes
      }
    });
  }

  Future<void> loadDefaultData() async {
    try {
      error = null;
      setState(() => isloading = true);
      _terms = MyClassProvider.terms();
      classMasterModel = await _terms;

      if (classMasterModel?.data != null &&
          classMasterModel!.data!.isNotEmpty) {
        var firstData = classMasterModel!.data![0];

        if (firstData.floatingDayRemarks?.isNotEmpty ?? false) {
          mFloatingDayRemarks = List.from(firstData.floatingDayRemarks!);
        }

        if (firstData.termMonthList != null) {
          DateTime now = DateTime.now();
          for (var term in firstData.termMonthList!) {
            if (term.month != null) {
              var currentMonthMatch = term.month!
                  .where((m) => m.month == now.month && m.year == now.year);
              if (currentMonthMatch.isNotEmpty) {
                mSelectedTerm = term;
                mSelectedMonth = currentMonthMatch.first;
                break;
              }
            }
          }
          if (mSelectedTerm != null && mSelectedMonth != null) {
            await loadAttantendanceCalendar();
          }
        }
      }
    } catch (e) {
      error = 'Something went wrong.';
      debugPrint('Error: $e');
    } finally {
      if (mounted) setState(() => isloading = false);
    }
  }

  int? getCurrentTermId({required ClassMasterModel classMasterModel}) {
    DateTime now = DateTime.now();
    for (var term in classMasterModel.data![0].termMonthList!) {
      if (term.month?.any((m) => m.month == now.month && m.year == now.year) ??
          false) {
        return term.termId;
      }
    }
    return null;
  }

  bool get isAttendanceTab => _tabController.index == 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: TabBar(
          controller: _tabController,
          labelColor: _primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: _primaryColor,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: 'Attendance'),
            Tab(text: 'Almanac'),
          ],
        ),
      ),
      floatingActionButton: Responsive.isMobile(context) &&
              mSelectedMonth != null &&
              isAttendanceTab
          ? FloatingActionButton.extended(
              onPressed: () => goToAddFloatingDay(context),
              backgroundColor: _primaryColor,
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Floating Day',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAttendanceView(),
          AlmanacMenu(listener: widget.listener),
        ],
      ),
    );
  }

  Widget _buildAttendanceView() {
    if (isloading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Utility.filter(context, error!));

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(child: _folderBreadcrumb()),
              if (!Responsive.isMobile(context) && mSelectedMonth != null)
                ElevatedButton.icon(
                  onPressed: () => goToAddFloatingDay(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Floating Day'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: mSelectedTerm == null
              ? _buildTermGrid()
              : mSelectedMonth == null
                  ? _buildMonthGrid()
                  : _buildDayGrid(),
        ),
      ],
    );
  }

  Widget _buildTermGrid() {
    var terms = classMasterModel?.data?[0].termMonthList ?? [];
    if (terms.isEmpty) return Utility.filter(context, 'No terms available.');

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = 5;
      double aspectRatio = 1.3;

      if (constraints.maxWidth < 600) {
        crossAxisCount = 1;
        aspectRatio = 2.0;
      } else if (constraints.maxWidth < 900) {
        crossAxisCount = 2;
        aspectRatio = 1.4;
      } else if (constraints.maxWidth < 1200) {
        crossAxisCount = 3;
        aspectRatio = 1.4;
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: terms.length,
        itemBuilder: (context, index) {
          var term = terms[index];
          bool isCurrent = _isCurrentTerm(term);
          return _buildEnterpriseCard(
            onTap: () {
              setState(() {
                mSelectedTerm = term;
                updateMonths();
              });
            },
            isCurrent: isCurrent,
            title: term.termName ?? 'Term ${index + 1}',
            subtitle: '${term.attendanceDay ?? 0} / ${term.totalDay ?? 0} Days',
            icon: _getTermIcon(term.termName ?? ''),
            stats: [
              _StatItem('Teaching', term.aDay?.toString() ?? '0', Colors.blue),
              _StatItem(
                  'Floating', term.fDay?.toString() ?? '0', Colors.orange),
            ],
            progress: _calculateProgress(term.attendanceDay, term.totalDay),
          );
        },
      );
    });
  }

  Widget _buildMonthGrid() {
    var months = mSelectedTerm?.month ?? [];
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = 6;
      double aspectRatio = 1.1;

      if (constraints.maxWidth < 600) {
        crossAxisCount = 2;
        aspectRatio = 1.0;
      } else if (constraints.maxWidth < 900) {
        crossAxisCount = 3;
        aspectRatio = 1.1;
      } else if (constraints.maxWidth < 1200) {
        crossAxisCount = 4;
        aspectRatio = 1.1;
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: months.length,
        itemBuilder: (context, index) {
          var month = months[index];
          bool isCurrent = _isCurrentMonth(month);
          return _buildEnterpriseCard(
            onTap: () async {
              setState(() => mSelectedMonth = month);
              await loadAttantendanceCalendar();
            },
            isCurrent: isCurrent,
            title: month.monthName ?? '',
            subtitle: '${month.attendanceDay ?? 0}/${month.totalDay ?? 0}',
            icon: _getMonthIcon(month.monthName ?? ''),
            stats: [
              _StatItem('Teach', month.tDay?.toString() ?? '0', Colors.green),
              _StatItem('Float', month.fDay?.toString() ?? '0', Colors.orange),
              _StatItem('Holiday', month.otherHolidayTotal?.toString() ?? '0',
                  Colors.red),
            ],
            progress: _calculateProgress(month.attendanceDay, month.totalDay),
            compact: true,
          );
        },
      );
    });
  }

  Widget _buildDayGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = 8;
      double aspectRatio = 0.9;

      if (constraints.maxWidth < 600) {
        crossAxisCount = 3;
        aspectRatio = 0.85;
      } else if (constraints.maxWidth < 900) {
        crossAxisCount = 4;
        aspectRatio = 0.9;
      } else if (constraints.maxWidth < 1200) {
        crossAxisCount = 6;
        aspectRatio = 0.9;
      }

      return GridView.builder(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 80),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _attandanceCalendar.length,
        itemBuilder: (context, index) {
          var day = _attandanceCalendar[index];
          bool isFilled = day.isAttendanceFilled == 1;
          bool isFloat = isFloatingDayMarked(day.date ?? '');
          String remark =
              isFloat ? (getFloatingDayName(day.date ?? '').remarks ?? '') : '';

          bool isFutureDate = false;
          if (day.date != null && day.date!.isNotEmpty) {
            try {
              DateTime itemDate = DateFormat('yyyy-MM-dd').parse(day.date!);
              DateTime now = DateTime.now();
              DateTime today = DateTime(now.year, now.month, now.day);
              if (itemDate.isAfter(today)) {
                isFutureDate = true;
              }
            } catch (_) {}
          }

          return InkWell(
            onTap: isFutureDate ? null : () => _handleDayTap(day),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isFutureDate ? Colors.grey.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isFutureDate
                      ? Colors.grey.shade200
                      : (isFilled ? _primaryColor : Colors.grey.shade300),
                  width: isFilled && !isFutureDate ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.weekday ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: isFutureDate
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDayDateFull(day.date),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isFutureDate
                            ? Colors.grey.shade400
                            : (isFilled ? _primaryColor : Colors.black87)),
                  ),
                  if (isFloat) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.swap_horiz,
                            size: 12,
                            color: isFutureDate
                                ? Colors.grey.shade400
                                : _primaryColor),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            remark,
                            style: TextStyle(
                                fontSize: 12,
                                color: isFutureDate
                                    ? Colors.grey.shade400
                                    : _primaryColor,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (isFilled && day.totalPresent != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isFutureDate
                            ? Colors.grey.shade200
                            : _primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${day.totalPresent}/${response?.data?[0].totalStudents ?? ''}',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isFutureDate
                                ? Colors.grey.shade400
                                : _primaryColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildEnterpriseCard({
    required VoidCallback onTap,
    required bool isCurrent,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<_StatItem> stats,
    required double progress,
    bool compact = false,
  }) {
    return Card(
      elevation: isCurrent ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: isCurrent ? _primaryColor : Colors.transparent, width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(compact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon,
                      color: isCurrent ? _primaryColor : Colors.grey,
                      size: compact ? 24 : 32),
                  if (isCurrent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: _primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Text('Current',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const Spacer(),
              Text(title,
                  style: TextStyle(
                      fontSize: compact ? 20 : 24,
                      fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 8),
              if (!compact) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: stats.map((s) => _buildMiniStat(s)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(_StatItem stat) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 6,
            height: 6,
            decoration:
                BoxDecoration(color: stat.color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text('${stat.label}: ${stat.value}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _folderBreadcrumb() {
    List<Widget> crumbs = [];

    // Terms Root
    crumbs.add(_buildCrumb('Terms', mSelectedTerm == null, () {
      setState(() {
        mSelectedTerm = null;
        mSelectedMonth = null;
        _attandanceCalendar.clear();
      });
    }));

    if (mSelectedTerm != null) {
      crumbs.add(const Icon(Icons.chevron_right, size: 18, color: Colors.grey));
      crumbs.add(
          _buildCrumb(mSelectedTerm!.termName!, mSelectedMonth == null, () {
        setState(() {
          mSelectedMonth = null;
          _attandanceCalendar.clear();
        });
      }));
    }

    if (mSelectedMonth != null) {
      crumbs.add(const Icon(Icons.chevron_right, size: 18, color: Colors.grey));
      crumbs.add(_buildCrumb(mSelectedMonth!.monthName!, true, () {}));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: crumbs),
    );
  }

  Widget _buildCrumb(String label, bool isLast, VoidCallback onTap) {
    return ActionChip(
      onPressed: onTap,
      label: Text(label),
      backgroundColor:
          isLast ? _primaryColor.withValues(alpha: 0.1) : Colors.transparent,
      side: BorderSide(color: isLast ? _primaryColor : Colors.grey.shade300),
      labelStyle: TextStyle(
        color: isLast ? _primaryColor : Colors.grey.shade700,
        fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // Helper Methods
  bool _isCurrentTerm(TermMonthList term) {
    DateTime now = DateTime.now();
    return term.month?.any((m) => m.month == now.month && m.year == now.year) ??
        false;
  }

  bool _isCurrentMonth(Month month) {
    DateTime now = DateTime.now();
    return month.month == now.month && month.year == now.year;
  }

  double _calculateProgress(int? current, int? total) {
    if (total == null || total == 0) return 0.0;
    return (current ?? 0) / total;
  }

  String _formatDayDateFull(String? dateStr) {
    if (dateStr == null) return '';
    try {
      var date = DateFormat('yyyy-MM-dd').parse(dateStr);
      return DateFormat('dd MMM').format(date);
    } catch (_) {
      return '';
    }
  }

  IconData _getTermIcon(String name) {
    if (name.contains('1')) return Icons.looks_one;
    if (name.contains('2')) return Icons.looks_two;
    if (name.contains('3')) return Icons.looks_3;
    return Icons.school;
  }

  IconData _getMonthIcon(String month) {
    switch (month.toLowerCase()) {
      case 'jan':
      case 'january':
        return Icons.ac_unit;
      case 'feb':
      case 'february':
        return Icons.favorite;
      case 'mar':
      case 'march':
        return Icons.local_florist;
      case 'apr':
      case 'april':
        return Icons.eco;
      case 'may':
        return Icons.wb_sunny;
      case 'jun':
      case 'june':
        return Icons.beach_access;
      case 'jul':
      case 'july':
        return Icons.wb_cloudy;
      case 'aug':
      case 'august':
        return Icons.terrain;
      case 'sep':
      case 'september':
        return Icons.school;
      case 'oct':
      case 'october':
        return Icons.park;
      case 'nov':
      case 'november':
        return Icons.cloud;
      case 'dec':
      case 'december':
        return Icons.star;
      default:
        return Icons.calendar_month;
    }
  }

  void updateMonths() {
    setState(() {});
  }

  Future<void> loadAttantendanceCalendar() async {
    int academicYear = await KidzeePref().getAcademicYear();
    setState(() => isloading = true);
    response = await MyClassProvider.attandanceCalender(widget.sectinId,
        mSelectedMonth!.month!, mSelectedMonth?.year ?? (2000 + academicYear));

    _attandanceCalendar.clear();
    _floatingDay.clear();
    if (response?.data?.isNotEmpty ?? false) {
      _attandanceCalendar.addAll(response!.data![0].attandanceData ?? []);
      _floatingDay.addAll(response!.data![0].floatingDay ?? []);
    }
    if (mounted) setState(() => isloading = false);
  }

  void _handleDayTap(AttandanceDays day) {
    if (day.date == null || day.date!.isEmpty) return;
    if (isFloatingDayMarked(day.date ?? '')) {
      openFloatingDay(day.date);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CogniMyClassStudentListPage(
            sectionId: widget.sectinId,
            userName: widget.userName,
            userid: widget.userUID,
            date: day.date!,
            termId: mSelectedTerm!.termId!,
            remarkList: [],
            remark: '',
            title: 'Attendance',
            isFloatingDay: false,
            mClickListener: this,
          ),
        ),
      ).then((value) {
        if (value != null && value is String) {
          updateAttandanceForDay(value);
        }
      });
    }
  }

  FloatingDay getFloatingDayName(String date) {
    return _floatingDay.firstWhere((d) => d.date == date,
        orElse: () => FloatingDay());
  }

  void openFloatingDay(dynamic targetDate) {
    FloatingDay? matchedDay = _floatingDay.firstWhere(
        (day) => day.date == targetDate,
        orElse: () => FloatingDay());
    if (matchedDay.date != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CogniMyClassStudentListPage(
            sectionId: widget.sectinId,
            userName: widget.userName,
            userid: widget.userUID,
            remark: matchedDay.remarks!,
            date: matchedDay.date!,
            termId: mSelectedTerm!.termId!,
            remarkList: [],
            monthId: mSelectedMonth!.month!,
            title: 'Floating Day - ${matchedDay.remarks!}',
            isFloatingDay: false,
            mClickListener: this,
          ),
        ),
      ).then((value) {
        if (value != null && value is String) updateAttandanceForDay(value);
      });
    }
  }

  void goToAddFloatingDay(BuildContext context) {
    isFloatingDay = true;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CogniMyClassStudentListPage(
            sectionId: widget.sectinId,
            userName: widget.userName,
            monthId: mSelectedMonth!.month!,
            userid: widget.userUID,
            date: _attandanceCalendar.isNotEmpty
                ? _attandanceCalendar[0].date!
                : '',
            remark: '',
            title: 'Floating Days',
            termId: getCurrentTermId(classMasterModel: classMasterModel!) ?? 0,
            remarkList: mFloatingDayRemarks,
            isFloatingDay: true,
            mClickListener: this,
          ),
        )).then((value) => isFloatingDay = false);
  }

  bool isFloatingDayMarked(String date) =>
      _floatingDay.any((d) => d.date == date);

  void updateAttandanceForDay(String date,
      {int? presentCount, bool? isFloatingDay}) {
    for (var attendance in _attandanceCalendar) {
      if (date == attendance.date) {
        if (presentCount != null) {
          attendance.totalPresent = presentCount;
          if (attendance.isAttendanceFilled == 1) {
            mSelectedMonth?.tDay = (mSelectedMonth?.tDay ?? 0) > 0
                ? (mSelectedMonth!.tDay! - 1)
                : 0;
            mSelectedTerm?.aDay =
                (mSelectedTerm?.aDay ?? 0) > 0 ? (mSelectedTerm!.aDay! - 1) : 0;
          } else {
            mSelectedMonth?.attendanceDay =
                (mSelectedMonth?.attendanceDay ?? 0) + 1;

            mSelectedTerm?.attendanceDay =
                (mSelectedTerm?.attendanceDay ?? 0) + 1;
          }
        }
        attendance.isAttendanceFilled = 1;
      }
    }
    if (presentCount != null) {
      if (!(isFloatingDay ?? false)) {
        mSelectedMonth?.tDay = (mSelectedMonth?.tDay ?? 0) + 1;
        mSelectedTerm?.aDay = (mSelectedTerm?.aDay ?? 0) + 1;
      }
    }
    setState(() {});
  }

  @override
  void onClick(int action, value) {
    if (action == LocalConstant.ACTION_RESPONSE && value is (String, int)) {
      if (isFloatingDay) {
        List<String> parts = value.$1.split(',');
        String date = parts[0];
        updateAttandanceForDay(date,
            presentCount: value.$2, isFloatingDay: true);
        if (mSelectedMonth?.month ==
            DateFormat('yyyy-MM-dd').parse(date).month) {
          _floatingDay.add(FloatingDay(date: date, remarks: parts[1]));
        }
        mSelectedMonth?.fDay = (mSelectedMonth?.fDay ?? 0) + 1;
        mSelectedTerm?.fDay = (mSelectedTerm?.fDay ?? 0) + 1;
      } else {
        updateAttandanceForDay(value.$1, presentCount: value.$2);
      }
      setState(() {});
    }
  }
}

class _StatItem {
  final String label;
  final String value;
  final Color color;
  _StatItem(this.label, this.value, this.color);
}
