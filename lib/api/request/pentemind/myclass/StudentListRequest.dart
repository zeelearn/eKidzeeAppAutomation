class StudentListRequest{
  late final String User_ID;
  late final int Program_Id;
  late final int D;
  late final String AttendanceDate;


  StudentListRequest({
    required this.User_ID,
    required this.Program_Id,
    required this.AttendanceDate,
    required this.D
  });

  StudentListRequest.fromJson(Map<String, dynamic> json) {
    User_ID = json['User_ID'];
    Program_Id = json['Program_Id'];
    AttendanceDate = json['Remark_Text'];
    D = json['D'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['User_ID'] = User_ID;
    _data['Program_Id'] = Program_Id;
    _data['AttendanceDate'] = AttendanceDate;
    _data['D'] = D;
    return _data;
  }
}