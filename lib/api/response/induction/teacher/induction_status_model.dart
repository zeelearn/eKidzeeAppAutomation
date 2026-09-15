class InductionDayStatusResponse{

  late List<InductionDayDetailsModel> data;

  InductionDayStatusResponse({ required this.data});

  InductionDayStatusResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <InductionDayDetailsModel>[];
      json['data'].forEach((v) {
        data.add(InductionDayDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class InductionDayDetailsModel {
  late String id='';
  late int inductionID=0;
  late int dayID=0;
  late int daySequenceNumber=0;
  late int moduleID=0;
  late int moduleSequenceNumber=0;
  late int contentID=0;
  late int contentSequenceNumber=0;
  late int inductionContentId=0;
  late String dayViewStatus='';
  late String moduleViewStatus='';
  late String contentViewStatus='';

  InductionDayDetailsModel(
      {required this.id,
        required this.inductionID,
        required this.dayID,
        required this.daySequenceNumber,
        required this.moduleID,
        required this.moduleSequenceNumber,
        required this.contentID,
        required this.contentSequenceNumber,
        required this.inductionContentId,
        required this.dayViewStatus,
        required this.moduleViewStatus,
        required this.contentViewStatus});

  InductionDayDetailsModel.fromJson(Map<String, dynamic> json) {
    id = '';//json['$id'];
    inductionID = json['InductionID'];
    dayID = json['DayID'];
    daySequenceNumber = json['DaySequenceNumber'];
    moduleID = json['ModuleID'];
    moduleSequenceNumber = json['ModuleSequenceNumber'];
    contentID = json['ContentID'];
    contentSequenceNumber = json['ContentSequenceNumber'];
    inductionContentId = json['InductionContent_Id'];
    dayViewStatus = json['DayView_Status'];
    moduleViewStatus = json['ModuleView_Status'];
    contentViewStatus = json['ContentView_Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['InductionID'] = this.inductionID;
    data['DayID'] = this.dayID;
    data['DaySequenceNumber'] = this.daySequenceNumber;
    data['ModuleID'] = this.moduleID;
    data['ModuleSequenceNumber'] = this.moduleSequenceNumber;
    data['ContentID'] = this.contentID;
    data['ContentSequenceNumber'] = this.contentSequenceNumber;
    data['InductionContent_Id'] = null;
    data['DayView_Status'] = this.dayViewStatus;
    data['ModuleView_Status'] = this.moduleViewStatus;
    data['ContentView_Status'] = this.contentViewStatus;
    return data;
  }
}
/*
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
  }*/
//}