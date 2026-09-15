class AttendanceInfo{

  late List<AttendanceInfoModel> data;

  AttendanceInfo({ required this.data});

  AttendanceInfo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AttendanceInfoModel>[];
      json['data'].forEach((v) {
        data.add(AttendanceInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}
class AttendanceInfoModel {
  AttendanceInfoModel({
    required this.CalendarDate,
    this.IsPresent,
    this.IsSMSSent,
    this.IsHoliday,
    this.IsWeekend,
    this.TeacherId,
    this.TeacherName,
    this.MiddleName,
    this.Surname,
    this.IsLateMark,
  });
  late final String CalendarDate;
  late final int? IsPresent;
  late final int? IsSMSSent;
  late final int? IsHoliday;
  late final int? IsWeekend;
  late final int? TeacherId;
  late final String? TeacherName;
  late final String? MiddleName;
  late final String? Surname;
  late final int? IsLateMark;

  AttendanceInfoModel.fromJson(Map<String, dynamic> json){
    CalendarDate = json['CalendarDate'];
    IsPresent = json['IsPresent'];
    IsSMSSent = json['IsSMSSent'];
    IsHoliday = json['IsHoliday'];
    IsWeekend = json['IsWeekend'];
    TeacherId = json['TeacherId'];
    TeacherName = json['TeacherName'];
    MiddleName = json['MiddleName'];
    Surname = json['Surname'];
    IsLateMark = json['IsLateMark'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CalendarDate'] = CalendarDate;

    _data['IsPresent'] = IsPresent;
    _data['IsSMSSent'] = IsSMSSent;
    _data['IsHoliday'] = IsHoliday;
    _data['IsWeekend'] = IsWeekend;
    _data['TeacherId'] = TeacherId;
    _data['Teacher_Name'] = TeacherName;
    _data['Middle_Name'] = MiddleName;
    _data['Surname'] = Surname;
    _data['IsLateMark'] = IsLateMark;
    return _data;
  }
}