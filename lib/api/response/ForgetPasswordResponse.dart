class ForgetPasswordResponse {
  late String Status;
  late String Result;

  ForgetPasswordResponse({required this.Status,required this.Result});

  ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    Status = json['Status'];
    Status = json['Status'];

  }

}
