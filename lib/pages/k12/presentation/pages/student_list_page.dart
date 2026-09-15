import 'package:flutter/material.dart';

class StudentListPage extends StatelessWidget {
  final Map<String, bool> studentAttendance;

  StudentListPage({required this.studentAttendance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Attendance')),
      body: ListView(
        children: studentAttendance.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            trailing: Icon(entry.value ? Icons.check : Icons.close),
          );
        }).toList(),
      ),
    );
  }
}
