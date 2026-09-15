import 'dart:convert';

class GetAnnoucementRequest {
  late final bool isKes;
  late final String TeacherID;
  late final String Program_Id;
  late final String StudentID;
  late final String UserType;
  late final int PageIndex;
  late final int PageRec;
  late final String RequestType;
  late final String userName;

  GetAnnoucementRequest.KES({
    required this.userName,
    required this.Program_Id,
  }) : isKes = true;

  GetAnnoucementRequest({
    required this.TeacherID,
    required this.Program_Id,
    required this.UserType,
    required this.StudentID,
    required this.PageIndex,
    required this.PageRec,
    required this.RequestType,
  }) : isKes = false;

  toJson() {
    return jsonEncode(isKes
        ? {"username": userName, "section_id": Program_Id}
        : {
            'TeacherID': TeacherID,
            'Program_Id': Program_Id,
            'UserType': UserType,
            'StudentID': StudentID,
            'PageIndex': PageIndex,
            'PageRec': PageRec,
            'RequestType': RequestType,
          });
  }

  GetAnnoucementRequest.fromJson(Map<String, dynamic> json,
      {required bool kes}) {
    isKes = kes;
    TeacherID = json['TeacherID'];
    Program_Id = json['Program_ID'];
    UserType = json['UserType'];
    StudentID = json['StudentID'];
    PageIndex = json['PageIndex'];
    PageRec = json['PageRec'];
    PageRec = json['RequestType'];
  }
}
