class ClassInfoModel {
  final int infoId;
  final int franchiseeId;
  final String franchiseeCode;
  final String programId;
  final String classFacilitator;
  final String centerHead;
  final String classPhoto;

  ClassInfoModel({
    required this.infoId,
    required this.franchiseeId,
    required this.franchiseeCode,
    required this.programId,
    required this.classFacilitator,
    required this.centerHead,
    required this.classPhoto,
  });

  factory ClassInfoModel.fromJson(Map<String, dynamic> json) {
    return ClassInfoModel(
      infoId: json['InfoId'],
      franchiseeId: json['franchisee_id'],
      franchiseeCode: json['Franchisee_Code'] ?? '',
      programId: json['Program_Id'] ?? '',
      classFacilitator: json['classfacilitatorname'] ?? '',
      centerHead: json['centerheadname'] ?? '',
      classPhoto: json['classphoto'] ?? '',
    );
  }
}
