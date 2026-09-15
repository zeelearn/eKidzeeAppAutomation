
import 'induction_list_response.dart';

class EnrolledTeacherList {

  late List<InductionListResponseModel> inductionRequestList=[];


  EnrolledTeacherList(this.inductionRequestList);

  EnrolledTeacherList.fromJson(Map<String, dynamic> json) {
    if (json['inductionRequestList'] != null) {
      inductionRequestList = <InductionListResponseModel>[];
      json['inductionRequestList'].forEach((v) {
        inductionRequestList.add(new InductionListResponseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inductionRequestList'] = this.inductionRequestList.map((v) => v.toJson()).toList();
      return data;
  }

}