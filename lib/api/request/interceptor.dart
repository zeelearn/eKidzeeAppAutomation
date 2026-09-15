import 'dart:async';
import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/LocalConstant.dart';
import '../../model/user_model.dart';
import '../../pages/login/ui2/login.dart';
import 'login_model.dart';

class InterceptedClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    debugPrint('sending api request $request');
    final response = await _inner.send(request);
    debugPrint(
        'Response from api is - ${response.statusCode} - ${response.stream.toString()}');

    if (response.statusCode == 401) {
      debugPrint('in 23 status code 401');
      try {
        var prefs = await SharedPreferences.getInstance();

        String token =
            prefs.getString(LocalConstant.KEY_APP_TOKEN) as String ?? '';
        // debugPrint('in 27 getToken ${token}');
        String userName =
            prefs.getString(LocalConstant.KEY_USER_NAME) as String ?? '';
        String paswword =
            prefs.getString(LocalConstant.KEY_USER_PASSWORD) as String ?? '';
        final loginRequestModel = LoginRequestModel(
          User_Name: userName,
          User_Password: paswword,
          Device_id: '',
          Otp: '',
        );
        APIService apiService = APIService();
        final apiResult = await apiService.secureLogin(loginRequestModel);
        if (apiResult != null) {
          if (apiResult is SecureLoginResponseModel && apiResult.data != null) {
            //KidzeePref().setString(LocalConstant.KEY_APP_TOKEN, 'true');
            await prefs.setString(
                LocalConstant.KEY_APP_TOKEN, apiResult.token! ?? "");
            token = apiResult.token!;
            final retryRequest = _cloneRequest(request);
            retryRequest.headers['Authorization'] = 'Bearer $token';
            return _inner.send(retryRequest);
          } else {
            //Invalid user
            Get.offAll(LoginScreenV2());
          }
        } else {
          Get.offAll(LoginScreenV2());
          // Utility.hideDialog(context);
          // Utility.alert(context, 'Alert', "Something went wrong, please try again later", this);
        }
        //final refreshed = await _refreshAccessToken(token);

//           if (refreshed) {
//             final retryRequest = _cloneRequest(request);
//             retryRequest.headers['Authorization'] = 'Bearer $token';
//             return _inner.send(retryRequest);
//           } else {
// //         debugPrint('Refresh Token failed');
//             // await Utility.clearData();
//             Get.offAll(KidzeeLogin());
//           }
      } catch (e) {
        debugPrint('e ${e.toString()}');
      }
    }
    debugPrint('response $response');
    return response;
  }

  /// Refresh token API
  Future<bool> _refreshAccessToken(token) async {
    try {
      final refreshResponse = await _inner.post(
        Uri.parse('https://example.com/auth/refresh'),
        headers: APIService().getNormalHeader1(),
        body: jsonEncode({'refresh_token': token}),
      );

      if (refreshResponse.statusCode == 200) {
        final data = jsonDecode(refreshResponse.body);
        var prefs = await SharedPreferences.getInstance();

        prefs.setString(LocalConstant.KEY_APP_TOKEN, data['access_token'])
            as String;
        token = data['access_token'];
        return true;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    return false;
  }

  /// Clone request so we can retry
  http.BaseRequest _cloneRequest(http.BaseRequest request) {
    final newRequest = http.Request(request.method, request.url)
      ..headers.addAll(request.headers);

    if (request is http.Request) {
      newRequest.bodyBytes = request.bodyBytes;
    }
    return newRequest;
  }
}
