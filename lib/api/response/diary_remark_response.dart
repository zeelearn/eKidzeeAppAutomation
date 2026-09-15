class DiaryRemarkResponse {
  String iD='';
  String result='';
  String status='';

  DiaryRemarkResponse({required this.iD,required  this.result,required  this.status});

  DiaryRemarkResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    result = json['Result'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Result'] = this.result;
    data['Status'] = this.status;
    return data;
  }
}
