import 'package:ekidzee/constants.dart';
import 'package:ekidzee/globals.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/pages/k12/data/models/LG/student_rating_model.dart';
import 'package:ekidzee/pages/k12/domain/entities/learninggoal/observations.dart';
import 'package:ekidzee/pages/k12/domain/entities/learninggoal/student.dart';
import 'package:ekidzee/pages/k12/domain/entities/learninggoal/student_rating.dart';
import 'package:ekidzee/pages/k12/presentation/providers/learninggoal_provider.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KESLGStudentListPage extends StatefulWidget {
  final int sectionId;
  final String userName;
  final int userid;
  final KESLearningGoalObservations observations;

  const KESLGStudentListPage(
      {super.key,
      required this.observations,
      required this.sectionId,
      required this.userName,
      required this.userid});

  @override
  _KESLGStudentListPageState createState() => _KESLGStudentListPageState();
}

class _KESLGStudentListPageState extends State<KESLGStudentListPage> {
  late Future<List<Student>> _studentsFuture;

  final List<Student> _studentsList = [];

  final bool _checkAll = false;

  String _selectAllRating = '';

  @override
  void initState() {
    super.initState();
    loadStudentList();
  }

  void getObservationChanges() {
    widget.observations.bg = 0;
    widget.observations.pf = 0;
    widget.observations.pg = 0;
    widget.observations.na = 0;
    for (int index = 0; index < _studentsList.length; index++) {
      if (_studentsList[index].rating == 'BG') {
        widget.observations.bg++;
      } else if (_studentsList[index].rating == 'PG') {
        widget.observations.pg++;
      } else if (_studentsList[index].rating == 'PF') {
        widget.observations.pf++;
      } else if (_studentsList[index].rating == 'NA') {
        widget.observations.na++;
      }
    }
    _selectAllRating = '';
    if (_studentsList.length == widget.observations.bg) {
      _selectAllRating = 'BG';
    } else if (_studentsList.length == widget.observations.pg) {
      _selectAllRating = 'PG';
    } else if (_studentsList.length == widget.observations.pf) {
      _selectAllRating = 'PF';
    } else if (_studentsList.length == widget.observations.na) {
      _selectAllRating = 'NA';
    }
  }

  void onBack() {
    getObservationChanges();
    Navigator.of(context).pop(widget.observations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => onBack(),
        ),
        title: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: MyWidget().richText(widget.observations.competenciesName,
              LightColors.textSmallStyle.copyWith(color: Colors.white)),
          subtitle: MyWidget().richText(widget.observations.criteria,
              LightColors.textHeaderStyle13.copyWith(color: Colors.white)),
        ),
        actions: !kIsWeb
            ? null
            : [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: MaterialButton(
                    onPressed: () {
                      validateRating();
                    },
                    elevation: 5,
                    color: Colors.white,
                    child: MyWidget().richText(
                        'Submit',
                        LightColors.textHeaderStyleWhite
                            .copyWith(color: kPrimaryLightColor)),
                  ),
                )
              ],
      ),
      floatingActionButton: kIsWeb || _studentsList.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                validateRating();
              },
              label: Text(
                'Submit',
                style:
                    LightColors.textHeaderStyle13.copyWith(color: Colors.white),
              ),
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              backgroundColor: kPrimaryLightColor,
            ),
      bottomNavigationBar: footerKESLG(),
      body: SafeArea(
          child: _studentsList.isEmpty
              ? Utility.emptyData(context, 'Student list not avaliable')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      color: LightColors.kLightGrayM,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [],
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: _studentsList.length,
                        itemBuilder: (context, index) {
                          Student studentModel = _studentsList[index];
                          return GestureDetector(
                            onTap: () {
                              // Handle tap if needed
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          kPrimaryLightColor.withOpacity(0.5),
                                      width: 0.5)),
                              child: _childView(studentModel, index),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )),
    );
  }

  Future<void> loadStudentList() async {
    _studentsList.clear();
    // Utility.showLoaderDialog(context);
    var data = await LearninggoalProvider.studentList(
        widget.observations.ccId, widget.sectionId, widget.userName);
    //Utility.hideDialog(context);
    //debugPrint('response received....');
    //debugPrint(data);
    _studentsList.addAll(data);
    setState(() {});
  }

  Future<void> validateRating() async {
    Utility.showLoaderDialog(context);
    StudentRating rating = StudentRating(
        teacherId: widget.userid,
        sectionId: widget.sectionId,
        userName: widget.userName,
        inputData: []);
    bool isAny = true;
    for (int index = 0; index < _studentsList.length; index++) {
      if (_studentsList[index].rating.isNotEmpty) {
        rating.inputData.add(RatingData(
            ccId: widget.observations.ccId,
            studentId: _studentsList[index].studentId,
            rating: _studentsList[index].rating));
      } else {
        isAny = false;
        break;
      }
    }
    if (!isAny) {
      Utility.showMessage(context, 'Please select Competencies');
    } else {
      final response = await LearninggoalProvider.saveStudentRating(rating);
      if (response['success'] == 200) {
        Utility.showMessage(context, response['data']['Msg']);
      } else {
        Utility.showMessage(context, 'Error received');
      }
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }

  void updateCheckAll(String rating) {
    for (int index = 0; index < _studentsList.length; index++) {
      _studentsList[index].rating = rating;
    }

    setState(() {});
  }

  Widget _childView(Student model, int index) {
    if (index == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: LightColors.kLightGray,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: MyWidget().richText(
                        'Student Name', LightColors.textHeaderStyle13),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          child: MyWidget().richText(
                              'Rating', LightColors.textHeaderStyle13),
                        ),
                      ),
                      _buildSelectAllRatingFilters()
                    ],
                  ),
                ),
              ],
            ),
          ),
          _childRow(model),
        ],
      );
    } else {
      return _childRow(model);
    }
  }

  Widget _childRow(Student model) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              child: MyWidget()
                  .richText(model.studentName, LightColors.textSmallStyle),
            ),
          ),
          Expanded(
            flex: 6,
            child: _buildRatingFilters(model),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingFilters(Student model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['BG', 'PG', 'PF', 'NA'].map((rating) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: model.rating.contains(rating),
              onChanged: (isChecked) {
                setState(() {
                  model.rating = rating;
                });
                getObservationChanges();
              },
            ),
            // Responsive.isDesktop(context)
            // ? SizedBox(width: 50,child: Text(rating),) : Container(),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSelectAllRatingFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['BG', 'PG', 'PF', 'NA'].map((rating) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  rating,
                  style: TextStyle(color: LightColors.kBlue),
                ),
                Checkbox(
                  activeColor: Colors.grey,
                  checkColor: kPrimaryLightColor,
                  fillColor: WidgetStatePropertyAll(Colors.white),
                  value: _selectAllRating.contains(rating),
                  onChanged: (isChecked) {
                    updateCheckAll(isChecked! ? rating : '');
                    setState(() {
                      _selectAllRating = isChecked ? rating : '';
                      getObservationChanges();
                      debugPrint(_selectAllRating);
                    });
                  },
                ),
              ],
            )
          ],
        );
      }).toList(),
    );
  }
}
