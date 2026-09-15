import 'package:ekidzee/api/response/k12/notification/notification.dart'
    show StudentList;
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

class StudentSelectionSheet extends StatefulWidget {
  final List<StudentList> students;
  final List<StudentList> selectedstudents;

  const StudentSelectionSheet(
      {super.key, required this.students, required this.selectedstudents});

  @override
  _StudentSelectionSheetState createState() => _StudentSelectionSheetState();
}

class _StudentSelectionSheetState extends State<StudentSelectionSheet> {
  late List<StudentList> students;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    students = widget.students;
    // students.any((ogelement) => widget.selectedstudents.any((element) => element.studentId == ogelement.studentId,),)

    final selectedIds = widget.selectedstudents.map((e) => e.studentId).toSet();

    for (var student in students) {
      student.isPresent = selectedIds.contains(student.studentId);
    }
    isAllSelected = students.every((student) => student.isPresent);
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      isAllSelected = value ?? false;
      for (var student in students) {
        student.isPresent = isAllSelected;
      }
    });
  }

  void toggleStudentSelection(int index, bool? value) {
    setState(() {
      students[index].isPresent = value ?? false;
      isAllSelected = students.every((student) => student.isPresent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(
            context, students.where((student) => student.isPresent).toList());
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Select Students",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  //Checkbox(value: isAllSelected, onChanged: toggleSelectAll),
                ],
              ),
              const Divider(),
              Container(
                color: LightColors.kLightGray,
                padding: EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select All'),
                    Checkbox(value: isAllSelected, onChanged: toggleSelectAll),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(students[index].studentName ?? ''),
                      value: students[index].isPresent,
                      onChanged: (value) =>
                          toggleStudentSelection(index, value),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context,
                      students.where((student) => student.isPresent).toList());
                },
                child: const Text(
                  "Select Student",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
