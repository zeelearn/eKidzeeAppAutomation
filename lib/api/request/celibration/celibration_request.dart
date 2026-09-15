import 'dart:convert';

class CelibrationRequest{
  late final String display;


  CelibrationRequest({
    required this.display,
  });

  CelibrationRequest.fromJson(Map<String, dynamic> json) {
    display = json['display'];
  }

  toJson() {
    return jsonEncode({
      'display': this.display
    });
  }
}