class ParentRequest{
  late String parentId;
  ParentRequest({
    required this.parentId
  });

  ParentRequest.fromJson(Map<String, dynamic> json) {
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['parentId'] = parentId;
    return _data;
  }
}