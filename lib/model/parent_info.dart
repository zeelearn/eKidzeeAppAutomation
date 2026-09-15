class ParentInfo {
  late int franchiseeId;
  late int studentProgramId;
  late int studentID;
  late int classId;
  late String className;
  late int parentID;
  late String parentName;
  late String studentDOB;
  late String isParentVerified;
  late String address1;
  late String address2;
  late String phoneNumber;
  late String mobileNo;
  late String emailId;
  late String stateName;
  late String cityName;
  late String place;
  late String studentName;
  late String studentGender;
  late String schoolName;
  late String programName;
  late String admissionDate;
  late String franchiseeType;
  late String studentExtraSmallImage;
  late String studentSmallImage;
  late String studentMediumImage;
  late String studentLargeImage;

  ParentInfo(
      {required this.franchiseeId,
        required this.studentProgramId,
        required this.studentID,
        required this.classId,
        required this.className,
        required this.parentID,
        required this.parentName,
        required this.studentDOB,
        required this.isParentVerified,
        required this.address1,
        required this.address2,
        required this.phoneNumber,
        required this.mobileNo,
        required this.emailId,
        required this.stateName,
        required this.cityName,
        required this.place,
        required this.studentName,
        required this.studentGender,
        required this.schoolName,
        required this.programName,
        required this.admissionDate,
        required this.franchiseeType,
        required this.studentExtraSmallImage,
        required this.studentSmallImage,
        required this.studentMediumImage,
        required this.studentLargeImage});

  ParentInfo.fromJson(Map<String, dynamic> json) {
    franchiseeId = json['Franchisee_Id'];
    studentProgramId = json['Student_Program_Id'];
    studentID = json['Student_ID'];
    classId = json['Class_Id'];
    className = json['Class_Name'];
    parentID = json['Parent_ID'];
    parentName = json['Parent_Name'];
    studentDOB = json['Student_DOB'];
    isParentVerified = json['Is_Parent_Verified'];
    address1 = json['Address1'];
    address2 = json['Address2'];
    phoneNumber = json['PhoneNumber'];
    mobileNo = json['Mobile_No'];
    emailId = json['Email_Id'];
    stateName = json['State_name'];
    cityName = json['City_name'];
    place = json['Place'];
    studentName = json['Student_Name'];
    studentGender = json['StudentGender'];
    schoolName = json['School_name'];
    programName = json['Program_Name'];
    admissionDate = json['Admission Date'];
    franchiseeType = json['Franchisee_Type'];
    studentExtraSmallImage = json['Student_ExtraSmall_Image'];
    studentSmallImage = json['Student_Small_Image'];
    studentMediumImage = json['Student_Medium_Image'];
    studentLargeImage = json['Student_Large_Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Franchisee_Id'] =  this.franchiseeId;
    data['Student_Program_Id'] =  this.studentProgramId;
    data['Student_ID'] =  this.studentID;
    data['Class_Id'] =  this.classId;
    data['Class_Name'] =  this.className;
    data['Parent_ID'] =  this.parentID;
    data['Parent_Name'] =  this.parentName;
    data['Student_DOB'] =  this.studentDOB;
    data['Is_Parent_Verified'] =  this.isParentVerified;
    data['Address1'] =  this.address1;
    data['Address2'] =  this.address2;
    data['PhoneNumber'] =  this.phoneNumber;
    data['Mobile_No'] =  this.mobileNo;
    data['Email_Id'] =  this.emailId;
    data['State_name'] =  this.stateName;
    data['City_name'] =  this.cityName;
    data['Place'] =  this.place;
    data['Student_Name'] =  this.studentName;
    data['StudentGender'] =  this.studentGender;
    data['School_name'] =  this.schoolName;
    data['Program_Name'] =  this.programName;
    data['Admission Date'] =  this.admissionDate;
    data['Franchisee_Type'] =  this.franchiseeType;
    data['Student_ExtraSmall_Image'] =  this.studentExtraSmallImage;
    data['Student_Small_Image'] =  this.studentSmallImage;
    data['Student_Medium_Image'] =  this.studentMediumImage;
    data['Student_Large_Image'] =  this.studentLargeImage;
    return data;
  }
}