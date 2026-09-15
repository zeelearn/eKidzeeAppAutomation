class EventHappeningRequest{
  late final String Year;
  late final String Month;
  late final String Event_Type;
  late final String User_ID;


  EventHappeningRequest({
    required this.Year,
    required this.Event_Type,
    required this.Month,
    required this.User_ID,
  });

  EventHappeningRequest.fromJson(Map<String, dynamic> json) {
    Year = json['Year'];
    Event_Type = json['Event_Type'];
    Month = json['Month'];
    User_ID = json['User_ID'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Year'] = Year;
    _data['Event_Type'] = Event_Type;
    _data['Month'] = Month;
    _data['User_ID'] = User_ID;
    return _data;
  }
}