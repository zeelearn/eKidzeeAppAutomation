class StudentAttendanceListRequest{
  late final String YearID;
  late final String BatchID;
  late final String TeacherID;
  late final String Date;
  late final String FranchiseeID;


  StudentAttendanceListRequest({
    required this.YearID,
    required this.BatchID,
    required this.TeacherID,
    required this.Date,
    required this.FranchiseeID,
  });

  StudentAttendanceListRequest.fromJson(Map<String, dynamic> json) {
    YearID = json['YearID'];
    BatchID = json['BatchID'];
    TeacherID = json['TeacherID'];
    Date = json['Date'];
    FranchiseeID = json['FranchiseeID'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['BatchID'] = BatchID;
    _data['YearID'] = YearID;
    _data['TeacherID'] = TeacherID;
    _data['Date'] = Date;
    _data['FranchiseeID'] = FranchiseeID;
    return _data;
  }
}