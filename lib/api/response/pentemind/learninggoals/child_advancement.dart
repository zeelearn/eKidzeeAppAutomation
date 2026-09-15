import '../../../../globals.dart';

class ChildAdvancementResponse {
  late int success;
  late List<ChildAdvancementModel> advancementModelList;

  ChildAdvancementResponse({required this.success, required this.advancementModelList});

  ChildAdvancementResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      advancementModelList = <ChildAdvancementModel>[];
      json['data'].forEach((v) {
        advancementModelList.add(new ChildAdvancementModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.advancementModelList.map((v) => v.toJson()).toList();
      return data;
  }
}

class ChildAdvancementModel {
  late int studentID;
  late String studentName;
  late String studentprofileURL;
  late bool iSphoto;
  late List<Advancement> advancement;

  ChildAdvancementModel({required this.studentID,required this.studentName,required this.iSphoto,required this.studentprofileURL, required this.advancement});

  ChildAdvancementModel.fromJson(Map<String, dynamic> json) {
    studentID = convertintJson(json, 'StudentID');//json['StudentID'];
    studentName = convertStringJson(json, 'Student_Name');//json['Student_Name'];
    studentprofileURL = convertStringJson(json, 'studentprofileURL');//json['Student_Name'];
    iSphoto = convertBoolJson(json, 'Isphoto');//json['Student_Name'];
    if (json['Advancement'] != null) {
      advancement = <Advancement>[];
      json['Advancement'].forEach((v) {
        advancement.add(new Advancement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentID'] = this.studentID;
    data['Student_Name'] = this.studentName;
    data['Advancement'] = this.advancement.map((v) => v.toJson()).toList();
      return data;
  }
}

class Advancement {
  String? refKey;
  String? term;
  String? refValue;

  Advancement({this.refKey, this.term, this.refValue});

  Advancement.fromJson(Map<String, dynamic> json) {
    refKey = convertStringJson(json, 'RefKey');//json['RefKey'];
    term = convertStringJson(json, 'Term');//json['Term'];
    refValue = convertStringJson(json, 'RefValue');//json['RefValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RefKey'] = this.refKey;
    data['Term'] = this.term;
    data['RefValue'] = this.refValue;
    return data;
  }
}
