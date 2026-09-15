
import 'dart:convert';


class EnrollmentResponse {

  late String Status;


  EnrollmentResponse(
      {

        required this.Status,

      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {

      'Status': Status.trim(),

    };

    return map;
  }

  EnrollmentResponse.fromJson(Map<String, dynamic> json) {

    Status = json['Status'] ?? '';


  }


  getJson(){
    return jsonEncode( {

      'Status': Status,

    });
  }
}