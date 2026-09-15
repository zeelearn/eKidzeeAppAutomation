class BatchInfo{

  late List<BatchInfoModel> data;

  BatchInfo({ required this.data});

  BatchInfo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BatchInfoModel>[];
      json['data'].forEach((v) {
        data.add(BatchInfoModel.fromJson(v));
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
      academicYearList.add(data[index].Program_Name);
    }
    return academicYearList;
  }
  BatchInfoModel getSelectedAcademicBatchId(String batch){
    BatchInfoModel model= data[0];
    for(int index=0;index<data.length;index++){
      if(batch == data[index].Program_Name) {
        model = data[index];
        break;
      }
    }
    return model;
  }
}
class BatchInfoModel {
  BatchInfoModel({
    required this.Program_ID,
    required this.Program_Name,
    required this.Franchisee_ID,
    required this.Franchisee_Name,

  });
  late final double Program_ID;
  late final String Program_Name;
  late final double Franchisee_ID;
  late final String Franchisee_Name;


  BatchInfoModel.fromJson(Map<String, dynamic> json){
    Program_ID = json['Program_ID'];
    Program_Name = json['Program_Name'];
    Franchisee_ID = json['Franchisee_ID'];
    Franchisee_Name = json['Franchisee_Name'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Program_ID'] = Program_ID;

    _data['Program_Name'] = Program_Name;
    _data['Franchisee_ID'] = Franchisee_ID;
    _data['Franchisee_Name'] = Franchisee_Name;

    return _data;
  }
}