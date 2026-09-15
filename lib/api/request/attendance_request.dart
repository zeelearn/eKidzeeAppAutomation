class AttendanceRequest{
  late final String ParentId;
  late final String Month;
  late final String Year;


  AttendanceRequest({
    required this.ParentId,
    required this.Year,
    required this.Month,
  });

  AttendanceRequest.fromJson(Map<String, dynamic> json) {
    ParentId = json['ParentId'];
    Year = json['Year'];
    Month = json['Month'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ParentId'] = ParentId;
    _data['Year'] = Year;
    _data['Month'] = Month;
    return _data;
  }
}