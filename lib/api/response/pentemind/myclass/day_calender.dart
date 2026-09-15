class DayCalenderResponse {
  DayCalenderResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final Data data;

  DayCalenderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final data1 = <String, dynamic>{};
    data1['success'] = success;
    data1['data'] = data.toJson();
    return data1;
  }
}

class Data {
  Data({
    required this.CulDay,
    required this.FloatingDay,
  });
  late final List<CuminationDayModel> CulDay;
  late final List<CuminationDayModel> FloatingDay;

  Data.fromJson(Map<String, dynamic> json) {
    CulDay = List.from(json['CulDay'])
        .map((e) => CuminationDayModel.fromJson(e))
        .toList();
    FloatingDay = json.containsKey('FloatingDay')
        ? List.from(json['FloatingDay'])
            .map((e) => CuminationDayModel.fromJson(e))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['CulDay'] = CulDay.map((e) => e.toJson()).toList();
    data['FloatingDay'] = FloatingDay.map((e) => e.toJson()).toList();
    return data;
  }
}

class CuminationDayModel {
  CuminationDayModel({
    required this.Cid,
    required this.CName,
    required this.AttendanceDate,
    required this.D,
    required this.W,
    required this.IsDisabled,
  });
  late final int Cid;
  late final String CName;
  late String AttendanceDate;
  late final String remark;
  late final int D;
  late final int W;
  bool IsDisabled = false;

  CuminationDayModel.fromJson(Map<String, dynamic> json) {
    try {
      Cid = json['Cid'];
      CName = json['CName'] ?? '';
      AttendanceDate = json['AttendanceDate'] ?? '';
      D = json['D'] ?? 0;
      remark = json.containsKey('remarks') ? json['remarks'] ?? '' : '';
      W = json['W'] ?? 0;
      IsDisabled = json['IsDisabled'] ?? false;
    } catch (e) {
      // debugPrint('exception in fromJson ' + e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Cid'] = Cid;
    data['CName'] = CName;
    data['AttendanceDate'] = AttendanceDate;
    data['D'] = D;
    data['remarks'] = remark;
    data['W'] = W;
    data['IsDisabled'] = IsDisabled;
    return data;
  }
}

class FloatingDayModel {
  FloatingDayModel({
    required this.Cid,
    required this.CName,
    required this.AttendanceDate,
    required this.remarks,
    required this.D,
    required this.IsDisabled,
  });
  late final int Cid;
  late final String CName;
  late final String AttendanceDate;
  late final String remarks;
  late final int D;
  late final bool IsDisabled;

  FloatingDayModel.fromJson(Map<String, dynamic> json) {
    Cid = json['Cid'];
    CName = json['CName'];
    AttendanceDate = json['AttendanceDate'];
    remarks = json['remarks'];
    D = json['D'];
    IsDisabled = json['IsDisabled'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Cid'] = Cid;
    data['CName'] = CName;
    data['AttendanceDate'] = AttendanceDate;
    data['remarks'] = remarks;
    data['D'] = D;
    data['IsDisabled'] = IsDisabled;
    return data;
  }
}
