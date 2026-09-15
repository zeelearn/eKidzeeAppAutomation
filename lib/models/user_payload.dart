import 'dart:convert';
import 'dart:typed_data';

/// Represents the payload used to generate the holiday master URL.
class UserPayload {
  final String usertype;
  final String userid;
  final int academicyear;
  final int frid;

  const UserPayload({
    required this.usertype,
    required this.userid,
    required this.academicyear,
    required this.frid,
  });

  /// Converts this payload to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'usertype': usertype,
      'userid': userid,
      'academicyear': academicyear,
      'frid': frid,
    };
  }

  /// Creates a [UserPayload] from a JSON map.
  factory UserPayload.fromJson(Map<String, dynamic> json) {
    final usertype = json['usertype']?.toString();
    final academicyear = json['academicyear'] is int
        ? json['academicyear']
        : int.tryParse(json['academicyear']?.toString() ?? '');
    final userIdValue = json['userid'];
    final fridValue = json['frid'];

    if (usertype == null || academicyear == null) {
      throw const FormatException('Missing required payload fields.');
    }

    final userid = userIdValue;
    //  is int
    //     ? userIdValue
    //     : int.tryParse(userIdValue?.toString() ?? '') ??
    //         (throw const FormatException('Invalid userid value.'));

    final frid = fridValue is int
        ? fridValue
        : int.tryParse(fridValue?.toString() ?? '') ??
            (throw const FormatException('Invalid frid value.'));

    return UserPayload(
      usertype: usertype,
      userid: userid,
      academicyear: academicyear,
      frid: frid,
    );
  }

  /// Returns the JSON string representation of this payload.
  String toJsonString() => jsonEncode(toJson());

  /// Returns UTF-8 bytes for the JSON payload.
  Uint8List toUtf8Bytes() => utf8.encode(toJsonString());

  /// Returns the Base64 encoded string for the JSON payload.
  String toBase64String() => base64.encode(toUtf8Bytes());
}
