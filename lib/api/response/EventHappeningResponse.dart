class EventHappeningResponse {
  late List<DisplayEvent> displayEvent;
  late List<DisplayHappenings> displayHappenings;
  late List<String>? userTypeList;
  String? year;
  String? month;
  int? userId;
  late List<String>? mappedFranchiseeList;
  bool? showFranchiseeBox;
  bool? isAllowedToLike;
  var displayEventsHappenings;

  EventHappeningResponse(
      { required this.displayEvent,
        required this.displayHappenings,
        this.userTypeList,
        this.year,
        this.month,
        this.userId,
        this.mappedFranchiseeList,
        this.showFranchiseeBox,
        this.isAllowedToLike,
        this.displayEventsHappenings});

  EventHappeningResponse.fromJson(Map<String, dynamic> json) {
    if (json['DisplayEvent'] != null) {
      displayEvent = <DisplayEvent>[];
      json['DisplayEvent'].forEach((v) {
        displayEvent.add(new DisplayEvent.fromJson(v));
      });
    }
    if (json['DisplayHappenings'] != null) {
      displayHappenings = <DisplayHappenings>[];
      json['DisplayHappenings'].forEach((v) {
        displayHappenings.add(new DisplayHappenings.fromJson(v));
      });
    }
    /*if (json['User_TypeList'] != null) {
      userTypeList = <String>[];
      json['User_TypeList'].forEach((v) {
        userTypeList!.add(new Null.fromJson(v));
      });
    }*/
    year = json['year'];
    month = json['month'];
    userId = json['UserId'];
    /*if (json['MappedFranchiseeList'] != null) {
      mappedFranchiseeList = <Null>[];
      json['MappedFranchiseeList'].forEach((v) {
        mappedFranchiseeList!.add(new Null.fromJson(v));
      });
    }*/
    showFranchiseeBox = json['ShowFranchiseeBox'];
    isAllowedToLike = json['IsAllowedToLike'];
    displayEventsHappenings = json['DisplayEventsHappenings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DisplayEvent'] = this.displayEvent.map((v) => v.toJson()).toList();
      data['DisplayHappenings'] =
        this.displayHappenings.map((v) => v.toJson()).toList();
      /*if (this.userTypeList != null) {
      data['User_TypeList'] =
          this.userTypeList!.map((v) => v.toJson()).toList();
    }*/
    data['year'] = this.year;
    data['month'] = this.month;
    data['UserId'] = this.userId;
    /*if (this.mappedFranchiseeList != null) {
      data['MappedFranchiseeList'] =
          this.mappedFranchiseeList!.map((v) => v.toJson()).toList();
    }*/
    data['ShowFranchiseeBox'] = this.showFranchiseeBox;
    data['IsAllowedToLike'] = this.isAllowedToLike;
    data['DisplayEventsHappenings'] = this.displayEventsHappenings;
    return data;
  }
}

class DisplayEvent {
  int? mEventsHappeningsId;
  String? academicYearName;
  String? eventHeaderText;
  int? monthId;
  String? attachmenturl;
  int? monthId1;
  late String title;
  late String type;
  late String eventDate;
  late String eventText;
  late String createdBy;
  late String postedDate;
  late String username;
  late String display;
  int? hasImage;
  String? totalLikes;
  String? userName;
  String? isLike;
  int? activeAssign;
  String? classId;
  String? className;

  DisplayEvent(
      {this.mEventsHappeningsId,
        this.academicYearName,
        this.eventHeaderText,
        this.monthId,
        this.attachmenturl,
        this.monthId1,
        required this.title,
        required this.type,
        required this.eventDate,
        required this.eventText,
        required this.createdBy,
        required this.postedDate,
        required this.username,
        required this.display,
        this.hasImage,
        this.totalLikes,
        this.userName,
        this.isLike,
        this.activeAssign,
        this.classId,
        this.className});

  DisplayEvent.fromJson(Map<String, dynamic> json) {
    mEventsHappeningsId = json['m_Events_Happenings_Id'];
    academicYearName = json['AcademicYear_Name'];
    eventHeaderText = json['EventHeaderText'];
    monthId = json['Month_Id'];
    attachmenturl = json['Attachmenturl'];
    monthId1 = json['Month_Id1'];
    title = json['Title'];
    type = json['Type'];
    eventDate = json['Event_Date'];
    eventText = json['EventText'];
    createdBy = json['Created_By'];
    postedDate = json['Posted_Date'];
    username = json['username'];
    display = json['display'];
    hasImage = json['HasImage'];
    totalLikes = json['TotalLikes'];
    userName = json['User_Name'];
    isLike = json['IsLike'];
    activeAssign = json['Active_Assign'];
    classId = json['Class_Id'];
    className = json['Class_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['m_Events_Happenings_Id'] = this.mEventsHappeningsId;
    data['AcademicYear_Name'] = this.academicYearName;
    data['EventHeaderText'] = this.eventHeaderText;
    data['Month_Id'] = this.monthId;
    data['Attachmenturl'] = this.attachmenturl;
    data['Month_Id1'] = this.monthId1;
    data['Title'] = this.title;
    data['Type'] = this.type;
    data['Event_Date'] = this.eventDate;
    data['EventText'] = this.eventText;
    data['Created_By'] = this.createdBy;
    data['Posted_Date'] = this.postedDate;
    data['username'] = this.username;
    data['display'] = this.display;
    data['HasImage'] = this.hasImage;
    data['TotalLikes'] = this.totalLikes;
    data['User_Name'] = this.userName;
    data['IsLike'] = this.isLike;
    data['Active_Assign'] = this.activeAssign;
    data['Class_Id'] = this.classId;
    data['Class_Name'] = this.className;
    return data;
  }
}

class DisplayHappenings {
  int mEventsHappeningsId=0;
  String? academicYearName;
  String? eventHeaderText;
  int? monthId;
  String? attachmenturl;
  int? monthId1;
  String title='';
  String? type;
  String? eventDate;
  String? eventText;
  String? createdBy;
  String? postedDate;
  String? username;
  String? display;
  int? hasImage;
  String? totalLikes;
  String? userName;
  String? isLike;
  int? activeAssign;

  DisplayHappenings(
      {required this.mEventsHappeningsId,
        this.academicYearName,
        this.eventHeaderText,
        this.monthId,
        this.attachmenturl,
        this.monthId1,
        required this.title,
        this.type,
        this.eventDate,
        this.eventText,
        this.createdBy,
        this.postedDate,
        this.username,
        this.display,
        this.hasImage,
        this.totalLikes,
        this.userName,
        this.isLike,
        this.activeAssign});

  DisplayHappenings.fromJson(Map<String, dynamic> json) {
    mEventsHappeningsId = json['m_Events_Happenings_Id'];
    academicYearName = json['AcademicYear_Name'];
    eventHeaderText = json['EventHeaderText'];
    monthId = json['Month_Id'];
    attachmenturl = json['Attachmenturl'];
    monthId1 = json['Month_Id1'];
    title = json['Title'];
    type = json['Type'];
    eventDate = json['Event_Date'];
    eventText = json['EventText'];
    createdBy = json['Created_By'];
    postedDate = json['Posted_Date'];
    username = json['username'];
    display = json['display'];
    hasImage = json['HasImage'];
    totalLikes = json['TotalLikes'];
    userName = json['User_Name'];
    isLike = json['IsLike'];
    activeAssign = json['Active_Assign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['m_Events_Happenings_Id'] = this.mEventsHappeningsId;
    data['AcademicYear_Name'] = this.academicYearName;
    data['EventHeaderText'] = this.eventHeaderText;
    data['Month_Id'] = this.monthId;
    data['Attachmenturl'] = this.attachmenturl;
    data['Month_Id1'] = this.monthId1;
    data['Title'] = this.title;
    data['Type'] = this.type;
    data['Event_Date'] = this.eventDate;
    data['EventText'] = this.eventText;
    data['Created_By'] = this.createdBy;
    data['Posted_Date'] = this.postedDate;
    data['username'] = this.username;
    data['display'] = this.display;
    data['HasImage'] = this.hasImage;
    data['TotalLikes'] = this.totalLikes;
    data['User_Name'] = this.userName;
    data['IsLike'] = this.isLike;
    data['Active_Assign'] = this.activeAssign;
    return data;
  }
}