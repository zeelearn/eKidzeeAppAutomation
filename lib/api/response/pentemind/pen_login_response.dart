// class PentemindLoginResponse {
//   PentemindLoginResponse({
//     required this.success,
//     required this.data,
//     required this.token,
//   });
//   late final int success;
//   late final Data data;
//   late final String token;
//
//   PentemindLoginResponse.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = Data.fromJson(json['data']);
//     token = json['token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['success'] = success;
//     _data['data'] = data.toJson();
//     _data['token'] = token;
//     return _data;
//   }
// }
//
// class Data {
//   Data({
//     required this.UserID,
//     required this.UserName,
//     required this.UserType,
//     required this.EntityID,
//     required this.DisplayName,
//     required this.franchiseeId,
//     required this.program,
//     required this.StudentData,
//     required this.businesssId
//   });
//   late final int UserID;
//   late final String UserName;
//   late final String UserType;
//   late final int EntityID;
//   late final int businesssId;
//   late final String DisplayName;
//   late final String franchiseeId;
//   late final List<ClassProgram> program;
//   late final List<StudentDataModel> StudentData;
//
//   Data.fromJson(Map<String, dynamic> json) {
//     UserID = json['User_ID'];
//     UserName = json['User_Name'];
//     UserType = json['User_Type'];
//     businesssId = json.containsKey('Business_Id') ? json['Business_Id'] ?? 1 : 1;
//     EntityID = json.containsKey('Entity_ID') ? json['Entity_ID'] : 0;
//     DisplayName = json.containsKey('DisplayName') ? json['DisplayName'] : '';
//     franchiseeId = json.containsKey('Franchisee_Id')
//         ? json['Franchisee_Id'].toString()
//         : '';
//     program = json.containsKey('Program')
//         ? List.from(json['Program'])
//             .map((e) => ClassProgram.fromJson(e))
//             .toList()
//         : [];
//     StudentData = json.containsKey('StudentData')
//         ? List.from(json['StudentData'])
//             .map((e) => StudentDataModel.fromJson(e))
//             .toList()
//         : [];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['User_ID'] = UserID;
//     _data['User_Name'] = UserName;
//     _data['User_Type'] = UserType;
//     _data['Entity_ID'] = EntityID;
//     _data['DisplayName'] = DisplayName;
//     _data['Business_Id'] = businesssId;
//     _data['Franchisee_Id'] = franchiseeId;
//     _data['Program'] = program.map((e) => e.toJson()).toList();
//     _data['StudentData'] = StudentData.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }
//
// class ClassProgram {
//   ClassProgram(
//       {required this.programName,
//       required this.programId,
//       required this.className,
//       required this.classId,
//       required this.feeType,
//       required this.term,
//       required this.franchiseeID,
//       required this.curriculamType});
//   late final String programName;
//   late final int programId;
//   late final String className;
//   late final int classId;
//   late final String feeType;
//   late final String term;
//   late final int franchiseeID;
//   late final String curriculamType;
//   late final int roleId;
//   late final String userRole;
//
//   ClassProgram.fromJson(Map<String, dynamic> json) {
//     programName = json['Program_Name'];
//     programId = json['Program_Id'];
//     className = json['Class_Name'] ?? '';
//     classId = json['Class_Id'];
//     feeType = json['Fee_Type'] ?? '';
//     franchiseeID =
//         json.containsKey('Franchisee_id') ? json['Franchisee_id'] ?? '' : 0;
//     term = json.containsKey('Term') ? json['Term'] ?? '' : '';
//     curriculamType = json.containsKey('Curriculum_Type') ? json['Curriculum_Type'] : '';
//     roleId = json.containsKey('User_Role_Id') ? json['User_Role_Id'] : 0;
//     userRole = json.containsKey('User_Role_Name') ? json['User_Role_Name'] : '';
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['Program_Name'] = programName;
//     _data['Program_Id'] = programId;
//     _data['Class_Name'] = className;
//     _data['Class_Id'] = classId;
//     _data['Fee_Type'] = feeType;
//     _data['Term'] = term;
//     _data['Franchisee_id'] = franchiseeID;
//     _data['Curriculum_Type'] = curriculamType;
//     _data['User_Role_Name'] = userRole;
//     _data['User_Role_Id'] = roleId;
//
//     return _data;
//   }
// }
//
// class StudentDataModel {
//   StudentDataModel({
//     required this.StudentID,
//     required this.StudentName,
//   });
//   late final int StudentID;
//   late final String StudentName;
//   late final String studentprofileURL;
//   late final String Franchisee_Code;
//   late final int Franchisee_Id;
//
//   StudentDataModel.fromJson(Map<String, dynamic> json) {
//     StudentID = json['StudentID'];
//     StudentName = json['Student_Name'];
//     studentprofileURL = json['studentprofileURL'];
//     Franchisee_Code = json['Franchisee_Code'];
//     Franchisee_Id =
//         json.containsKey('Franchisee_Id') ? json['Franchisee_Id'] ?? '' : 0;
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['StudentID'] = StudentID;
//     _data['Student_Name'] = StudentName;
//     _data['studentprofileURL'] = studentprofileURL;
//     _data['Franchisee_Code'] = Franchisee_Code;
//     _data['Franchisee_Id'] = Franchisee_Id;
//     return _data;
//   }
// }
