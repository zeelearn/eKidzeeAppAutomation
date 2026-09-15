class AcademicYearInfo{

  late List<AcademicYearInfoModel> data;

  AcademicYearInfo({ required this.data});

  AcademicYearInfo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AcademicYearInfoModel>[];
      json['data'].forEach((v) {
        data.add(AcademicYearInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }

  List<String> getArray(){
    List<String> academicYearList = [];
    for(int index=0;index<data.length;index++){
      academicYearList.add(data[index].AcademicYear_Name);
    }
    return academicYearList;
  }
  int getSelectedAcademicYearId(String academicYear){
   int academicYearId = 0;
    for(int index=0;index<data.length;index++){
      if(academicYear == data[index].AcademicYear_Name) {
        academicYearId = data[index].AcademicYear_Id.toInt();
        break;
      }
    }
    return academicYearId;
  }
}
class AcademicYearInfoModel {
  AcademicYearInfoModel({
    required this.AcademicYear_Id,
    required this.AcademicYear_Name,

  });
  late final double AcademicYear_Id;
  late final String AcademicYear_Name;

  AcademicYearInfoModel.fromJson(Map<String, dynamic> json){
    AcademicYear_Id = json['AcademicYear_Id'];
    AcademicYear_Name = json['AcademicYear_Name'];
  }


  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['AcademicYear_Id'] = AcademicYear_Id;
    _data['AcademicYear_Name'] = AcademicYear_Name;
    return _data;
  }


  String toString() {
    return this.AcademicYear_Name; // What to display in the Spinner list.
  }
}