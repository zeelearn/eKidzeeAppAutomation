class BatchRequest{
  late final String franchisee_id;
  late final String academicyear_id;


  BatchRequest({
    required this.franchisee_id,
    required this.academicyear_id,
  });

  BatchRequest.fromJson(Map<String, dynamic> json) {
    franchisee_id = json['franchisee_id'];
    academicyear_id = json['academicyear_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['franchisee_id'] = franchisee_id;
    _data['academicyear_id'] = academicyear_id;
    return _data;
  }
}