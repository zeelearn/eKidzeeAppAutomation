// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../../api/response/bpms/franchisee_details_response.dart';
import '../../../../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../../../../api/response/bpms/get_communication_response.dart';
import '../enums/auth_status.dart';

class AuthState {
  final FranchiseeInfoModel? user;
  final List<CommunicationModel>? communicationList;
  List<FranchiseeIndentModel>? indentList;
  List<TaskDetailModel>? taskModelList;
  final AuthStatus status;
  final String? errorMessage;
  final bool loading;
  int action=0;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  AuthState({
    this.user,
    this.communicationList,
    this.indentList,
    this.taskModelList,
    this.action =0,
    this.status = AuthStatus.unknown,
    this.errorMessage,
    this.loading = false,
  });

  AuthState copyWith({
    FranchiseeInfoModel? user,
    List<CommunicationModel>? communicationList,
    List<FranchiseeIndentModel>? indentList,
    List<TaskDetailModel>? taskModelList,
    AuthStatus? status,
    String? errorMessage,
    bool? loading,
    int? action,
  }) {
    return AuthState(
      user: user ?? this.user,
      communicationList : communicationList ?? this.communicationList,
      indentList : indentList ?? this.indentList,
      taskModelList : taskModelList ?? this.taskModelList,
      action: action ?? this.action,
      status: status ?? this.status,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory AuthState.initial() {
    return AuthState(
      status: AuthStatus.unknown,
      communicationList : [],
      indentList : [],
      taskModelList : [],
      user: null,
      errorMessage: null,
      loading: false,
      action: 1,
    );
  }

  @override
  String toString() =>
      'status $status accessToken user ${user.toString()} ';
}
