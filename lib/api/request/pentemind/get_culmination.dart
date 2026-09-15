import 'dart:convert';

class GetCulminationRequest {
  GetCulminationRequest({
    required this.termType,
  });
  late final String termType;

  GetCulminationRequest.fromJson(Map<String, dynamic> json){
    termType = json['Class_Term_Type'];

  }

  toJson() {
    return jsonEncode({
      'Class_Term_Type': this.termType,
    });
  }

}