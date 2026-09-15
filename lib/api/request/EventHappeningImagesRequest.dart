class EventHappeningImagesRequest{
  late final String EventHappenings_ID;
  late final String UserType;
  late final String UserID;


  EventHappeningImagesRequest({
    required this.EventHappenings_ID,
    required this.UserType,
    required this.UserID,
  });

  EventHappeningImagesRequest.fromJson(Map<String, dynamic> json) {
    EventHappenings_ID = json['EventHappenings_ID'];
    UserType = json['UserType'];
    UserID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['EventHappenings_ID'] = EventHappenings_ID;
    _data['UserType'] = UserType;
    _data['UserID'] = UserID;
    return _data;
  }
}