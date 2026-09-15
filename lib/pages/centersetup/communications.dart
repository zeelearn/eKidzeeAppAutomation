import 'dart:async';

import 'package:ekidzee/api/request/bpms/get_communication.dart';
import 'package:ekidzee/iface/onClick.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:ekidzee/widget/MyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/response/pentemind/GenericResponse.dart';
import '../../../../../firebase/anylatics.dart';
import '../../../../../helper/utils.dart';
import '../../api/response/bpms/get_communication_response.dart';
import '../../constants.dart';
import '../../globals.dart';
import '../../helper/LocalConstant.dart';

class CommunicationScreen extends StatefulWidget {
  String franchiseeId;
  static ValueNotifier relaod = ValueNotifier(false);

  CommunicationScreen({super.key, required this.franchiseeId});

  @override
  _CommunicationScreenState createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen>
    with WidgetsBindingObserver
    implements onClickListener {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isLoading = true;
  List<CommunicationModel> mCommunicationList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //LogbookScreen.relaod.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getUserInfo();
    }
  }

  String userId = '';
  String francId = '';
  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    francId = prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
    userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
    getCommunicationList();
  }

  getCommunicationList() async {
    /*if(widget.cName.isEmpty)
      await getDay();*/
//     debugPrint('Fran Id $francId');
    mCommunicationList.clear();
    isLoading = true;
    setState(() {});
    GetCommunicationRequest request = GetCommunicationRequest(
        BusinessId: AppFlavor == 'mlzs' ? 2 : 1,
        FranchiseeId: int.parse(francId));
    debugPrint(request.toJson());
    APIService apiService = APIService();
    apiService.getCommunication(request).then((value) {
      if (value != null) {
        if (value == null) {
          Utility.showMessage(context, 'data not found');
        } else if (value is GetCommunicationResponse) {
          GetCommunicationResponse response = value;
          mCommunicationList.addAll(response.data);
          isLoading = false;
        } else {
          Utility.showMessage(context, 'data not found');
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsUtils().sendAnalyticsEvent('Communication');
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
              getCommunicationList();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            // Pull from top to show refresh indicator.
            child: getChildList(),
          ),
        ));
  }

  getChildList() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/json/kidzee_loader.json'),
      );
    } else if (mCommunicationList.isEmpty) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 1),
        child: Column(children: [
          Utility.emptyData(context,
              "Data are not available at this moment please check later"),
        ]),
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 1),
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              itemCount: mCommunicationList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return getCommunicationView(mCommunicationList[index]);
              },
            ))
          ],
        ),
      );
    }
  }

  getCommunicationView(CommunicationModel model) {
    debugPrint(model.EmailBody);
    return GestureDetector(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogbookDetailsScreen(
                logbookModel: logbookModel,
                day: _dayController.text.toString()),
          ),
        ).then((value) {
          getLogbook();
        });*/
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
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
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          MyWidget().richText('', LightColors.textSmallStyle),
                          MyWidget().richText('', LightColors.textSmallStyle),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Ref Id : ${model.ID}',
                        style: LightColors.textSmallStyle,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Padding(
                  padding: EdgeInsetsDirectional.all(0),
                  child: Text(
                    model.EmailSubject,
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      color: Color(0xFF4B39EF),
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                ),
                subtitle: HtmlWidget(model.EmailBody.toString()),
                /*subtitle: Padding(
                    padding: EdgeInsets.all(0),
                    child: HtmlWidget(model.EmailBody.toString()), */ /*Html(data: model.EmailBody.toString(),
                      shrinkWrap: true,
                      style: {
                      "body": Style(
                        fontSize: FontSize(12.0),
                      ),},),*/ /*
                  */ /* Text(
                      model.EmailBody,
                      style: GoogleFonts.roboto(
                        fontSize: 11.0,
                        color: Color(0xFF4B39EF),
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),*/ /*
                    //),
                ),*/
                trailing: Text(
                  Utility.parseShortDate(model.CreatedDate),
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    color: Color(0xFF4B39EF),
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          MyWidget().richText('', LightColors.textSmallStyle),
                          MyWidget().richText('', LightColors.textSmallStyle),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: model.EmailStatus == 'SENT'
                          ? Icon(
                              Icons.done_all,
                              size: 20,
                            )
                          : Icon(
                              Icons.done,
                              size: 20,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClick(int action, value) {
    if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Utility.showMessage(context, value.toString());
    } else if (action == Utility.ACTION_OK) {
      Utility.showMessageCallback(context, 'SUCCESS', value.message, this);
    } else if (value is GenericResponse) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      GenericResponse response = value;
      if (response.success == 200) {
        Utility.showMessage(context, response.response[0].response);
      }
    }
  }
}
