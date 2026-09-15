class ChangePasswordResponse{
  late final String MSG;

  ChangePasswordResponse({
    required this.MSG
  });

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    MSG = json['MSG'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['MSG'] = MSG;
    return _data;
  }
}