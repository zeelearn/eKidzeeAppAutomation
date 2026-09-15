class HelpDeskLogResponse {
  List<HelpDeskLogModel> data=[];
  List<HelpDeskRemarkModel> remarkList=[];

  HelpDeskLogResponse({required this.data});

  HelpDeskLogResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HelpDeskLogModel>[];
      json['data'].forEach((v) {
        data.add(new HelpDeskLogModel.fromJson(v));
      });
    }
    if (json['remark'] != null) {
      remarkList = <HelpDeskRemarkModel>[];
      json['remark'].forEach((v) {
        remarkList.add(new HelpDeskRemarkModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data.isNotEmpty) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.remarkList.isNotEmpty) {
      data['remark'] = this.remarkList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HelpDeskLogModel {
  double? helpdeskId;
  String? priority;
  String? status;
  String? employeeName;
  String? userName;
  String? tURNAROUND;
  String? createdDate;

  HelpDeskLogModel(
      {this.helpdeskId,
        this.priority,
        this.status,
        this.employeeName,
        this.userName,
        this.tURNAROUND,
        this.createdDate});

  HelpDeskLogModel.fromJson(Map<String, dynamic> json) {
    helpdeskId = json['Helpdesk_Id'];
    priority = json['priority'];
    status = json['status'];
    employeeName = json['employee_name'];
    userName = json['User_Name'];
    tURNAROUND = json['TURNAROUND'];
    createdDate = json['Created_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Helpdesk_Id'] = this.helpdeskId;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['employee_name'] = this.employeeName;
    data['User_Name'] = this.userName;
    data['TURNAROUND'] = this.tURNAROUND;
    data['Created_Date'] = this.createdDate;
    return data;
  }
}

class HelpDeskRemarkModel {
  double? helpdeskId;
  String? remarks;
  String? userName;
  String? createdDate;

  HelpDeskRemarkModel({this.helpdeskId, this.remarks, this.userName, this.createdDate});

  HelpDeskRemarkModel.fromJson(Map<String, dynamic> json) {
    helpdeskId = json['Helpdesk_Id'];
    remarks = json['Remarks'];
    userName = json['User_Name'];
    createdDate = json['Created_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Helpdesk_Id'] = this.helpdeskId;
    data['Remarks'] = this.remarks;
    data['User_Name'] = this.userName;
    data['Created_Date'] = this.createdDate;
    return data;
  }
}
