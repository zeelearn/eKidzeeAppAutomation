import '../../../../globals.dart';

class ParentNoteResponse {
  ParentNoteResponse({
    required this.success,
    required this.parentNoteList,
  });
  late final int success;
  late final List<ParentNoteModel> parentNoteList;

  ParentNoteResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    parentNoteList = List.from(json['data']).map((e)=>ParentNoteModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = parentNoteList.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ParentNoteModel {
  ParentNoteModel({
    required this.HomeworkID,
    required this.CName,
    required this.AssignedDate,
    required this.ParentNote,
  });
  late final String HomeworkID;
  late final String CName;
  late final String AssignedDate;
  late final String ParentNote;

  ParentNoteModel.fromJson(Map<String, dynamic> json){
    HomeworkID = convertStringJson(json, 'HomeworkID');//json['HomeworkID'];
    CName = convertStringJson(json, 'CName');//json['CName'];
    AssignedDate = convertStringJson(json, 'AssignedDate');//json['AssignedDate'];
    ParentNote = convertStringJson(json, 'ParentNote');//json['ParentNote'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['HomeworkID'] = HomeworkID;
    _data['CName'] = CName;
    _data['AssignedDate'] = AssignedDate;
    _data['ParentNote'] = ParentNote;
    return _data;
  }
}