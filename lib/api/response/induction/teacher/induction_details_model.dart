class InductionDetalsResponse{

  late List<InductionDetailsModel> data;

  InductionDetalsResponse({ required this.data});

  InductionDetalsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <InductionDetailsModel>[];
      json['data'].forEach((v) {
        data.add(InductionDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class InductionDetailsModel {
  late int id=0;
  late double iPDayID=0;
  late double inductionID=0.0;
  late String iPDayName='';
  late String iPDayDescription='';
  late int iPDaySequenceNumber=0;
  late String iPDayIconImageURL='';
  late String createdDate='';
  late String dayStatus='';
  late String defaultDayBackgroundImageURL='';
  late String disabledDayBackgroundImageURL='';
  late String inProgressDayBackgroundImageURL='';
  late String completedDayBackgroundImageURL='';

  InductionDetailsModel(
      {required this.id,
        required this.iPDayID,
        required this.inductionID,
        required this.iPDayName,
        required this.iPDayDescription,
        required this.iPDaySequenceNumber,
        required this.iPDayIconImageURL,
        required this.createdDate,
        required this.dayStatus,
        required this.defaultDayBackgroundImageURL,
        required this.disabledDayBackgroundImageURL,
        required this.inProgressDayBackgroundImageURL,
        required this.completedDayBackgroundImageURL});

  InductionDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['$id'] ?? 0;
    iPDayID = json['IP_DayID'] ?? 0;
    inductionID = json['InductionID']  ?? 0.0;
    iPDayName = json['IP_DayName'];
    iPDayDescription = json['IP_DayDescription'];
    iPDaySequenceNumber = json['IP_DaySequenceNumber'];
    iPDayIconImageURL = json['IP_DayIconImageURL'];
    createdDate = json['CreatedDate'];
    dayStatus = json['DayStatus'];
    defaultDayBackgroundImageURL = json['DefaultDay_BackgroundImageURL'];
    disabledDayBackgroundImageURL = json['DisabledDay_BackgroundImageURL'];
    inProgressDayBackgroundImageURL = json['InProgressDay_BackgroundImageURL'];
    completedDayBackgroundImageURL = json['CompletedDay_BackgroundImageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['IP_DayID'] = this.iPDayID;
    data['InductionID'] = this.inductionID;
    data['IP_DayName'] = this.iPDayName;
    data['IP_DayDescription'] = this.iPDayDescription;
    data['IP_DaySequenceNumber'] = this.iPDaySequenceNumber;
    data['IP_DayIconImageURL'] = this.iPDayIconImageURL;
    data['CreatedDate'] = this.createdDate;
    data['DayStatus'] = this.dayStatus;
    data['DefaultDay_BackgroundImageURL'] = this.defaultDayBackgroundImageURL;
    data['DisabledDay_BackgroundImageURL'] = this.disabledDayBackgroundImageURL;
    data['InProgressDay_BackgroundImageURL'] =
        this.inProgressDayBackgroundImageURL;
    data['CompletedDay_BackgroundImageURL'] =
        this.completedDayBackgroundImageURL;
    return data;
  }
}