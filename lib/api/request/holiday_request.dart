class HolidayRequest{
  late String AcademicYearId;
  late String FranchiseeId;
  late String UserId;
  HolidayRequest({
    required this.AcademicYearId,
    required this.FranchiseeId,
    required this.UserId,
  });

  HolidayRequest.fromJson(Map<String, dynamic> json) {
    AcademicYearId = json['AcademicYearId'];
    FranchiseeId = json['FranchiseeId'];
    UserId = json['User_Id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['AcademicYearId'] = AcademicYearId;
    _data['FranchiseeId'] = FranchiseeId;
    _data['User_Id'] = UserId;
    return _data;
  }
}