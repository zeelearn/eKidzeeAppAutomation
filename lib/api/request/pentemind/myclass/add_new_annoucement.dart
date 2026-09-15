import 'dart:convert';

class NewAnnoucementRequest {
  final bool isKes;
  late final String User_id;
  late final String userName;
  late final String Program_Id;
  late final String title;
  late final String publishDate;
  late final String description;
  late final List<Map<String, dynamic>> studentList;
  late final String? attachmentUrl;

  NewAnnoucementRequest({
    required this.User_id,
    required this.Program_Id,
    required this.publishDate,
    required this.title,
    required this.description,
  }) : isKes = false;

  /* {
    "username": "SZEG1818",
    "subject": "Happy New Year 2025",
    "msg_type": "Alert",
    "msg_body": "Happy New Year 2025",
    "request_type": "Announcement",
    "publish_date": "2025-01-01",
    "attachment_url": "happynew.pdf",
    "input_data": [
        {
            "user_role_id": 31,
            "section_id": 5124,
            "user_id": 625737
        },
        {
            "user_role_id": 31,
            "section_id": 5124,
            "user_id": 625734
        }
    ]
} */

  NewAnnoucementRequest.KES(
      {required this.userName,
      required this.title,
      required this.description,
      required this.publishDate,
      required this.User_id,
      required this.Program_Id,
      this.attachmentUrl,
      required this.studentList})
      : isKes = true;

  toKesJson() {
    return jsonEncode({
      'username': userName,
      'subject': title,
      "msg_type": "Alert",
      "request_type": "Announcement",
      'publish_date': publishDate,
      'msg_body': description,
      'input_data': studentList,
      'attachment_url': attachmentUrl ?? ''
    });
  }

  toJson() {
    return isKes
        ? jsonEncode({
            'username': userName,
            'subject': title,
            "msg_type": "Alert",
            "request_type": "Announcement",
            'publish_date': publishDate,
            'msg_body': description,
            'input_data': studentList,
            'attachment_url': attachmentUrl ?? ''
          })
        : jsonEncode({
            'Subject': title,
            'User_id': User_id,
            'Program_id': Program_Id,
            'PublishDate': publishDate,
            'Body': description,
          });
  }
}
