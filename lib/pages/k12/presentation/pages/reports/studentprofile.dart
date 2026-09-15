import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/pages/k12/data/models/reports/student_profile_model.dart';
import 'package:ekidzee/pages/k12/domain/entities/reports/student_list_lgreport.dart';
import 'package:ekidzee/pages/k12/presentation/providers/report_provider.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentProfielLGRPage extends StatefulWidget {
  StudentForLGReport studentInfo;
  int sectionId;
  String reportName;
  String userName;

  StudentProfielLGRPage(
      {super.key,
      required this.studentInfo,
      required this.sectionId,
      required this.reportName,
      required this.userName});

  @override
  _StudentProfielLGRPageState createState() => _StudentProfielLGRPageState();
}

class _StudentProfielLGRPageState extends State<StudentProfielLGRPage> {
  final _formKey = GlobalKey<FormState>();
  // int _presentDays=0;
  // int _outOfDays=0;
  final TextEditingController _outOfDaysController = TextEditingController();
  final TextEditingController _presentDaysController = TextEditingController();

  final TextEditingController _learnerIs = TextEditingController();
  final TextEditingController _learnersStrengths = TextEditingController();
  final TextEditingController _learnersChallenges = TextEditingController();
  final TextEditingController _suggestion = TextEditingController();

  // Example dropdown values
  final List<String> _daysOptions = ['0'];

  loadStudentProfile() async {
    var profile = await ReportProvider.getStudentProfile(
        widget.studentInfo.studentId, widget.sectionId, widget.reportName);
    // debugPrint(profile);
    // _presentDays = _profile.totalDay;
    // _outOfDays = _profile.outOfDay;
    // _learnerIs = _profile.learnerIs;
    // _learnersChallenges = _profile.learnerChallenges;
    // _suggestion = _profile.suggestions;
    // _learnersStrengths = _profile.learnerStrengths;
    // debugPrint('Changes ${_presentDays}');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadStudentProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.studentInfo.studentName,
          style: LightColors.textHeaderStyleWhite,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryLightColor,
                elevation: 15,
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle form submission
                _insertStudentProfile();
                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form Submitted')));
              }
            },
            child: Text(
              'Submit',
              style: LightColors.textHeaderStyleWhite,
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: FutureBuilder<StudentProfileModel>(
          future: ReportProvider.getStudentProfile(widget.studentInfo.studentId,
              widget.sectionId, widget.reportName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for data
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if something went wrong
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              // Show a message if no data is returned
              return Center(child: Text('No Data found.'));
            } else {
              // Show the folder tree with the fetched data
              if (!snapshot.hasData) return CircularProgressIndicator();
//                 debugPrint('------totalDay-----${snapshot.data!.totalDay}');
//                 debugPrint('------outOfDay-----${snapshot.data!.outOfDay}');
              _presentDaysController.text = snapshot.data!.totalDay.toString();
              _outOfDaysController.text = snapshot.data!.outOfDay.toString();
              _learnerIs.text = snapshot.data!.learnerIs;
              _learnersChallenges.text = snapshot.data!.learnerChallenges;
              _suggestion.text = snapshot.data!.suggestions;
              _learnersStrengths.text = snapshot.data!.learnerStrengths;
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Days",
                        style: LightColors.textHeaderStyle13,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _presentDaysController,
                                decoration:
                                    InputDecoration(labelText: "Present Days"),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _outOfDaysController,
                                decoration:
                                    InputDecoration(labelText: "Out Of"),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "The Learner is",
                        style: LightColors.textHeaderStyle13,
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: _learnerIs,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(),
                          labelText: 'The Learner is',
                        ),
                        // onChanged: (value) {
                        //   setState(() {
                        //     _learnerIs.text = value;
                        //   });
                        // },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter The Learner is'
                            : null,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Learner’s Strengths are",
                        style: LightColors.textHeaderStyle13,
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: _learnersStrengths,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(),
                          labelText: 'Learner’s Strengths are:',
                        ),
                        // onChanged: (value) {
                        //   setState(() {
                        //     _learnersStrengths.text = value;
                        //   });
                        // },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Learner’s Strengths'
                            : null,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Learner’s Challenges are:*",
                        style: LightColors.textHeaderStyle13,
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: _learnersChallenges,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(),
                          labelText: 'Learner’s Challenges are:*',
                        ),
                        // onChanged: (value) {
                        //   setState(() {
                        //     _learnersChallenges.text = value;
                        //   });
                        // },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Learner’s Challenges'
                            : null,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Suggestion",
                        style: LightColors.textHeaderStyle13,
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: _suggestion,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(),
                          labelText: 'Suggestion',
                        ),
                        // onChanged: (value) {
                        //   setState(() {
                        //     _suggestion.text = value;
                        //   });
                        // },
                      ),
                      SizedBox(height: 16),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           backgroundColor: kPrimaryLightColor,
                      //           elevation: 15,
                      //           textStyle: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.bold)),
                      //       onPressed: () {
                      //         if (_formKey.currentState!.validate()) {
                      //           // Handle form submission
                      //           _insertStudentProfile();
                      //           //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form Submitted')));
                      //         }
                      //       },
                      //       child: Text('Submit',style: LightColors.textHeaderStyleWhite,),
                      //     ),
                      //     SizedBox(width: 16),
                      //     // ElevatedButton(
                      //     //   style: ElevatedButton.styleFrom(
                      //     //       backgroundColor: kPrimaryLightColor,
                      //     //       elevation: 15,
                      //     //       textStyle: TextStyle(
                      //     //       color: Colors.white,
                      //     //       fontSize: 14,
                      //     //       fontWeight: FontWeight.bold)),
                      //     //   onPressed: () {
                      //     //     // Handle form cancellation
                      //     //     _formKey.currentState!.reset();
                      //     //     setState(() {
                      //     //       _presentDays = 0;
                      //     //       _outOfDays = 0;
                      //     //       _learnerIs.text = '';
                      //     //       _learnersStrengths.text = '';
                      //     //       _learnersChallenges.text = '';
                      //     //       _suggestion.text = '';
                      //     //     });
                      //     //   },
                      //     //   child: Text('Reset',style: LightColors.textHeaderStyleWhite),
                      //     // ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  _insertStudentProfile() async {
    if (Utility.toInt(_presentDaysController.text.toString()) <= 0) {
      Utility.showMessage(context, 'Please Select Present Days');
    } else if (Utility.toInt(_outOfDaysController.text.toString()) <= 0) {
      Utility.showMessage(context, 'Please Select Out Of Days');
    } else {
      Utility.showLoaderDialog(context);
      var data = await ReportProvider.insertStudentProfile(
          userName: widget.userName,
          studentId: widget.studentInfo.studentId,
          sectionId: widget.sectionId,
          reportName: widget.reportName,
          totalDays: Utility.toInt(_presentDaysController.text.toString()),
          outOfDays: Utility.toInt(_outOfDaysController.text.toString()),
          learnerIs: _learnerIs.text,
          learnerStrengths: _learnersStrengths.text,
          learnerChallenges: _learnersChallenges.text,
          suggestions: _learnersChallenges.text,
          createdBy: 0);
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utility.showMessages(context, data.data!.msg);
    }
  }
}
