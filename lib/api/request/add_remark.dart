class AddDiaryRemarkRequest{
  late final String DiaryStudent_ID;
  late final String Parent_ID;
  late final String Remark_Text;


  AddDiaryRemarkRequest({
    required this.DiaryStudent_ID,
    required this.Parent_ID,
    required this.Remark_Text,
  });

  AddDiaryRemarkRequest.fromJson(Map<String, dynamic> json) {
    DiaryStudent_ID = json['DiaryStudent_ID'];
    Parent_ID = json['Parent_ID'];
    Remark_Text = json['Remark_Text'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['DiaryStudent_ID'] = DiaryStudent_ID;
    _data['Parent_ID'] = Parent_ID;
    _data['Remark_Text'] = Remark_Text;
    return _data;
  }
}