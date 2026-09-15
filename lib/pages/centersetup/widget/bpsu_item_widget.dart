import 'package:ekidzee/pages/centersetup/chat/IndividualPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../../constants.dart';
import '../../../helper/color_constant.dart';
import '../../../helper/image_constant.dart';
import '../../../helper/math_utils.dart';
import '../../../helper/utils.dart';
import '../../../iface/onClick.dart';
import '../../../utils/theme/colors/light_colors.dart';
import '../Model/ChatModel.dart';
import '../bpsu_model.dart';
import '../chat/chat_inner_item_widget.dart';

class CenterSeupItemWidget extends StatelessWidget {
  final TaskDetailModel item;
  final onClickListener clickListener;

  const CenterSeupItemWidget(this.item,
      {super.key, required this.clickListener});

  @override
  Widget build(BuildContext context) {
    return getView(context);
  }

  getView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.startDate.isNotEmpty) {
          showChatScreen(context, item);
        } else {
          clickListener.onClick(111, item);
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: (item.status == 4 || item.status == 5)
                ? LightColors.kLightGrayM
                : Colors.white,
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
                      child: Text(
                        'Ref Id : ${item.mtaskId}',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF4B39EF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'CRM ID : ${item.projectId}',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF4B39EF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 1,
                decoration: BoxDecoration(
                  color: Color(0xFFF1F4F8),
                ),
              ),*/
              ListTile(
                title: Padding(
                  padding: EdgeInsetsDirectional.all(0),
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF090F13),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                subtitle: item.latestComment.isEmpty
                    ? null
                    : /*Expanded(
                  flex: 1,
                  child:*/
                    Text(
                        'Remark : ${item.latestComment}',
                        style: const TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                //),
                trailing: item.status == '0'
                    ? OutlinedButton(
                        onPressed: () {
                          /*if (pjpInfo.isSelfPJP=='0' || widget.mFilterSelection.type == FILTERStatus.MYSELF && pjpInfo.ApprovalStatus =='Approved') {
                      Utility.showMessageMultiButton(context,'Approve','Reject', 'PJP : ${pjpInfo.PJP_Id}', 'Are you sure to approve the PJP, created by ${pjpInfo.displayName}',pjpInfo, this);
                    }else{
                      Utility.showMessages(context, 'Please wait Your manager need to approve the PJP');
                    }*/
                        },
                        child: Text(
                          item.statusname,
                          style: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF4B39EF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : item.status == 4
                        ? Image.asset(
                            'assets/icons/ic_checked.png',
                            height: 50,
                          )
                        : Text(
                            item.statusname,
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: item.statusname == 'BP Completed'
                                  ? kPrimaryLightColor
                                  : LightColors.kRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: Image.asset(
                              'assets/icons/ic_starttime.png',
                              width: 14,
                            )),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            item.startDate.isEmpty
                                ? ''
                                : Utility.parseShortDate(item.startDate),
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF4B39EF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    item.endDate.isNotEmpty &&
                            (item.status == 4 || item.status == 5)
                        ? Row(
                            children: [
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 0, 0),
                                  child: Image.asset(
                                    'assets/icons/ic_duedate.png',
                                    width: 18,
                                  )),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  Utility.parseShortDate(item.endDate),
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF4B39EF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showChatScreen(BuildContext context, TaskDetailModel taskModel) async {
    ChatModel model = ChatModel(
      name: taskModel.title,
      isGroup: false,
      currentMessage: taskModel.note,
      time: taskModel.startDate,
      icon: "person.svg",
      id: taskModel.dependentTaskId,
      status: taskModel.statusname,
    );
//     debugPrint('Display chrt');
    var result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => IndividualPage(
              taskModel: taskModel,
              clickListener: clickListener,
            )));
//     debugPrint('In result --------$result--');
    if (result != null) clickListener.onClick(1212, result);
  }

  showChatScreen1(BuildContext context, BPSetupModel model) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),*/
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(children: <Widget>[
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                        ColorConstant.fromHex('#EDE7FF'),
                        ColorConstant.fromHex('#E5EBFF'),
                      ])),
                  child: Stack(
                    children: [
                      ListView(
                        reverse: true,
                        padding: EdgeInsets.only(
                          top: getVerticalSize(50),
                          left: getSize(15),
                          bottom: getSize(100),
                          right: getSize(15),
                        ),
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              /*Image.asset(
                        ImageConstant.imgRectangle162,
                        height: getSize(
                          40,
                        ),
                        width: getSize(
                          40,
                        ),
                        fit: BoxFit.fill,
                      ),*/
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                      left: getHorizontalSize(
                                        8,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        ChatInnerItemWidget.name(
                                          sender: 'Business Partner',
                                          image:
                                              ImageConstant.imgUnsplashauvrwz,
                                          interestAsset:
                                              ImageConstant.imgGroup242,
                                          likedCount: '146',
                                          readCount: '1.8K',
                                          date: '12:35',
                                        ),
                                        const Gap(6),
                                        ChatInnerItemWidget.name(
                                          text:
                                              'Civil work has been completed as per guideline',
                                          interestAsset:
                                              ImageConstant.imgGroup242,
                                          likedCount: '110',
                                          highlight: true,
                                          readCount: '1.6K',
                                          date: '12:50',
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          /*const Gap(10),
                  const AudioFrame(),
                  const Gap(10),
                  const AudioFrame(),
                  const Gap(10),
                  const AudioFrame(),*/
                          /*const Gap(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        ImageConstant.imgRectangle1622,
                        height: getSize(
                          40,
                        ),
                        width: getSize(
                          40,
                        ),
                        fit: BoxFit.fill,
                      ),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: getHorizontalSize(
                                8,
                              ),
                            ),
                            child: ChatInnerItemWidget.name(
                              sender: 'Cameron Williamson',
                              image: ImageConstant.imgUnsplashfwfjfx,
                              interestAsset: ImageConstant.imgGroup2423,
                              likedCount: '4',
                              readCount: '21',
                              date: '13:46',
                            )),
                      ),
                    ],
                  ),*/
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstant.whiteA700E5,
                          ),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: getVerticalSize(
                                    24,
                                  ),
                                  bottom: getVerticalSize(
                                    8,
                                  ),
                                ),
                                child: SizedBox(
                                  height: getSize(
                                    24,
                                  ),
                                  width: getSize(
                                    24,
                                  ),
                                  child: SvgPicture.asset(
                                    ImageConstant.imgIconplus,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: getVerticalSize(
                                    16,
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: getVerticalSize(
                                    40,
                                  ),
                                  width: getHorizontalSize(
                                    263,
                                  ),
                                  padding: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      30,
                                    ),
                                    top: getVerticalSize(
                                      10,
                                    ),
                                    right: getHorizontalSize(
                                      30,
                                    ),
                                    bottom: getVerticalSize(
                                      10,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.bluegray50,
                                    borderRadius: BorderRadius.circular(
                                      getHorizontalSize(
                                        8,
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: ColorConstant.bluegray400,
                                      fontSize: getFontSize(
                                        14,
                                      ),
                                      fontFamily: 'General Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: getVerticalSize(
                                    24,
                                  ),
                                  bottom: getVerticalSize(
                                    8,
                                  ),
                                ),
                                child: SizedBox(
                                  height: getSize(
                                    32,
                                  ),
                                  width: getSize(
                                    32,
                                  ),
                                  child: Image.asset(
                                    ImageConstant.imgIconmicro,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: ColorConstant.whiteA700E5,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                            top: getVerticalSize(
                              5,
                            ),
                            bottom: getVerticalSize(
                              4,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getHorizontalSize(
                                14,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    CupertinoIcons.chevron_left,
                                    color: ColorConstant.deepPurpleA200,
                                    size: 20,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            model.title,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ColorConstant.gray900,
                                              fontSize: getFontSize(
                                                16,
                                              ),
                                              fontFamily: 'SF Pro Text',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        /*Container(
                                  width: getHorizontalSize(
                                    76,
                                  ),
                                  margin: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      8.5,
                                    ),
                                    top: getVerticalSize(
                                      3,
                                    ),
                                    right: getHorizontalSize(
                                      8.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      */ /*SizedBox(
                                        width: getHorizontalSize(
                                          25,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: getVerticalSize(
                                                  2.5,
                                                ),
                                                bottom: getVerticalSize(
                                                  2.5,
                                                ),
                                              ),
                                              child: SizedBox(
                                                height: getSize(
                                                  12,
                                                ),
                                                width: getSize(
                                                  12,
                                                ),
                                                child: SvgPicture.asset(
                                                  ImageConstant.imgIconuser1,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: getHorizontalSize(
                                                  2,
                                                ),
                                              ),
                                              child: Text(
                                                "12",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                  ColorConstant.bluegray400,
                                                  fontSize: getFontSize(
                                                    12,
                                                  ),
                                                  fontFamily: 'General Sans',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),*/ /*
                                      */ /*SizedBox(
                                        width: getHorizontalSize(
                                          43,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: getVerticalSize(
                                                  2.5,
                                                ),
                                                bottom: getVerticalSize(
                                                  2.5,
                                                ),
                                              ),
                                              child: SizedBox(
                                                height: getSize(
                                                  12,
                                                ),
                                                width: getSize(
                                                  12,
                                                ),
                                                child: SvgPicture.asset(
                                                  ImageConstant.imgIconeye2,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: getHorizontalSize(
                                                  2,
                                                ),
                                              ),
                                              child: Text(
                                                "3 827",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                  ColorConstant.bluegray400,
                                                  fontSize: getFontSize(
                                                    12,
                                                  ),
                                                  fontFamily: 'General Sans',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),*/ /*
                                    ],
                                  ),
                                ),*/
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getHorizontalSize(
                                          85.5,
                                        ),
                                      ),
                                      child: Text(
                                          '') /*Image.asset(
                                ImageConstant.imgRectangle1621,
                                height: getSize(
                                  40,
                                ),
                                width: getSize(
                                  40,
                                ),
                                fit: BoxFit.fill,
                              )*/
                                      ,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ));
  }
}
