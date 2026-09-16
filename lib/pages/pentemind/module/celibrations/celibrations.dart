import 'package:ekidzee/constants.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/iface/onResponse.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../../../api/ServiceHandler.dart';
import '../../../../api/request/celibration/celibration_request.dart';
import '../../../../api/response/celibration/zll_celibration_response.dart';
import '../../../../app_routes.dart';

class CelibrationScreen extends StatefulWidget {
  const CelibrationScreen({super.key});

  @override
  _CelibrationScreenState createState() => _CelibrationScreenState();
}

class _CelibrationScreenState extends State<CelibrationScreen>
    with WidgetsBindingObserver
    implements onClickListener, onResponse {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isLoading = true;
  List<CelibrationModel> mModelList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadData();
  }

  loadData() async {
    ApiServiceHandler()
        .getCelibration(CelibrationRequest(display: 'zllresource'), this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('ParentCorner:ELG');
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: kPrimaryLightColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return a Future when code finishs execution.
              loadData();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Utility.showLoader();
    } else if (mModelList.isEmpty) {
      return Column(
        children: [
          MyWidget()
              .richText('Pull down to refresh...', LightColors.textvSmallStyle),
          Utility.emptyData(context,
              "Data are not available at this moment please check later")
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 1),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            MyWidget().richText(
                'Pull down to refresh...', LightColors.textSmallHightliteStyle),
            Flexible(
                child: ListView.builder(
              itemCount: mModelList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    color: Colors.white,
                    child: getActivityWidget(mModelList[index]),
                  ),
                );
              },
            ))
          ],
        ),
      );
    }
  }

  getActivityWidget(CelibrationModel model) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color.fromRGBO(253, 184, 19, 1),
                      Color.fromRGBO(120, 140, 182, 1)
                    ]),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Color(0x430F1113),
                    offset: Offset(0, 1),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 40,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 10,
                            ),
                            child: Text(
                              model.title,
                              style: GoogleFonts.roboto(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(00),
                                topRight: Radius.circular(00)),
                            child: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Utility.parseShortDate(model.validfrom),
                                        style: LightColors.textHeaderStyleWhite,
                                      ),
                                      Text(
                                        'to',
                                        style: LightColors.absentRoundedStyle,
                                      ),
                                      Text(
                                        Utility.parseShortDate(model.validto),
                                        style: LightColors.textHeaderStyleWhite,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () async {
                    if (model.contenturl.contains('m3u8')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => goToKltChewieVideo(
                                filePath: model.contenturl,
                                Title: model.title)),
                      );
                    } else if (model.contenturl.contains('.pdf')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => goToMyPdf(
                            worksheetUrl: model.contenturl,
                            title: model.title,
                            filename: '${model.title}.pdf',
                            module: 'celi',
                            isDownload: false,
                          ),
                        ),
                      );
                    } else {
                      debugPrint(model.contenturl);
                      await openCelebrationWebsite(
                        context,
                        title: model.title,
                        url: model.contenturl,
                      );
                    }
                  },
                  child: Container(
                    child: Wrap(
                      spacing: 5, // space between two icons
                      children: <Widget>[
                        Chip(
                          backgroundColor: kPrimaryLightColor,
                          label: Text('View',
                              style: LightColors.textHeaderStyleWhite),
                        )
                      ],
                    ),
                  )),
              SizedBox(
                width: 30,
              ),
              model.viewurl.isEmpty
                  ? SizedBox(
                      height: 0,
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: () async {
                            if (model.contenturl.contains('m3u8')) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => goToKltChewieVideo(
                                        filePath: model.contenturl,
                                        Title: model.title)),
                              );
                            } else if (model.viewurl.contains('.pdf')) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => goToMyPdf(
                                    worksheetUrl: model.viewurl,
                                    title: model.title,
                                    filename: '${model.title}.pdf',
                                    module: 'celi',
                                    isDownload: false,
                                  ),
                                ),
                              );
                            } else {
                              debugPrint(model.viewurl);
                              await openCelebrationWebsite(
                                context,
                                title: model.title,
                                url: model.viewurl,
                              );
                            }
                          },
                          child: Container(
                            child: Wrap(
                              spacing: 5, // space between two icons
                              children: <Widget>[
                                Chip(
                                  backgroundColor: kPrimaryLightColor,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  label: Text('Join',
                                      style: LightColors.textHeaderStyleWhite),
                                )
                              ],
                            ),
                          )),
                    )
            ],
          )
        ],
      ),
    );
  }

  @override
  void onClick(int action, value) {}

  @override
  void onError(int action, value) {
    setState(() {
      mModelList.clear();
      isLoading = false;
    });
  }

  @override
  void onResponseStart() {
    setState(() {
      mModelList.clear();
      isLoading = true;
    });
  }

  @override
  void onSuccess(value) {
    if (value is ZllResourceResponse) {
      ZllResourceResponse eventModel = value;
      mModelList.clear();
      if (eventModel.data.isNotEmpty) {
        mModelList.addAll(eventModel.data);
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
