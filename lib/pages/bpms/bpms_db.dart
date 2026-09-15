import 'package:hive_flutter/adapters.dart';

import '../../api/response/bpms/franchisee_details_response.dart';
import '../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../api/response/bpms/get_communication_response.dart';
import '../../helper/LocalConstant.dart';

class BpmsDB {
  static addFranchiseeInfo(FranchiseeInfoModel model) async {
    var box = await Hive.openBox(
        LocalConstant.authStorageKey); //open the hive box before writing
    var mapUserData = model.toMap(model);
    await box.add(mapUserData);
    box.close();
  }

//   static addACYear(bool is24) async {
//     var box = await Hive.openBox(
//         LocalConstant.authStorageKey); //open the hive box before writing
//     box.put('is24', is24);
//     box.close();
//   }
//
  static Future<bool> getACYear() async {
    bool is24 = false;
    await Hive.initFlutter();
    var box = await Hive.openBox(
        LocalConstant.authStorageKey); //open the hive box before writing
    is24 = (await box.get('is24')) ?? false;
//     debugPrint('is24  -- ${is24}');
    //box.close();
    return is24;
  }

  static addIndent(List<FranchiseeIndentModel> indentList) async {
    await clearAll(LocalConstant.indent);
    var box = await Hive.openBox(
        LocalConstant.indent); //open the hive box before writing
    for (int index = 0; index < indentList.length; index++) {
      var indentData = indentList[index].toMap(indentList[index]);
      await box.add(indentData);
    }
    box.close();
  }

  //Reading all the users data only one data
  static Future<List<FranchiseeIndentModel>> getIndentList() async {
    var box = await Hive.openBox(LocalConstant.indent);
    List<FranchiseeIndentModel> list = [];
    for (int i = box.length - 1; i >= 0; i--) {
      var indentMap = box.getAt(i);
      list.add(FranchiseeIndentModel.fromJson(Map.from(indentMap)));
    }
    return list;
  }

  //Reading all the users data only one data
  static Future<FranchiseeInfoModel?> getFranchiseeInfo() async {
//     debugPrint('getFranchiseeInfo 57');
    var box = await Hive.openBox(LocalConstant.authStorageKey);
    FranchiseeInfoModel? model;
    try {
      for (int i = box.length - 1; i >= 0; i--) {
        var userMap = box.getAt(i);
        try {
          model = FranchiseeInfoModel.fromJson(Map.from(userMap));
        } catch (e) {}
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
//     debugPrint('getFranchiseeInfo 65');
    return model;
  }

  //Reading all the users data only one data
  static Future<List<CommunicationModel>> getCommunication() async {
    var box = await Hive.openBox(LocalConstant.communicationKey);
    List<CommunicationModel> list = [];
    for (int i = box.length - 1; i >= 0; i--) {
      var communicationMap = box.getAt(i);
      list.add(CommunicationModel.fromJson(Map.from(communicationMap)));
    }
    return list;
  }

  static Future<List<TaskDetailModel>> getTaskList() async {
    var box = await Hive.openBox(LocalConstant.taskKey);
    List<TaskDetailModel> list = [];
    for (int i = box.length - 1; i >= 0; i--) {
      var taskMap = box.getAt(i);
      list.add(TaskDetailModel.fromJson(Map.from(taskMap)));
    }
    return list;
  }

  static addCommunication(GetCommunicationResponse communicationModel) async {
    await clearAll(LocalConstant.communicationKey);
    var box = await Hive.openBox(
        LocalConstant.communicationKey); //open the hive box before writing
    for (int index = 0; index < communicationModel.data.length; index++) {
      var mapCommunicationData =
          communicationModel.data[index].toMap(communicationModel.data[index]);
      await box.add(mapCommunicationData);
    }
    box.close();
  }

  static addTaskList(GetTaskDetailsResponseModel taskResponse) async {
    await clearAll(LocalConstant.taskKey);
    var box = await Hive.openBox(
        LocalConstant.taskKey); //open the hive box before writing
    for (int index = 0; index < taskResponse.taskDetail.length; index++) {
      var mapTaskData =
          taskResponse.taskDetail[index].toMap(taskResponse.taskDetail[index]);
      await box.add(mapTaskData);
    }
    box.close();
  }

  static clearAll(String key) async {
    var box = await Hive.openBox(key);
    for (int i = box.length - 1; i >= 0; i--) {
      await box.clear();
    }
  }
}
