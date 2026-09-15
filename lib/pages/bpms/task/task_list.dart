import 'package:ekidzee/constants.dart';
import 'package:ekidzee/pages/bpms/auth/ui/task.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../helper/utils.dart';
import '../../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../../app_routes.dart';
import '../../../helper/LightColor.dart';
import '../../../helper/color_constant.dart';
import '../../../helper/math_utils.dart';
import '../../centersetup/indent_history.dart';
import '../auth/data/providers/auth_provider.dart';

class BPMSTaskScreen extends StatefulHookConsumerWidget {
  const BPMSTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BPMSTaskScreenState();
}

class _BPMSTaskScreenState extends ConsumerState<BPMSTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  static const int ACTION_ALL = 0;
  static const int ACTION_PENDING = 1;
  static const int ACTION_COMPLETED = 2;
  static const int ACTION_BPCOMPLETED = 3;
  static const int ACTION_INPROGRESS = 4;
  //FranchiseeIndentModel

  final List<Filters> _chipsList = [
    Filters('All', ACTION_ALL, kPrimaryLightColor, false),
    Filters('Pending', ACTION_PENDING, LightColor.grey, false),
    Filters('In Progress', ACTION_INPROGRESS, LightColor.grey, false),
    Filters('Completed', ACTION_COMPLETED, LightColor.grey, false),
    Filters('BP Completed', ACTION_BPCOMPLETED, LightColor.grey, false)
  ];
  int mFilter = ACTION_ALL;

  List<Widget> getHeaderNew() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList.length; i++) {
      Widget item = Container(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: FilterChip(
          label: _chipsList[i].index == 0
              ? Text(_chipsList[i].label.length > 15
                  ? '${_chipsList[i].label.substring(0, 15)}...'
                  : _chipsList[i].label)
              : Text(_chipsList[i].label.length > 15
                  ? '${_chipsList[i].label.substring(0, 15)}...'
                  : _chipsList[i].label),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
          backgroundColor: _chipsList[i].color,
          selected: _chipsList[i].isSelected,
          onSelected: (bool value) {
            resetColor(i);

            setState(() {});
            /*if (_chipsList[i].index == ACTION_DAY) {
              getInputBottomSheet();
            } else if (_chipsList[i].index == ACTION_OBSERVATION) {
              showListBottomSheet(_chipsList[i].index, observations);
            } else if (_chipsList[i].index == ACTION_SESSSION) {
              showListBottomSheet(_chipsList[i].index, sessionss);
            } else if (_chipsList[i].index == ACTION_DOMAIN) {
              showListBottomSheet(_chipsList[i].index, domains);
            } else if (_chipsList[i].index == ACTION_SKILL) {
              showListBottomSheet(_chipsList[i].index, skills);
            } else {}*/
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  getTaskType(int type) {
    String taskType = '';
    switch (type) {
      case 0:
        taskType = 'All';
        break;
      case 1:
        taskType = 'Pending';
        break;
      case 2:
        taskType = 'Completed';
        break;
      case 3:
        taskType = 'BP Completed';
        break;
      case 4:
        taskType = 'In Progress';
        break;
      default:
        taskType = 'All';
        break;
    }
    return taskType;
  }

  getSortedTaskList(int taskType) {
//     debugPrint('Filter $mFilter');
    final auth = ref.watch(authNotifierProvider);
    // debugPrint(auth.taskModelList!.length);
    List<TaskDetailModel> mList = [];
    for (int index = 0; index < auth.taskModelList!.length; index++) {
      if (taskType == ACTION_ALL) {
        mList.add(auth.taskModelList![index]);
      } else if (taskType == ACTION_PENDING &&
          auth.taskModelList![index].statusname == 'Pending') {
        mList.add(auth.taskModelList![index]);
      } else if (taskType == ACTION_COMPLETED &&
          auth.taskModelList![index].statusname.toLowerCase() == 'complted') {
        mList.add(auth.taskModelList![index]);
      } else if (taskType == ACTION_BPCOMPLETED &&
          auth.taskModelList![index].statusname.toLowerCase() ==
              'bp completed') {
        mList.add(auth.taskModelList![index]);
      } else if (taskType == ACTION_INPROGRESS &&
          auth.taskModelList![index].statusname
              .toLowerCase()
              .contains('progress')) {
        mList.add(auth.taskModelList![index]);
      }
    }
    return mList;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    //debugPrint('task list size ${auth.taskModelList}');
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    return SafeArea(
      child: RefreshIndicator(
          key: refreshIndicatorKey,
          color: kPrimaryLightColor,
          backgroundColor: kPrimaryLightColor,
          strokeWidth: 4.0,
          onRefresh: () async {
            // Replace this delay with the code to be executed during refresh
            try {
//               debugPrint('task refresh...');
              ref.read(authNotifierProvider.notifier).refreshTask();
            } catch (e) {
              debugPrint(e.toString());
            }
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          // Pull from top to show refresh indicator.
          child: auth.taskModelList == null || auth.taskModelList!.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(top: 1),
                  child: Column(children: [
                    Utility.emptyData(context,
                        "Data are not available at this moment please check later"),
                  ]),
                )
              : Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Wrap(
                        spacing: 0,
                        direction: Axis.horizontal,
                        children: getHeaderNew(),
                      ),
                    ),
                    Tasks(
                        ref, getSortedTaskList(mFilter) /*auth.taskModelList!*/)
                  ],
                ) /*Tasks(ref,auth.taskModelList!)*/ /*Container(
                  padding: const EdgeInsets.only(top: 1),
                  child: Container(
                      color: LightColors.kLightGray1,
                      child: ListView.builder(
                        itemCount: auth.taskModelList!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return auth.taskModelList![index].statusname
                                      .toLowerCase()
                                      .contains('comple') ||
                                  auth.taskModelList![index].statusname
                                      .toLowerCase()
                                      .contains('progress')
                              ? getMyView(auth.taskModelList![index])
                              : emptyView(auth.taskModelList![index]);
                        },
                      )))*/
          ),
    );
  }

  getMyView(TaskDetailModel model) {
    return InkWell(
      onTap: () {
        showChatScreen(context, model);
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showChatScreen(context, model);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ref Id - ${model.id}',
                                style: LightColors.smallTextStyle,
                              ),
                              Text(
                                'CRM Id - ${model.projectId}',
                                style: LightColors.smallTextStyle,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(model.title,
                                          style: TextStyle(
                                              color: kPrimaryLightColor,
                                              fontSize: 18)),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        model.latestComment,
                                        style: TextStyle(
                                            color: kPrimaryLightColor,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                getStatusWidget(model)
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          model.startDate.isEmpty
                              ? const SizedBox(
                                  height: 0,
                                )
                              : model.statusname.toLowerCase().contains('progr')
                                  ? InProgressCard(
                                      startDate: Utility.parseShortDate(
                                          model.startDate))
                                  : ScheduleCard(
                                      startDate: Utility.parseShortDate(
                                          model.startDate),
                                      endDate:
                                          Utility.parseShortDate(model.endDate),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(LightColor.bg02),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(LightColor.bg03),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  getTaskView(TaskDetailModel model) {
    return GestureDetector(
      onTap: () {
        showChatScreen(context, model);
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
        child: Card(
          color: Colors.white,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsetsDirectional.all(0),
              child: Text(model.title, style: LightColors.textHeaderStyle13),
            ),
            subtitle: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  Utility.parseShortDate(model.latestComment),
                  style: LightColors.textvSmallStyle,
                )),
            trailing: Text(
              model.statusname.toString(),
              style: LightColors.textHeaderStyle,
            ),
          ),
        ),
      ),
    );
  }

  showChatScreen(BuildContext context, TaskDetailModel taskModel) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return goToChatPage(taskModel: taskModel);
    }));
//     debugPrint('showChatScreen ------notifier-----------$result');
    ref.read(authNotifierProvider.notifier).refreshTask();
//     debugPrint('showChatScreen ------notifier---END--------');
    //debugPrint('result -----------------');
    /*if(result is TaskDetailModel){
//       debugPrint('Response received TaskDetailModel');
      TaskDetailModel resultModel = result;
//       debugPrint('Response received $result');
      for(int index=0;index<mTaskList.length;index++){
        if(mTaskList[index].mtaskId==resultModel.parentTaskId){
          mTaskList[index].statusname=resultModel.statusname;
          if(mTaskList[index].statusname=='BP Completed'){
            mTaskList[index].status=4;
          }else{
            mTaskList[index].status=resultModel.status;
          }
//           debugPrint('status ${resultModel.statusname}');

        }
      }
      loadTaskDetails();*/
    //}
  }

  emptyView(TaskDetailModel model) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          showChatScreen(context, model);
        } /*widget.clickListener.onClick(111, widget.item)*/,
        /*showModalBottomSheet(
          backgroundColor:
          Colors.transparent,
          context: context,
          builder: (builder) =>
              showBottomSheetEditTask(context))*/
        child: Container(
          margin: EdgeInsets.only(
            top: getVerticalSize(6.0),
            bottom: getVerticalSize(6.0),
          ),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: ColorConstant.whiteA700,
            borderRadius: BorderRadius.circular(
              getHorizontalSize(
                12,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Gap(8),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: getVerticalSize(
                            10,
                          ),
                          bottom: getVerticalSize(
                            1,
                          ),
                        ),
                        child: Text(
                          model.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant.gray900,
                            fontSize: getFontSize(
                              16,
                            ),
                            fontFamily: 'General Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: getVerticalSize(
                            1,
                          ),
                          bottom: getVerticalSize(
                            1,
                          ),
                        ),
                        child: InkWell(
                          /*onTap: () => widget.clickListener.onClick(111, widget.item),*/
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                              left: getHorizontalSize(
                                16,
                              ),
                              top: getVerticalSize(
                                8,
                              ),
                              right: getHorizontalSize(
                                16,
                              ),
                              bottom: getVerticalSize(
                                8,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: model.status == 4
                                  ? ColorConstant.deepPurpleA200
                                  : ColorConstant.gray900,
                              borderRadius: BorderRadius.circular(
                                getHorizontalSize(
                                  50,
                                ),
                              ),
                            ),
                            child: Text(
                              model.statusname,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorConstant.whiteA700,
                                fontSize: getFontSize(
                                  14,
                                ),
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getStatusWidget(TaskDetailModel model) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: getHorizontalSize(
          16,
        ),
        top: getVerticalSize(
          8,
        ),
        right: getHorizontalSize(
          16,
        ),
        bottom: getVerticalSize(
          8,
        ),
      ),
      decoration: BoxDecoration(
        color: model.statusname.contains('Compl')
            ? kPrimaryLightColor
            : ColorConstant.gray900,
        borderRadius: BorderRadius.circular(
          getHorizontalSize(
            50,
          ),
        ),
      ),
      child: Text(
        model.statusname,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'SF Pro Text',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  taskInProgressModel(TaskDetailModel item) {
    return GestureDetector(
      onTap: () {
        if (item.startDate.isNotEmpty) {
          showChatScreen(context, item);
        } else {
          //clickListener.onClick(111, item);
          showChatScreen(context, item);
        }
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: (item.status == 4 || item.status == 5)
                ? LightColors.kLightGrayM
                : Colors.white,
            boxShadow: const [
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
                padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Ref Id : ${item.mtaskId}',
                        style: const TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF4B39EF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'CRM ID : ${item.projectId}',
                        style: const TextStyle(
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
                  padding: const EdgeInsetsDirectional.all(0),
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
                          style: const TextStyle(
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
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: Image.asset(
                              'assets/icons/ic_starttime.png',
                              width: 14,
                            )),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            item.startDate.isEmpty
                                ? ''
                                : Utility.parseShortDate(item.startDate),
                            style: const TextStyle(
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 0, 0),
                                  child: Image.asset(
                                    'assets/icons/ic_duedate.png',
                                    width: 18,
                                  )),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
                                child: Text(
                                  Utility.parseShortDate(item.endDate),
                                  style: const TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF4B39EF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetColor(int i) {
    for (int index = 0; index < _chipsList.length; index++) {
      _chipsList[index].color = Colors.grey;
    }
    _chipsList[i].color = kPrimaryLightColor;
    mFilter = _chipsList[i].index;
  }
}

class ScheduleCard extends StatelessWidget {
  final String startDate;
  final String endDate;

  const ScheduleCard(
      {super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryLightColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            startDate,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              endDate,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class InProgressCard extends StatelessWidget {
  final String startDate;

  const InProgressCard({super.key, required this.startDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryLightColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            startDate,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
