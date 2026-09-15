import 'package:ekidzee/globals.dart';

class MyHomeworkResponse {
  MyHomeworkResponse({
    required this.success,
    required this.homeworkList,
  });
  late final int success;
  late final List<MyHomeworkModel> homeworkList;

  MyHomeworkResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    homeworkList = List.from(json['data'])
        .map((e) => MyHomeworkModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['data'] = homeworkList.map((e) => e.toJson()).toList();
    return data;
  }
}

class MyHomeworkModel {
  MyHomeworkModel({
    required this.HomeworkID,
    required this.CName,
    required this.AssignedDate,
    required this.Worksheet,
    required this.solution,
    this.notification,
    required this.UploadUrl,
    this.StatusCode,
    this.Remarks,
  });
  late final String HomeworkID;
  late final String CName;
  late final String AssignedDate;
  late final String Worksheet;
  late final String solution;
  late final String? notification;
  String UploadUrl = '';
  late final String? StatusCode;
  late final String? Remarks;

  MyHomeworkModel.fromJson(Map<String, dynamic> json) {
    HomeworkID =
        convertStringJson(json, 'HomeworkID'); //json['HomeworkID'] ?? '';
    CName = convertStringJson(json, 'CName'); //json['CName'] ?? '';
    AssignedDate =
        convertStringJson(json, 'AssignedDate'); //json['AssignedDate'] ?? '';
    Worksheet = convertStringJson(json, 'Worksheet'); //json['Worksheet'] ?? '';
    solution = convertStringJson(json, 'solution'); //json['solution'] ?? '';
    notification =
        convertStringJson(json, 'notification'); //json['notification'] ?? '';
    UploadUrl = convertStringJson(json, 'UploadUrl');
    if (json['Worksheet'].toString().contains('SR_D32_LT_WSH02')) {
//       debugPrint('111${json['Worksheet']}  ${json['UploadUrl']}');
//       debugPrint('111 uploaded ${UploadUrl}');
    }

    StatusCode =
        convertStringJson(json, 'StatusCode'); //json['StatusCode'] ?? '';
    Remarks = convertStringJson(json, 'Remarks'); //json['Remarks'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['HomeworkID'] = HomeworkID;
    data['CName'] = CName;
    data['AssignedDate'] = AssignedDate;
    data['Worksheet'] = Worksheet;
    data['solution'] = solution;
    data['notification'] = notification;
    data['UploadUrl'] = UploadUrl;
    data['StatusCode'] = StatusCode;
    data['Remarks'] = Remarks;
    return data;
  }
}
