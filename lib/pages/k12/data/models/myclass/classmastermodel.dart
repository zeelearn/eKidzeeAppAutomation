class ClassMasterModel {
  int? success;
  List<Data>? data;

  ClassMasterModel({this.success, this.data});

  ClassMasterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  List<Term>? term;
  List<Month>? month;
  List<TermMonthList>? termMonthList;
  List<FloatingDayRemarks>? floatingDayRemarks;

  Data({this.term, this.month, this.termMonthList, this.floatingDayRemarks});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['term'] != null) {
      term = <Term>[];
      json['term'].forEach((v) {
        term!.add(Term.fromJson(v));
      });
    }
    if (json['month'] != null) {
      month = <Month>[];
      json['month'].forEach((v) {
        month!.add(Month.fromJson(v));
      });
    }
    termMonthList = <TermMonthList>[];
    if (json['term_month_list'] != null) {
      json['term_month_list'].forEach((v) {
        termMonthList!.add(TermMonthList.fromJson(v));
      });
    }
    if (json['floating_day_remarks'] != null) {
      floatingDayRemarks = <FloatingDayRemarks>[];
      json['floating_day_remarks'].forEach((v) {
        floatingDayRemarks!.add(FloatingDayRemarks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (term != null) {
      data['term'] = term!.map((v) => v.toJson()).toList();
    }
    if (month != null) {
      data['month'] = month!.map((v) => v.toJson()).toList();
    }
    if (termMonthList != null) {
      data['term_month_list'] = termMonthList!.map((v) => v.toJson()).toList();
    }
    if (floatingDayRemarks != null) {
      data['floating_day_remarks'] =
          floatingDayRemarks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Term {
  int? termId;
  String? termName;

  Term({this.termId, this.termName});

  Term.fromJson(Map<String, dynamic> json) {
    termId = json['term_id'];
    termName = json['term_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['term_id'] = termId;
    data['term_name'] = termName;
    return data;
  }
}

class TermMonthList {
  int? termId;
  String? termName;
  int? totalDay;
  int? attendanceDay;
  int? aDay;
  int? fDay;

  List<Month>? month;

  TermMonthList(
      {this.termId,
      this.termName,
      this.month,
      this.totalDay,
      this.attendanceDay,
      this.aDay,
      this.fDay});

  TermMonthList.fromJson(Map<String, dynamic> json) {
    termId = json['term_id'];
    termName = json['term_name'];
    totalDay = json['total_day'] ?? 0;
    attendanceDay = json['attendance_day'] ?? 0;
    aDay = json['a_day'] ?? 0;
    fDay = json['f_day'] ?? 0;
    if (json['month'] != null) {
      month = <Month>[];
      json['month'].forEach((v) {
        month!.add(Month.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['term_id'] = termId;
    data['term_name'] = termName;
    data['total_day'] = totalDay;
    data['attendance_day'] = attendanceDay;
    data['a_day'] = aDay;
    data['f_day'] = fDay;
    if (month != null) {
      data['month'] = month!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Month {
  int? year;
  int? month;
  String? monthName;
  int? totalDay;
  int? attendanceDay;
  int? order;
  int? tDay;
  int? fDay;
  int? satsunTotal;
  int? otherHolidayTotal;

  Month(
      {this.month,
      this.year,
      this.monthName,
      this.order,
      this.tDay,
      this.fDay,
      this.satsunTotal,
      this.otherHolidayTotal});

  Month.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    monthName = json['month_name'];
    order = json['order'];
    totalDay = json['total_day'] ?? 0;
    attendanceDay = json['attendance_day'] ?? 0;
    tDay = json['t_day'] ?? 0;
    fDay = json['f_day'] ?? 0;
    satsunTotal = json['satsun_total'] ?? 0;
    otherHolidayTotal = json['other_holiday_total'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    data['month_name'] = monthName;
    data['order'] = order;
    data['t_day'] = tDay;
    data['f_day'] = fDay;
    data['satsun_total'] = satsunTotal;
    data['other_holiday_total'] = otherHolidayTotal;
    return data;
  }
}

class FloatingDayRemarks {
  int? remarkId;
  String? remarkName;

  FloatingDayRemarks({this.remarkId, this.remarkName});

  FloatingDayRemarks.fromJson(Map<String, dynamic> json) {
    remarkId = json['remark_id'];
    remarkName = json['remark_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remark_id'] = remarkId;
    data['remark_name'] = remarkName;
    return data;
  }
}
