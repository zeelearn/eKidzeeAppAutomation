// lib/domain/entities/student.dart

class Student {
  final int studentId;
  final String studentName;
  final int classId;
  final String className;
  late String rating;

  Student({
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.className,
    required this.rating,
  });
}
