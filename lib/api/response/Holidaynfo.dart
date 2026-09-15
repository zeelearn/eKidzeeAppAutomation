class HolidayInfo{

  late List<HolidayInfoModel> data;

  HolidayInfo({ required this.data});

  HolidayInfo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HolidayInfoModel>[];
      json['data'].forEach((v) {
        data.add(HolidayInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}
class HolidayInfoModel {
  late int holidayListId;
  late int franchiseeId;
  late int academicyearId;
  late String academicYearName;
  late String description;
  late String fromDate;
  late String toDate;
  late bool isActive;
  late String createdBy;
  late String createdDate;
  late bool isStudent;
  late bool isStaff;
  late String holidayTypeCode;
  late String? holidayTypeName;

  HolidayInfoModel(
      {required this.holidayListId,
        required this.franchiseeId,
        required this.academicyearId,
        required this.academicYearName,
        required this.description,
        required this.fromDate,
        required this.toDate,
        required this.isActive,
        required this.createdBy,
        required this.createdDate,
        required this.isStudent,
        required this.isStaff,
        required this.holidayTypeCode,
        required this.holidayTypeName});

  HolidayInfoModel.fromJson(Map<String, dynamic> json) {
    holidayListId = json['HolidayList_Id'];
    franchiseeId = json['Franchisee_Id'];
    academicyearId = json['AcademicyearId'];
    academicYearName = json['AcademicYearName'];
    description = json['Description'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    isActive = json['Is_Active'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    isStudent = json['isStudent'];
    isStaff = json['isStaff'];
    holidayTypeCode = json['HolidayTypeCode'];
    holidayTypeName = json['HolidayTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HolidayList_Id'] = this.holidayListId;
    data['Franchisee_Id'] = this.franchiseeId;
    data['AcademicyearId'] = this.academicyearId;
    data['AcademicYearName'] = this.academicYearName;
    data['Description'] = this.description;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['Is_Active'] = this.isActive;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['isStudent'] = this.isStudent;
    data['isStaff'] = this.isStaff;
    data['HolidayTypeCode'] = this.holidayTypeCode;
    data['HolidayTypeName'] = this.holidayTypeName;
    return data;
  }
}