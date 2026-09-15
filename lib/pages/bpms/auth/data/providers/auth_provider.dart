import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api/response/bpms/franchisee_details_response.dart';
import '../../../../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../../../../api/response/bpms/get_communication_response.dart';
import '../../../../../helper/utils.dart';
import '../../../bpms_db.dart';
import '../enums/auth_status.dart';
import '../exceptions/login_exception.dart';
import '../models/auth_state.dart';
import '../repositories/auth_repository.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repo);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthStateNotifier(this._repo, [AuthState? state])
      : super(state ?? AuthState.initial()) {
    checkAuthStatus();
  }

  Future<String> getFranchiseeInfo() async {
//     debugPrint('getFranchiseeInfo');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
    //crnNumber = (prefs.getString(LocalConstant.KEY_CRNNO) as String) ?? '';
    //userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
  }

  Future<List<CommunicationModel>> getCommunication(int franchiseeId) async {
    List<CommunicationModel> communicationList =
        await BpmsDB.getCommunication();
    if (communicationList.isEmpty || await Utility.isInternet()) {
      final communicationResponse =
          await _repo.getCommunication(franchiseeId: franchiseeId);
      await BpmsDB.addCommunication(communicationResponse);
      return communicationResponse.data;
    } else {
      return communicationList;
    }
  }

  Future<List<TaskDetailModel>> getTaskDetails(
      String projectId, String userId) async {
    List<TaskDetailModel> taskList = await BpmsDB.getTaskList();
    //debugPrint('task Details are ${taskList.length}');
    if (taskList.isEmpty || await Utility.isInternet()) {
      final taskResponse =
          await _repo.getTask(projectId: projectId, userId: userId);
      await BpmsDB.addTaskList(taskResponse);
      return taskResponse.taskDetail;
    } else {
      return taskList;
    }
  }

  Future<List<FranchiseeIndentModel>> getIndentList(String franchiseeId) async {
    List<FranchiseeIndentModel> indentList = await BpmsDB.getIndentList();
    if (indentList.isEmpty) {
      return [];
    } else {
      return indentList;
    }
  }

  Future<void> refreshCommunication() async {
    List<CommunicationModel> communicationist =
        await getCommunication(state.user!.FranchiseeId);
    state = state.copyWith(
      status: AuthStatus.authenticated,
      communicationList: communicationist,
    );
    return;
  }

  Future<void> refreshTask() async {
//     debugPrint('task refresh...refreshTask');
    FranchiseeInfoModel? franshiseeInfo = await BpmsDB.getFranchiseeInfo();
    if (franshiseeInfo != null) {
//       debugPrint('task refresh...Franc not null');
      state = state.copyWith(status: AuthStatus.loading, loading: true);
      final taskResponse = await _repo.getTask(
          projectId: franshiseeInfo.leadId,
          userId: franshiseeInfo.FranchiseeId.toString());
      await BpmsDB.addTaskList(taskResponse);
      state = state.copyWith(
          status: AuthStatus.authenticated,
          taskModelList: taskResponse.taskDetail,
          loading: false);
    } else {
//       debugPrint('task refresh...Franc is NULL');
    }
//     debugPrint('task refresh...DONE');
    return;
  }

  void isLoading(AuthStatus isLoading) {
    state = state.copyWith(
      status: isLoading,
    );
  }

  Future<void> checkAuthStatus() async {
    // check storage for existing token/user
//     debugPrint('checkAuthStatus');
    String franchiseeId = await getFranchiseeInfo();
    FranchiseeInfoModel? franshiseeInfo = await BpmsDB.getFranchiseeInfo();
//     debugPrint('checkAuthStatus');
    if (await Utility.isInternet()) {
//       debugPrint('internet avaliable');
      state = state.copyWith(status: AuthStatus.loading, user: null);
      getFranchiseeDetailInfo(franchiseeId: franchiseeId);
      return;
    } else if (franshiseeInfo != null) {
      getFranchiseeDetailInfo(franchiseeId: franchiseeId);
      return;
    } else if (franshiseeInfo == null) {
      state = state.copyWith(status: AuthStatus.loading, user: null);
      getFranchiseeDetailInfo(franchiseeId: franchiseeId);
      return;
    }
    state = state.copyWith(
      status: AuthStatus.unknown,
    );
  }

  Future<void> getFranchiseeDetailInfo({required String franchiseeId}) async {
//     debugPrint('getFranchiseeDetailInfo');
    try {
      state = state.copyWith(
        loading: true,
        errorMessage: '',
      );
      final franchiseeResponse =
          await _repo.getFranchiseeInfo(franchiseeId: franchiseeId);
//       debugPrint('getFranchiseeDetailInfo franchiseeResponse');
      List<CommunicationModel> communicationist = await getCommunication(
          franchiseeResponse.franchiseeInfoModel[0].FranchiseeId);
//       debugPrint('getFranchiseeDetailInfo communicationist');
      GetFranchiseeDetailsResponse franchiseeResponseModel =
          GetFranchiseeDetailsResponse.fromJson(
              json.decode(franchiseeResponse.toJsonValue()));
//       debugPrint('getFranchiseeDetailInfo franchiseeResponseModel');
      List<TaskDetailModel> taskList = await getTaskDetails(
          franchiseeResponseModel.franchiseeInfoModel[0].leadId, '1');
//       debugPrint('getFranchiseeDetailInfo taskList');
      state = state.copyWith(
        loading: false,
        user: franchiseeResponseModel.franchiseeInfoModel[0],
        communicationList: communicationist,
        indentList: franchiseeResponseModel.indentList,
        taskModelList: taskList,
        status: AuthStatus.authenticated,
        errorMessage: '',
      );
//       debugPrint('getFranchiseeDetailInfo taskList state change');
      if (state.user != null) await BpmsDB.addFranchiseeInfo(state.user!);
      if (franchiseeResponse.indentList.isNotEmpty)
        await BpmsDB.addIndent(franchiseeResponse.indentList);
    } on DioException catch (e) {
//       debugPrint('DioException 87...');
      final exc = LoginException.fromDioError(e);
      state = state.copyWith(
        errorMessage: exc.message,
      );
    } catch (e) {
//       debugPrint('DioException 93...${e.toString()}');
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    } finally {
      state = state.copyWith(
        loading: false,
      );
    }
  }

  Future<void> logout() async {
    debugPrint('logout from bpms');
    state = state.copyWith(
      loading: true,
      errorMessage: '',
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // do some API stuff
    await Future.delayed(const Duration(milliseconds: 300));
    await Hive.openBox(LocalConstant.authStorageKey);
    final box = Hive.box(LocalConstant.authStorageKey);
    await box.delete('token');
    await box.delete('user');

    /*state = state.copyWith(
      user: null,
      status: AuthStatus.unauthenticated,
      loading: false,
    );*/
    if (kIsWeb) {
    } else if (!kIsWeb && Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 100), () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      });
    } else if (kIsWeb || Platform.isIOS) {
      exit(0);
    }
  }

  Future<void> changepage(int page) async {
    /*state = state.copyWith(
      action: page,
      loading: true
    );*/
    // debugPrint(page);
    await Future.delayed(const Duration(milliseconds: 50));
    state = state.copyWith(
        user: null,
        status: AuthStatus.authenticated,
        loading: false,
        action: page);
  }

  Future<void> updateMessage(TaskDetailModel taskModel, String comment) async {
    List<TaskDetailModel> taskList = await BpmsDB.getTaskList();
    for (int index = 0; index < taskList.length; index++) {
      if (taskList[index].mtaskId == taskModel.mtaskId) {
        taskList[index].latestComment = comment;
      }
    }
    GetTaskDetailsResponseModel response =
        GetTaskDetailsResponseModel(success: 200, taskDetail: taskList);
    await BpmsDB.addTaskList(response);
  }
}
