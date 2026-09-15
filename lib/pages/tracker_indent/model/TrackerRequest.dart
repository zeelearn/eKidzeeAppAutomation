// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TrackerRequest {
  String frachisee_Id;
  String? DocketNo;
  String IndentType;
  String fromDate;
  String toDate;
  String academicyearId;
  String academicyearName;
  String indentNo;
  String status;
  String? last_days;
  TrackerRequest(
      {required this.frachisee_Id,
      required this.DocketNo,
      required this.IndentType,
      required this.fromDate,
      required this.toDate,
      required this.academicyearId,
      required this.academicyearName,
      required this.indentNo,
      required this.status,
      this.last_days});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Franchisee_Id': frachisee_Id,
      'Indent_Type': IndentType,
      'AcademicYear_id': academicyearId,
      'IndentNo': indentNo,
      'status': status,
      'LastDays': last_days ?? '0'
    };
  }

  factory TrackerRequest.fromMap(Map<String, dynamic> map) {
    return TrackerRequest(
      frachisee_Id: map['frachiseeCode'] as String,
      DocketNo: map['DocketNo'] as String,
      IndentType: map['IndentType'] as String,
      fromDate: map['fromDate'] as String,
      toDate: map['toDate'] as String,
      academicyearId: map['academicyearId'] as String,
      academicyearName: map['academicyearName'],
      indentNo: map['indentNo'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackerRequest.fromJson(String source) =>
      TrackerRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TrackerRequest(frachiseeCode: $frachisee_Id, DocketNo: $DocketNo, IndentType: $IndentType, fromDate: $fromDate, toDate: $toDate, academicyearId: $academicyearId, indentNo: $indentNo, status: $status)';
  }

  @override
  bool operator ==(covariant TrackerRequest other) {
    if (identical(this, other)) return true;

    return other.frachisee_Id == frachisee_Id &&
        other.DocketNo == DocketNo &&
        other.IndentType == IndentType &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.academicyearId == academicyearId &&
        other.indentNo == indentNo &&
        other.status == status;
  }

  @override
  int get hashCode {
    return frachisee_Id.hashCode ^
        DocketNo.hashCode ^
        IndentType.hashCode ^
        fromDate.hashCode ^
        toDate.hashCode ^
        academicyearId.hashCode ^
        indentNo.hashCode ^
        status.hashCode;
  }
}
