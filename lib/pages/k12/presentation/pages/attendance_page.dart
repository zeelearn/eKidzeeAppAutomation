import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/k12/presentation/pages/student_list_page.dart';
import 'package:ekidzee/pages/k12/presentation/providers/attendance_provider.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/dropdown_widget.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> implements onClickListener {
  String selectedTerm = 'Term 1';
  String selectedMonth = 'January';
  final int ACTION_TERMS = 10001;

List<String> terms=[];
  initTerms(List<String> data){
    terms.clear();
    terms.add('Select Term 1');
    if(data.length>=0)
      terms.addAll(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder(
        future: AttendanceProvider.getTerms(),
        builder: (context, termsSnapshot) {
          if (!termsSnapshot.hasData) return CircularProgressIndicator();
          initTerms(termsSnapshot.data!);
          return Column(
            children: [
              Padding(padding: EdgeInsets.only(left: 25,right: 25),
              child: Row(
             
                 
                children: [
                  DropdownWidget(
                    items: termsSnapshot.data as List<String>,
                    selectedValue: selectedTerm,
                    onChanged: (newValue) {
                      setState(() {
                        selectedTerm = newValue!;
                      });
                    },
                  ),
                  FutureBuilder(
                    future: AttendanceProvider.getMonths(),
                    builder: (context, monthsSnapshot) {
                      if (!monthsSnapshot.hasData) return CircularProgressIndicator();
              
                      return DropdownWidget(
                        items: monthsSnapshot.data as List<String>,
                        selectedValue: selectedMonth,
                        onChanged: (newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                          });
                        },
                      );
                    },
                  ),
            
                ],
              ),),
              FutureBuilder(
                future: AttendanceProvider.getAttendanceDays(selectedTerm, selectedMonth),
                builder: (context, daysSnapshot) {
                  if (!daysSnapshot.hasData) return CircularProgressIndicator();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: (daysSnapshot.data as Map<String, bool>).keys.length,
                      itemBuilder: (context, index) {
                        final date = (daysSnapshot.data as Map<String, bool>).keys.elementAt(index);
                        final status = (daysSnapshot.data as Map<String, bool>)[date]!;

                        return ListTile(
                          title: Text(date),
                          trailing: Icon(status ? Icons.check : Icons.close),
                          onTap: () async {
                            final studentAttendance = await AttendanceProvider.getStudentAttendance(date);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentListPage(studentAttendance: studentAttendance),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
  
  @override
  void onClick(int action, value) {
    // TODO: implement onClick
  }
}
