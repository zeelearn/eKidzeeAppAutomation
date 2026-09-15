class StudentKesAttandanceResponse {
  int? success;
  List<StudentKesAttandance>? data;

  StudentKesAttandanceResponse({this.success, this.data});

  StudentKesAttandanceResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <StudentKesAttandance>[];
      json['data'].forEach((v) {
        data!.add(new StudentKesAttandance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentKesAttandance {
  int? teacherId;
  int? studentId;
  String? studentName;
  int? classId;
  String? className;
  int? isPresent;

  StudentKesAttandance(
      {this.teacherId,
      this.studentId,
      this.studentName,
      this.classId,
      this.className,
      this.isPresent});

  StudentKesAttandance.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacher_id'];
    studentId = json['student_id'];
    studentName = json['Student_Name'];
    classId = json['Class_Id'];
    className = json['Class_Name'];
    isPresent = json['is_present'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teacher_id'] = this.teacherId;
    data['student_id'] = this.studentId;
    data['Student_Name'] = this.studentName;
    data['Class_Id'] = this.classId;
    data['Class_Name'] = this.className;
    data['is_present'] = this.isPresent;
    return data;
  }
}
