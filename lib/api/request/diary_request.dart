class StudentDiaryRequest{
  late final String Parent_ID;
  late final String PageSize;
  late final String PageIndex;


  StudentDiaryRequest({
    required this.Parent_ID,
    required this.PageSize,
    required this.PageIndex,
  });

  StudentDiaryRequest.fromJson(Map<String, dynamic> json) {
    Parent_ID = json['Parent_ID'];
    PageSize = json['PageSize'];
    PageIndex = json['PageIndex'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Parent_ID'] = Parent_ID;
    _data['PageSize'] = PageSize;
    _data['PageIndex'] = PageIndex;
    return _data;
  }
}