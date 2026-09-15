class DigitalResouceRequest{
  final String App_Id = "1";
  String User_id;
  String digitalCategoryId;
  String KeySupport;

  DigitalResouceRequest({
  required this.User_id,
  required this.digitalCategoryId,
  required this.KeySupport});


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'User_id': User_id,
      'digitalCategoryId': digitalCategoryId,
      'KeySupport': KeySupport.trim(),
      'App_Id': App_Id,
    };

    return map;
  }
}