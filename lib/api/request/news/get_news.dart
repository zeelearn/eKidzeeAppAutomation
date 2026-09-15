class GetNewsRequest{
  late final int User_ID;
  late final String User_Type;
  late final int  PageIndex;
  late final int  PageSize  ;
  late final String Content_Type  ;


  GetNewsRequest({
    required this.User_ID,
    required this.User_Type,
    required this.PageIndex,
    required this.PageSize,
    required this.Content_Type,
  });

  GetNewsRequest.fromJson(Map<String, dynamic> json) {
    User_ID = json['User_ID'];
    User_Type = json['User_Type'];
    PageIndex = json['PageIndex'];
    PageSize = json['PageSize'];
    Content_Type = json['Content_Type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['User_ID'] = User_ID;
    _data['User_Type'] = User_Type;
    _data['PageIndex'] = PageIndex;
    _data['PageSize'] = PageSize;
    _data['Content_Type'] = Content_Type;
    return _data;
  }
}