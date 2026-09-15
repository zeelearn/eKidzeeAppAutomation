import 'package:ekidzee/pages/k12/data/models/myclass/get_calendar.dart';
import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final AttandanceDays data;
  final String? floatingDayName;
  final int? totalStudent;

  const AttendanceCard(
      {super.key, required this.data, this.floatingDayName, this.totalStudent});

  double get percent =>
      totalStudent == 0 ? 0 : (data.totalPresent ?? 0) / (totalStudent ?? 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${data.totalPresent ?? ''} / ${totalStudent ?? ''}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (floatingDayName?.isNotEmpty ?? false)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    floatingDayName ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                )
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "${data.weekday ?? ''} • ${data.date ?? ''}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          /// Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
            ),
          ),

          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(percent * 100).toStringAsFixed(0)}%",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}

/* class ResponsiveAttendanceView extends StatelessWidget {
  final List<AttendanceModel> attendanceList;

  const ResponsiveAttendanceView({
    super.key,
    required this.attendanceList,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// Breakpoints
        if (constraints.maxWidth < 600) {
          /// 📱 Mobile → ListView
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: attendanceList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return AttendanceCard(
                data: attendanceList[index],
              );
            },
          );
        } else {
          /// 💻 Tablet / Web → GridView
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: attendanceList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // adjust if needed
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (context, index) {
              return AttendanceCard(
                data: attendanceList[index],
              );
            },
          );
        }
      },
    );
  }
}

class MyClassAttendancePage extends StatelessWidget {
  MyClassAttendancePage({super.key});

  final List<AttendanceModel> sampleData = [
    AttendanceModel(
      day: "Monday",
      date: "12 Feb 2026",
      present: 28,
      total: 32,
      isFloating: true,
    ),
    AttendanceModel(
      day: "Tuesday",
      date: "13 Feb 2026",
      present: 30,
      total: 32,
      isFloating: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text("My Class Attendance"),
      ),
      body: ResponsiveAttendanceView(
        attendanceList: sampleData,
      ),
    );
  }
} */
