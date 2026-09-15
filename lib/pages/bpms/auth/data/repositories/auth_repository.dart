import 'package:dio/dio.dart';
import 'package:ekidzee/api/request/bpms/franchisee_details_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../api/APIService.dart';
import '../../../../../api/request/bpms/getTaskDetailsRequest.dart';
import '../../../../../api/request/bpms/get_communication.dart';
import '../../../../../api/response/bpms/franchisee_details_response.dart';
import '../../../../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../../../../api/response/bpms/get_communication_response.dart';
import '../../../../../globals.dart';
import '../exceptions/login_exception.dart';

abstract class AuthRepository {
  Future<String> login({
    required String email,
    required String password,
  });

  Future<GetFranchiseeDetailsResponse> getFranchiseeInfo({
    required String franchiseeId,
  });

  Future<GetCommunicationResponse> getCommunication({
    required int franchiseeId,
  });

  Future<GetTaskDetailsResponseModel> getTask({
    required String projectId,
    required String userId,
  });
}

class ApiAuthRepository implements AuthRepository {
  final Dio _dio;

  ApiAuthRepository(this._dio);

  @override
  Future<GetCommunicationResponse> getCommunication(
      {required int franchiseeId}) async {
    try {
//       debugPrint('getCommunication ${franchiseeId}');
      return await APIService().getCommunication(GetCommunicationRequest(
          BusinessId: AppFlavor == 'mlzs' ? 2 : 1, FranchiseeId: franchiseeId));
    } on DioException catch (e) {
      debugPrint(e.message);
      throw LoginException(message: 'Unable to login');
      //return null;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Unable to login');
      //return null;
    }
  }

  @override
  Future<GetTaskDetailsResponseModel> getTask(
      {required String projectId, required String userId}) async {
    try {
      return await APIService().getBPMSTaskDetails(
          GetTaskDetailsRequest(projectID: projectId, UserId: userId));
    } on DioException catch (e) {
      debugPrint(e.message);
      throw LoginException(message: 'Unable to login');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Unable to login');
    }
  }

  @override
  Future<GetFranchiseeDetailsResponse> getFranchiseeInfo(
      {required String franchiseeId}) async {
    try {
//       debugPrint('getFranchiseeInfo 74');
      GetFranchiseeDetailsRequest request =
          GetFranchiseeDetailsRequest(franchiseeId: franchiseeId);
      GetFranchiseeDetailsResponse response =
          await APIService().getFranDetailInfo(request);
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      throw LoginException(message: 'Unable to login');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Unable to login');
    }
  }

  @override
  Future<String> login(
      {required String email, required String password}) async {
    const url = 'https://reqres.in/api/login';

    try {
      final data = {
        'email': email,
        'password': password,
      };

      final response = await _dio.post(url, data: data);

      final token = response.data['token'] as String;
      return token;
    } on DioException {
      throw LoginException(message: 'Unable to login');
    } catch (e) {
      throw Exception('Unable to login');
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(Dio());
});
