class GenericResponse {
  late int success;
  late dynamic response;

  GenericResponse({required this.success, required this.response});

  GenericResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json.containsKey('data')) {
      try {
        response = <Response>[];
        json['data'].forEach((v) {
          response.add(Response.fromJson(v));
        });
//         debugPrint('IN 15 ${response[0].response}');
      } catch (e) {
//         debugPrint('IN 16 ${e.toString()}');
        response = Response.fromJson(json['data']);
      }
//       debugPrint('IN 18 ${response.response}');
    } else {
//       debugPrint('data not found....');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (response != null) {
      data['data'] = response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  late String response;

  Response({required this.response});

  Response.fromJson(Map<String, dynamic> json) {
    //debugPrint('Msg decoding...');
    response = json.containsKey('msg')
        ? json['msg']
        : json.containsKey('Msg')
            ? json['Msg']
            : json.containsKey('MSG')
                ? json['MSG']
                : '';
    //debugPrint('Msg is ${response}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Msg'] = response;
    return data;
  }
}
