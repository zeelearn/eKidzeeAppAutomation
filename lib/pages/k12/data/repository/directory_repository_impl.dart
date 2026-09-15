import 'dart:convert';

import 'package:ekidzee/api/APIService.dart';
import 'package:ekidzee/helper/LocalStrings.dart';
import 'package:ekidzee/pages/k12/data/data_sources/folder_remote_data_source.dart';
import 'package:ekidzee/pages/k12/data/models/directory/class_subject_model.dart';
import 'package:ekidzee/pages/k12/data/models/directory/folder_model.dart';
import 'package:ekidzee/pages/k12/domain/repositories/directory_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FolderRepositoryImpl implements FolderRepository {
  late final FolderRemoteDataSource remoteDataSource;

  @override
  Future<FoldersStructureModel> getFolders(String classId, int? subjectId,
      String parentFolderName, int projectId, String userName) async {
    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/GetDirectory'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode({
        'class_name': classId,
        'subject_id': subjectId,
        'ParentFolderName': parentFolderName,
        'ProjectId': projectId,
        'user_name': userName
      }),
    );
    debugPrint('Request is - ${jsonEncode({
          'class_name': classId,
          'subject_id': subjectId,
          'ParentFolderName': parentFolderName,
          'ProjectId': projectId,
          'user_name': userName
        })}');
    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        debugPrint("Response from getdirectory - ${response.body}");
        //final List<dynamic> data = json['data'][0]['Folders'];
        try {
          return FoldersStructureModel.fromJson(json);
        } catch (e) {
          debugPrint('Error in getfolders 1 - $e');
          return FoldersStructureModel(data: []);
        }
      } else {
        return FoldersStructureModel(data: []);
      }
    } catch (e) {
      debugPrint('Error in getfolders - $e');
      return FoldersStructureModel(data: []);
    }
  }

  @override
  Future<ClassSubjectMasterModel> getClassesAndSubjects(
      String businessId, String partnerId) async {
    http.Client client = http.Client();

    final response = await client.post(
      Uri.parse('${LocalStrings.lmsBaseUrl}LMS/Getclasswisesubject'),
      headers: APIService().getNormalHeader1(),
      body: jsonEncode({"business_id": businessId, "partnerid": partnerId}),
    );
    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        ClassSubjectMasterModel model = ClassSubjectMasterModel.fromJson(json);
        return model;
      } else {
        throw Exception('Failed to load classes and subjects');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load classes and subjects');
    }
  }
}
