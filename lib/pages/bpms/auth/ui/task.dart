import 'package:ekidzee/api/response/bpms/getTaskDetailsResponseModel.dart';
import 'package:ekidzee/constants.dart';
import 'package:ekidzee/helper/LightColor.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app_routes.dart';
import '../../../../helper/utils.dart';
import '../../../centersetup/indent_history.dart';
import '../data/providers/auth_provider.dart';

class Tasks extends StatelessWidget {
  List<TaskDetailModel> taskModelList = [];
  WidgetRef ref;

  final List<Filters> _chipsList = [
    Filters('All', 0, kPrimaryLightColor, false),
    Filters('Pending', 1, LightColor.grey, false),
    Filters('Completed', 2, LightColor.grey, false),
    Filters('Completed', 3, LightColor.grey, false)
  ];

  Tasks(this.ref, this.taskModelList, {super.key});

  @override
  Widget build(BuildContext context) {
    return taskModelList.isEmpty
        ? Utility.emptyDataSet(
            context,
          )
        : Flexible(
            child: ListView.builder(
            itemCount: taskModelList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (taskModelList[index].statusname == 'Pending') {
                return getPendingView(context, taskModelList[index]);
              } else {
                return getView(context, taskModelList[index]);
              }
            },
          ));
  }

  showChatScreen(BuildContext context, TaskDetailModel taskModel) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return goToChatPage(taskModel: taskModel);
    }));
//     debugPrint('showChatScreen ------notifier-----------$result');
    ref.read(authNotifierProvider.notifier).refreshTask();
//     debugPrint('showChatScreen ------notifier---END--------');
  }

  Widget getView(BuildContext context, TaskDetailModel taskModel) {
    return GestureDetector(
      onTap: () {
        showChatScreen(context, taskModel);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        decoration: BoxDecoration(
            color: taskModel.statusname.toLowerCase().contains('bp completed')
                ? Colors.white
                : taskModel.statusname.toLowerCase().contains('completed')
                    ? Colors.white
                    : taskModel.statusname.toLowerCase().contains('progress')
                        ? LightColors.kLightYellow
                        : LightColors.kLightGray1,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26.withOpacity(0.05),
                  offset: const Offset(0.0, 6.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.10)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FadeInImage(
                          width: 24,
                          placeholder:
                              const AssetImage('assets/icons/ic_pending.png'),
                          image: AssetImage(
                              'assets/icons/${taskModel.statusname.toLowerCase().contains('completed') ? 'ic_task_comp' : taskModel.statusname == 'In Progress' ? 'ic_task_inprogress' : 'ic_pending'}.png'),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/icons/ic_pending.png',
                                fit: BoxFit.fitWidth);
                          },
                          fit: BoxFit.cover,
                        ),
                        /* CircleAvatar(
                                  backgroundImage: AssetImage('assets/icons/${taskModel.statusname.toLowerCase()=='completed' ? 'ic_task_comp' : taskModel.statusname=='In Progress' ? 'ic_task_inprogress' : 'ic_pending'}.png') */ /*AssetImage(question.author.imageUrl)*/ /*,
                                  radius: 22,
                                ),*/
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  taskModel.title,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.56,
                                child: Text(
                                  "Last Comment : ${taskModel.latestComment}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.0,
                                    color: Colors.black87,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      taskModel.statusname,
                      style: GoogleFonts.roboto(
                        background: Paint()
                          ..color = taskModel.statusname
                                  .toLowerCase()
                                  .contains('bp completed')
                              ? LightColors.kLightGreenMaterial
                              : taskModel.statusname
                                      .toLowerCase()
                                      .contains('completed')
                                  ? LightColors.kGreen
                                  : taskModel.statusname
                                          .toLowerCase()
                                          .contains('progress')
                                      ? LightColors.kLightYellow2
                                      : LightColors.kLightGray1
                          ..strokeWidth = 18
                          ..strokeJoin = StrokeJoin.round
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke,
                        fontSize: 12.0,
                        color: taskModel.statusname.toLowerCase() == 'completed'
                            ? Colors.white
                            : taskModel.statusname
                                    .toLowerCase()
                                    .contains('completed')
                                ? Colors.black
                                : Colors.black87,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Divider(
                color: LightColor.lightGrey,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.calendar_today,
                        color: LightColors.kLightGray1,
                        size: 12,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "Start At : ${Utility.parseShortDate(taskModel.startDate)}",
                        style: GoogleFonts.roboto(
                          fontSize: 12.0,
                          color: Colors.black87,
                          height: 1,
                        ),
                      )
                    ],
                  ),
                  taskModel.statusname.toLowerCase().contains('completed')
                      ? Row(
                          children: <Widget>[
                            const Icon(
                              Icons.calendar_today,
                              color: LightColors.kLightGray1,
                              size: 12,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              "Completed At : ${Utility.parseShortDate(taskModel.endDate)}",
                              style: GoogleFonts.roboto(
                                fontSize: 12.0,
                                color: Colors.black87,
                                height: 1,
                              ),
                            )
                          ],
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getTaskImage(TaskDetailModel taskModel) {
    return FadeInImage(
      width: 24,
      placeholder: const AssetImage('assets/icons/ic_pending.png'),
      image: AssetImage(
          'assets/icons/${taskModel.statusname.toLowerCase() == 'completed' ? 'ic_task_comp' : taskModel.statusname == 'In Progress' ? 'ic_task_inprogress' : 'ic_pending'}.png'),
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/icons/ic_pending.png', fit: BoxFit.fitWidth);
      },
      fit: BoxFit.cover,
    );
  }

  Widget getPendingView(BuildContext context, TaskDetailModel taskModel) {
    return GestureDetector(
      onTap: () {
        showChatScreen(context, taskModel);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26.withOpacity(0.05),
                  offset: const Offset(0.0, 6.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.10)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        getTaskImage(taskModel),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  taskModel.title,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      taskModel.statusname,
                      style: GoogleFonts.roboto(
                        background: Paint()
                          ..color = LightColors.kLightGray1
                          ..strokeWidth = 18
                          ..strokeJoin = StrokeJoin.round
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke,
                        fontSize: 12.0,
                        color: taskModel.statusname
                                .toLowerCase()
                                .contains('completed')
                            ? Colors.white
                            : Colors.black87,
                        height: 1,
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
}
