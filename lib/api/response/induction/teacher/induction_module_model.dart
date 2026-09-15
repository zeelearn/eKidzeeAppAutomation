class InductionDayModuleResponse{

  late List<DayModule> data;

  InductionDayModuleResponse({ required this.data});

  InductionDayModuleResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DayModule>[];
      json['data'].forEach((v) {
        data.add(DayModule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}
class DayModule {
  int? id;
  double? iPDModuleID;
  double? iPDayID;
  String? iPDModuleName;
  String? iPDModuleDescription;
  int? iPDModuleSequenceNumber;
  String? createdDate;
  String? moduleStatus;
  String? moduleBackgroundImageURL;

  DayModule(
      {this.id,
        this.iPDModuleID,
        this.iPDayID,
        this.iPDModuleName,
        this.iPDModuleDescription,
        this.iPDModuleSequenceNumber,
        this.createdDate,
        this.moduleStatus,
        this.moduleBackgroundImageURL});

  DayModule.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    iPDModuleID = json['IPD_ModuleID'];
    iPDayID = json['IP_DayID'];
    iPDModuleName = json['IPD_ModuleName'];
    iPDModuleDescription = json['IPD_ModuleDescription'];
    iPDModuleSequenceNumber = json['IPD_ModuleSequenceNumber'];
    createdDate = json['CreatedDate'];
    moduleStatus = json['ModuleStatus'];
    moduleBackgroundImageURL = json['Module_BackgroundImageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['IPD_ModuleID'] = this.iPDModuleID;
    data['IP_DayID'] = this.iPDayID;
    data['IPD_ModuleName'] = this.iPDModuleName;
    data['IPD_ModuleDescription'] = this.iPDModuleDescription;
    data['IPD_ModuleSequenceNumber'] = this.iPDModuleSequenceNumber;
    data['CreatedDate'] = this.createdDate;
    data['ModuleStatus'] = this.moduleStatus;
    data['Module_BackgroundImageURL'] = this.moduleBackgroundImageURL;
    return data;
  }
}