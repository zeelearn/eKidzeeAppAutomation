import 'package:ekidzee/Responsive.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/globals.dart';
import 'package:ekidzee/helper/utils.dart' as util;
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/pages/k12/domain/entities/learninggoal/observations.dart';
import 'package:ekidzee/pages/k12/domain/entities/lg_entity.dart';
import 'package:ekidzee/pages/k12/presentation/pages/LG/studentlist.dart';
import 'package:ekidzee/pages/k12/presentation/providers/learninggoal_provider.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saathi/core/utility/utils.dart';
import 'package:saathi/widget/dropdown.dart';

class KESLearningGoalPage extends StatefulWidget {
  int sectinId;
  int classId;
  String className;
  String userUID;
  String userName;

  KESLearningGoalPage(
      {super.key,
      required this.sectinId,
      required this.classId,
      required this.userUID,
      required this.className,
      required this.userName});

  @override
  _KESLearningGoalPageState createState() => _KESLearningGoalPageState();
}

class _KESLearningGoalPageState extends State<KESLearningGoalPage>
    implements onClickListener {
  String selectedSubject = 'Select Subject';
  String selectedPhase = 'Select Phase';
  String selectPPA = 'Select PPA';

  final TextEditingController _contSubject = TextEditingController();
  final TextEditingController _contPhase = TextEditingController();
  final TextEditingController _contPPA = TextEditingController();

  final int ACTION_TERMS = 10001;

  Ppan? mPpa;
  Subject? mSelectedSubject;
  Phase? mPhase;
  List<Phase> mPhaseList = [];
  List<Ppan> mPPanList = [];
  List<KESLearningGoalObservations> mObservationList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screentype = Responsive.isMobile(context)
        ? 2.5
        : Responsive.isTablet(context)
            ? 4.6
            : 4.4;
    return Scaffold(
      bottomNavigationBar: footerKESLG(),
      body: FutureBuilder(
        future: mSelectedSubject == null
            ? LearninggoalProvider.getLearningMasters(widget.className,
                widget.sectinId, widget.userUID, widget.userName)
            : null,
        builder: (context, subjectsSnapshot) {
          if (!subjectsSnapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (subjectsSnapshot.data?.classId != null &&
              subjectsSnapshot.data?.sectionId != null) {
            widget.sectinId = subjectsSnapshot.data!.sectionId;
            widget.classId = subjectsSnapshot.data!.classId;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 2, right: 2, top: 10, bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: defaultPadding,
                    ),
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width / screentype,
                      child: ZeeDropDown(
                        title: 'Subject',
                        readOnly: true,
                        textController: _contSubject,
                        hintText: 'Select Subject',
                        items: subjectsSnapshot.data!.subject,
                        displayFunction: (value) => value.subjectName,
                        onChanged: (value) {
//                           debugPrint('subject ius $value');
                          if (value != null) {
                            setState(() {
                              _contPhase.text = '';
                              mObservationList.clear();
                              mPpa = null;
                              mSelectedSubject = value;
                              mPhaseList.clear();
                              mPPanList.clear();
                              mPhaseList.addAll(mSelectedSubject!.phase);
                            });
                          } else {
                            mSelectedSubject = null;
                            _contPhase.text = '';
                            mObservationList.clear();
                            mPpa = null;
                            mPhaseList.clear();
                            mPPanList.clear();
                            mObservationList.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    if (mSelectedSubject != null)
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width / screentype,
                        child: ZeeDropDown(
                          title: 'Phase',
                          readOnly: true,
                          textController: _contPhase,
                          hintText: 'Select Phase',
                          items: mPhaseList ?? [],
                          displayFunction: (value) => value.phase,
                          onChanged: (value) {
                            if (value != null) {
                              mPhase = value;
                              _contPhase.text = value.phase;
                              mPPanList.clear();
                              mPPanList.addAll(mPhase!.ppan);
                              if (mPPanList.length == 1) {
                                mPpa = mPPanList[0];
                                _contPPA.text = mPPanList[0].ppan.toString();
                                fetchObservations();
                              } else
                                setState(() {});
                            } else {
                              mObservationList.clear();
                              mPpa = null;
                              mPPanList.clear();
                              mObservationList.clear();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    if (!Responsive.isMobile(context) && mPPanList.isNotEmpty)
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width / screentype,
                        child: ZeeDropDown(
                          readOnly: true,
                          title: 'PPA',
                          textController: _contPPA,
                          hintText: 'Select PPA',
                          items: mPPanList ?? [],
                          displayFunction: (value) => value.ppan.toString(),
                          onChanged: (value) {
                            if (value != null) {
                              mPpa = value;
                              _contPPA.text = mPpa!.ppan.toString();
                              fetchObservations();
                            }
                          },
                        ),
                      ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    if (!Responsive.isMobile(context) && mPpa != null)
                      MaterialButton(
                        color: kPrimaryLightColor,
                        onPressed: () {
//                           debugPrint('mPPa valie $mPpa');
                          debugPrint(mPpa.toString());
                          onFileTap(context, 'PPA Guideline',
                              mPpa!.guidelineUrl!, '', false);
                        },
                        animationDuration: Duration(milliseconds: 2000),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'PPA Guideline',
                            style: LightColors.textHeaderStyleWhite,
                          ),
                        ),
                      )
                  ],
                ),
              ),
              if (Responsive.isMobile(context))
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: defaultPadding,
                      ),
                      if (mPPanList.isNotEmpty)
                        SizedBox(
                          height: 45,
                          width: MediaQuery.of(context).size.width / screentype,
                          child: ZeeDropDown(
                            title: 'PPA',
                            textController: _contPPA,
                            hintText: 'Select PPA',
                            items: mPPanList ?? [],
                            displayFunction: (value) => value.ppan.toString(),
                            onChanged: (value) {
                              if (value != null) {
                                mPpa = value;
                                _contPPA.text = mPpa!.ppan.toString();
                                fetchObservations();
                              }
                            },
                          ),
                        ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      if (Responsive.isMobile(context) &&
                          mPpa != null &&
                          mPpa!.guidelineUrl != null)
                        MaterialButton(
                          color: kPrimaryLightColor,
                          onPressed: () {
                            onFileTap(context, 'PPA Guideline',
                                mPpa!.guidelineUrl!, '', false);
                          },
                          animationDuration: Duration(milliseconds: 2000),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'PPA Guideline',
                              style: LightColors.textHeaderStyleWhite,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              SizedBox(
                width: defaultPadding,
              ),
              if (mObservationList.isNotEmpty) _observationWidget(),
              SizedBox(
                height: defaultPadding,
              ),
              if (mSelectedSubject == null || mPhase == null || mPpa == null)
                getFilterHint()
            ],
          );
        },
      ),
    );
  }

  getFilterHint() {
    return util.Utility.filter(
        context,
        mSelectedSubject == null
            ? 'Please Select the Subject'
            : mPhase == null
                ? 'Please Select Phase'
                : "Please Select PPA");
  }

  _observationWidget() {
    return Flexible(
      child: ListView.builder(
        itemCount: mObservationList.length,
        itemBuilder: (context, index) {
          KESLearningGoalObservations model = mObservationList[index];
          return Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: kPrimaryLightColor.withOpacity(0.5), width: 0.5)),
              child: _childView(model, index));
        },
      ),
    );
  }

  _childView(KESLearningGoalObservations model, int index) {
    if (index == 0) {
      return Column(
        children: [
          Container(
            color: LightColors.kLightGray,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: MyWidget()
                        .richText('Criteria', LightColors.textHeaderStyle13),
                  ),
                ),
                VerticalDivider(color: kPrimaryLightColor.withOpacity(0.5)),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: MyWidget().richText(
                        'Competencies', LightColors.textHeaderStyle13),
                  ),
                ),
                VerticalDivider(color: kPrimaryLightColor.withOpacity(0.5)),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: MyWidget()
                        .richText('Rating', LightColors.textHeaderStyle13),
                  ),
                ),
              ],
            ),
          ),
          _childRow(model)
        ],
      );
    } else {
      return _childRow(model);
    }
  }

  _childRow(KESLearningGoalObservations model) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => KESLGStudentListPage(
                  observations: model,
                  sectionId: widget.sectinId,
                  userName: widget.userName,
                  userid: Utility.toInt(widget.userUID))),
        ).then((value) {
          if (value != null && value is KESLearningGoalObservations) {
            KESLearningGoalObservations obs = value;
            for (int index = 0; index < mObservationList.length; index++) {
              if (obs.ccId == mObservationList[index].ccId) {
                //debugPrint('Observations are updated');
                mObservationList[index].bg = obs.bg;
                mObservationList[index].pg = obs.pg;
                mObservationList[index].pf = obs.pf;
                mObservationList[index].na = obs.na;
                // debugPrint(obs.bg);
              }
            }
          }
          setState(() {});
        });
      },
      child: kIsWeb
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: MyWidget()
                        .richText(model.criteria, LightColors.textSmallStyle),
                  ),
                ),
                VerticalDivider(color: kPrimaryLightColor.withOpacity(0.5)),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: MyWidget().richText(
                        model.curricularGoalName, LightColors.textSmallStyle),
                  ),
                ),
                VerticalDivider(color: kPrimaryLightColor.withOpacity(0.5)),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: _trailing(model),
                  ),
                ),
              ],
            )
          : ListTile(
              contentPadding: EdgeInsets.zero,
              title: Container(
                padding: EdgeInsets.all(10),
                child: MyWidget().richText(
                    model.competenciesName, LightColors.textSmallStyle),
              ),
              subtitle: Container(
                padding: EdgeInsets.all(10),
                child: MyWidget()
                    .richText(model.criteria, LightColors.textSmallStyle),
              ),
              trailing: SizedBox(
                width: 120,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _chip(model, 'BG', model.bg.toString(), _colorChips[0]),
                        SizedBox(
                          width: 4,
                        ),
                        _chip(model, 'PG', model.pg.toString(), _colorChips[1]),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _chip(model, 'PF', model.pf.toString(), _colorChips[2]),
                        SizedBox(
                          width: 4,
                        ),
                        _chip(model, 'NA', model.na.toString(), _colorChips[3]),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  _chip(KESLearningGoalObservations observation, String label, String value,
      Color color) {
    return SizedBox(
      width: 50,
      child: Container(
        padding: EdgeInsets.all(2),
        color: color,
        child: Row(
          children: [
            Text(
              label,
              style: LightColors.smallTextStyle.copyWith(color: Colors.white),
            ),
            Text(
              '  - ${value.toString()}',
              style: LightColors.smallTextStyle.copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  _trailing(KESLearningGoalObservations observation) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 2.0,
      children: List<Widget>.generate(_dynamicChips.length, (int index) {
        return Chip(
          avatar: CircleAvatar(
            backgroundColor: _colorChips[index],
            child: Text(
              _dynamicChips[index],
              style: GoogleFonts.roboto(
                fontSize: 10.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          label: Text(getTagValue(observation, index),
              style: GoogleFonts.roboto(
                fontSize: 10.0,
                color: LightColors.kDarkBlue,
                fontWeight: FontWeight.bold,
                height: 1,
              )),
        );
      }),
    );
  }

  final List<String> _dynamicChips = ['BG', 'PG', 'PF', 'NA'];

  final List<Color> _colorChips = [
    LightColors.kGreen,
    LightColors.kBlue,
    LightColors.kLavender,
    LightColors.kRed
  ];

  _observationWidgetMobile() {
    return Flexible(
      child: ListView.builder(
        itemCount: mObservationList.length,
        itemBuilder: (context, index) {
          KESLearningGoalObservations model = mObservationList[index];
          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Card(
                color: model.bg == 1 ? Colors.white : Colors.white,
                child: ListTile(
                    title: MyWidget().richText(
                        model.curricularGoalName, LightColors.textSmallStyle),
                    leading: MyWidget()
                        .richText(model.criteria, LightColors.textSmallStyle),
                    trailing: Wrap(
                      spacing: 4.0,
                      runSpacing: 2.0,
                      children: List<Widget>.generate(_dynamicChips.length,
                          (int index) {
                        return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: _colorChips[index],
                            child: Text(
                              _dynamicChips[index],
                              style: GoogleFonts.roboto(
                                fontSize: 10.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ),
                          label:
                              Text(getTagValue(mObservationList[index], index),
                                  style: GoogleFonts.roboto(
                                    fontSize: 10.0,
                                    color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  )),
                        );
                      }),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  String getTagValue(KESLearningGoalObservations obsrvation, int index) {
    String value = '';
    if (index == 0) {
      value = obsrvation.bg.toString();
    } else if (index == 1) {
      value = obsrvation.pg.toString();
    } else if (index == 2) {
      value = obsrvation.pf.toString();
    } else if (index == 3) {
      value = obsrvation.na.toString();
    }
    return value;
  }

  fetchObservations() async {
    util.Utility.showKESLoaderDialog(context);
    List<KESLearningGoalObservations> list =
        await LearninggoalProvider.getLGObservations(
            classId: widget.classId,
            subjectId: mSelectedSubject!.subjectId,
            phId: mPhase!.phId,
            ppanId: mPpa!.ppanId,
            sectionId: widget.sectinId);
    Utility.hideLoader(context);
    mObservationList.clear();
    mObservationList.addAll(list);
    setState(() {});
  }

  mobileHeader() {
    return SizedBox(
      height: 100,
      child: GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: <Widget>[
          SizedBox(
            height: 45,
            width: 200,
            child: ZeeDropDown(
              title: 'Phase',
              readOnly: true,
              textController: _contPhase,
              hintText: 'Select Phase',
              items: mSelectedSubject == null ? [] : mSelectedSubject!.phase,
              displayFunction: (value) => value.phase,
              onChanged: (value) {
                if (value != null) {
                  mPhase = value;
                  _contPhase.text = value.phase;
                  setState(() {});
                }
              },
            ),
          ),
          SizedBox(
            height: 45,
            width: 200,
            child: ZeeDropDown(
              title: 'Phase',
              textController: _contPhase,
              hintText: 'Select Phase',
              items: mSelectedSubject == null ? [] : mSelectedSubject!.phase,
              displayFunction: (value) => value.phase,
              onChanged: (value) {
                if (value != null) {
                  mPhase = value;
                  _contPhase.text = value.phase;
                  setState(() {});
                }
              },
            ),
          ),
          SizedBox(
            height: 45,
            width: 200,
            child: ZeeDropDown(
              title: 'Phase',
              readOnly: true,
              textController: _contPhase,
              hintText: 'Select Phase',
              items: mSelectedSubject == null ? [] : mSelectedSubject!.phase,
              displayFunction: (value) => value.phase,
              onChanged: (value) {
                if (value != null) {
                  mPhase = value;
                  _contPhase.text = value.phase;
                  setState(() {});
                }
              },
            ),
          ),
          SizedBox(
            height: 45,
            width: 200,
            child: ZeeDropDown(
              title: 'Phase',
              readOnly: true,
              textController: _contPhase,
              hintText: 'Select Phase',
              items: mSelectedSubject == null ? [] : mSelectedSubject!.phase,
              displayFunction: (value) => value.phase,
              onChanged: (value) {
                if (value != null) {
                  mPhase = value;
                  _contPhase.text = value.phase;
                  setState(() {});
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClick(int action, value) {
    // TODO: implement onClick
  }
}
