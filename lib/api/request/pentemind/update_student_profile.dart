import 'dart:convert';

class UpdateStudentProfileRequest {
  UpdateStudentProfileRequest({
    required this.StudentId,
    required this.studentprofileURL,
  });
  late final int StudentId;
  late final String studentprofileURL;

  UpdateStudentProfileRequest.fromJson(Map<String, dynamic> json){
    StudentId = json['Student_Id'];
    studentprofileURL = json['studentprofileURL'];
  }

  toJson() {
    return jsonEncode({
      'Student_Id': this.StudentId,
      'studentprofileURL': this.studentprofileURL,
    });
  }

}