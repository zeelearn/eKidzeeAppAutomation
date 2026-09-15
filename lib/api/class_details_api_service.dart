import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:ekidzee/api/response/pentemind/learninggoals/uploadimage.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as httpfile;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../helper/KidzeePref.dart';
import '../helper/LocalStrings.dart';
import '../model/class_info_model.dart';

class ClassDetailsApiService {
  static String baseUrl = 'https://kubapi.zeelearn.com/V1/pentemind/2025/';

  //https://kubapi.zeelearn.com/V1/pentemind/2025/api/common/IUClassInfo

  Future<ClassInfoModel?> fetchClassInfo({
    required int franchiseeId,
    required int programId,
    required String yearId,
  }) async {
    baseUrl = await getBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/api/common/Getclassinfo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "franchiseid": franchiseeId.toString(),
        "programid": programId,
      }),
    );

    final body = jsonDecode(response.body);

    // if (response.statusCode == 200 && body['success'] == 200) {
    //   return ClassInfoModel.fromJson(body['data'][0]);
    // }
    if (response.statusCode == 200 && body['success'] == 200) {
      List dataList = body['data'];

      var latest = dataList.reduce((a, b) => a['InfoId'] > b['InfoId'] ? a : b);

      return ClassInfoModel.fromJson(latest);
    }
    return null;
  }

  Future<String> getBaseUrl() async {
    int academicYear = await KidzeePref().getAcademicYear();

    String url = LocalStrings.development24;
    switch (academicYear) {
      case 24:
        url = LocalStrings.development24;
        break;
      case 25:
        url = LocalStrings.pentemindapi;
        break;
      case 26:
        url = LocalStrings.pentemindapi26;
        break;
      default:
        url = LocalStrings.pentemindapi;
        break;
    }
    return url;
  }

  Future<bool> submitClassDetails(Map<String, dynamic> payload) async {
    baseUrl = await getBaseUrl();

    final response = await http.post(
      Uri.parse('$baseUrl/api/common/IUClassInfo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final body = jsonDecode(response.body);
    return response.statusCode == 200 && body['success'] == 200;
  }

  Future<PlatformFile> convertXFileToPlatformFile(XFile xFile) async {
    // Read bytes first to ensure they are available for web/mobile
    final bytes = await xFile.readAsBytes();

    return PlatformFile(
      name: xFile.name,
      path: xFile.path,
      size: await xFile.length(),
      bytes: bytes,
    );
  }

  Future<UploadImageResponse> uploadImage(String userId, XFile file,
      {bool isVideoFile = false,
      Function(int bytes, int totalBytes)? progress}) async {
    try {
      PlatformFile image = await convertXFileToPlatformFile(file);
      final Uri postUri = Uri.parse(LocalStrings.API_FILE_UPLOAD);
      final request = httpfile.MultipartRequest('POST', postUri);

      /// Add additional fields if required
      //request.fields['user_id'] = userId;

      httpfile.MultipartFile multipartFile;

      /// ==============================
      /// 🌐 WEB HANDLING
      /// ==============================
      if (kIsWeb) {
        final mimeType =
            lookupMimeType(file.name) ?? 'application/octet-stream';
        debugPrint('Mime type  web is $mimeType');
        final typeParts = mimeType.split('/');
        request.files.add(http.MultipartFile.fromBytes(
            'inputFile', // Field name expected by the API
            await file.readAsBytes(),
            filename: file.name,
            contentType: MediaType(typeParts[0], typeParts[1])));
      }

      /// ==============================
      /// 📱 MOBILE (Android / iOS)
      /// ==============================
      else {
        final mimeType =
            lookupMimeType(file.name) ?? 'application/octet-stream';
        debugPrint('Mime type NON web is $mimeType');
        final typeParts = mimeType.split('/');

        request.files.add(await http.MultipartFile.fromPath(
            'inputFile', file.path,
            contentType: MediaType(typeParts[0], typeParts[1])));
      }

      try {
        var response = await request.send().timeout(const Duration(minutes: 2));
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        debugPrint('Response OK ${response.statusCode}');
        debugPrint('Response $responseString');
        // listener?.onClick(
        //     Utility.ACTION_ALERT_OK,
        //     UploadImageResponse.fromJson(
        //       json.decode(responseString) as Map<String, dynamic>,
        //     ));

        return UploadImageResponse.fromJson(
          json.decode(responseString) as Map<String, dynamic>,
        );
      } catch (e) {
        // debugPrint(e);
        debugPrint('error');
        debugPrint(e.toString());
        //listener?.onClick(Utility.ACTION_REJECT, e.toString());
        return UploadImageResponse(imageModel: [], message: '');
      }
    } catch (e) {
      debugPrint("Upload Error: $e");

      // listener?.onClick(
      //   Utility.ACTION_IMAGE_UPLOAD_RESPONSE_ERROR,
      //   e.toString(),
      // );

      return UploadImageResponse(imageModel: [], message: '');
    }
  }
}
