import 'dart:convert';

class GetLookupRequest {
  GetLookupRequest({
    required this.LookupType,
    required this.Country,
  });
  late final String LookupType;
  late final String Country;

  GetLookupRequest.fromJson(Map<String, dynamic> json) {
    LookupType = json['LookupType'];
    Country = json['Country_Name'];
  }

  toJson(String userId, int programId) {
    return jsonEncode({
      'LookupType': LookupType,
      'Country_Name': Country,
      'Program_Id': programId,
      'User_ID': userId,
    });
  }

  toJsonNepal(String countryName, int programId) {
    return jsonEncode({
      'LookupType': LookupType,
      'Country_Name': countryName,
      'Program_Id': programId,
    });
  }
}
