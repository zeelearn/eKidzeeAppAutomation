class StudentRatingModel {
  final int teacherId;
  final String userName;
  final int sectionId;
  final List<RatingData> inputData;

  StudentRatingModel({
    required this.teacherId,
    required this.userName,
    required this.sectionId,
    required this.inputData,
  });

  factory StudentRatingModel.fromJson(Map<String, dynamic> json) {
    var list = json['input_data'] as List;
    List<RatingData> inputDataList = list.map((i) => RatingData.fromJson(i)).toList();

    return StudentRatingModel(
      teacherId: json['teacher_id'],
      userName: json['user_name'],
      sectionId: json['section_id'],
      inputData: inputDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': null,
      'user_name': userName,
      'section_id': sectionId,
      'input_data': inputData.map((i) => i.toJson()).toList(),
    };
  }
}

class RatingData {
  final int ccId;
  final int studentId;
  final String rating;

  RatingData({
    required this.ccId,
    required this.studentId,
    required this.rating,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      ccId: json['cc_id'],
      studentId: json['student_id'],
      rating: json['Rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cc_id': ccId,
      'student_id': studentId,
      'Rating': rating,
    };
  }
}
