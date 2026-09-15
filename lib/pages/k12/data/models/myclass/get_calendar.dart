class AttandanceDaysResponse {
  int? success;
  //List<AttandanceDays>? data;

  List<CalendarDayData>? data;

  AttandanceDaysResponse({this.success, this.data});

  AttandanceDaysResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CalendarDayData>[];
      json['data'].forEach((v) {
        data!.add(CalendarDayData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CalendarDayData {
  List<AttandanceDays>? attandanceData;
  List<FloatingDay>? floatingDay;
  int? totalStudents;

  CalendarDayData({this.attandanceData, this.floatingDay, this.totalStudents});

  CalendarDayData.fromJson(Map<String, dynamic> json) {
    totalStudents = json['totalStudents'];
    if (json['datelist'] != null) {
      attandanceData = <AttandanceDays>[];
      json['datelist'].forEach((v) {
        attandanceData!.add(AttandanceDays.fromJson(v));
      });
    }
    if (json['floating_days'] != null) {
      floatingDay = <FloatingDay>[];
      json['floating_days'].forEach((v) {
        floatingDay!.add(FloatingDay.fromJson(v));
      });
    } else {
      floatingDay = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (attandanceData != null) {
      data['datelist'] = attandanceData!.map((v) => v.toJson()).toList();
    }
    if (floatingDay != null) {
      data['floating_days'] = floatingDay!.map((v) => v.toJson()).toList();
    }
    data['totalStudents'] = totalStudents;
    return data;
  }
}

class AttandanceDays {
  String? date;
  String? weekday;
  int? isAttendanceFilled;
  int? totalPresent;

  AttandanceDays(
      {this.date, this.weekday, this.isAttendanceFilled, this.totalPresent});

  AttandanceDays.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    weekday = json['weekday'];
    isAttendanceFilled = json['is_attendance_filled'];
    totalPresent = json['totalPresent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Date'] = date;
    data['weekday'] = weekday;
    data['is_attendance_filled'] = isAttendanceFilled;
    data['totalPresent'] = totalPresent;
    return data;
  }
}

class FloatingDay {
  String? date;
  String? remarks;

  FloatingDay({this.date, this.remarks});

  FloatingDay.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['remarks'] = remarks;
    return data;
  }
}
