// lib/data/models/student_model.dart

class StudentModel {
  final int studentId;
  final String studentName;
  final int classId;
  final String className;
  final String rating;

  StudentModel({
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.className,
    required this.rating,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['student_id'] ?? '',
      studentName: json['Student_Name'] ?? '',
      classId: json['Class_Id'] ?? 0,
      className: json['Class_Name'] ?? '',
      rating: json['Rating'] ?? '',
    );
  }
}

class StudentsResponse {
  final int success;
  final List<StudentModel> data;

  StudentsResponse({
    required this.success,
    required this.data,
  });

  factory StudentsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
//     debugPrint('---------');
    // debugPrint(list);
    List<StudentModel> studentList =
        list.map((i) => StudentModel.fromJson(i)).toList();

    return StudentsResponse(
      success: json['success'],
      data: studentList,
    );
  }
}
