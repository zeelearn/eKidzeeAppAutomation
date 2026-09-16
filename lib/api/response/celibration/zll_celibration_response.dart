class ZllResourceResponse {
  ZllResourceResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<CelibrationModel> data;

  ZllResourceResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = List.from(json['data'])
        .map((e) => CelibrationModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{};
    payload['success'] = success;
    payload['data'] = data.map((e) => e.toJson()).toList();
    return payload;
  }
}

class CelibrationModel {
  CelibrationModel({
    required this.eventId,
    required this.title,
    required this.validfrom,
    required this.validto,
    required this.contenturl,
    required this.viewurl,
    required this.displayIn,
    this.visibleTo = '',
  });
  late final int eventId;
  late final String title;
  late final String validfrom;
  late final String validto;
  late final String contenturl;
  late final String viewurl;
  late final String displayIn;
  late final String visibleTo;

  CelibrationModel.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    title = json['title'];
    validfrom = json['validfrom'];
    validto = json['validto'];
    contenturl = json['contenturl'];
    viewurl = json['viewurl'];
    displayIn = json['display_in'];
    visibleTo = json['visible_to'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['event_id'] = eventId;
    data['title'] = title;
    data['validfrom'] = validfrom;
    data['validto'] = validto;
    data['contenturl'] = contenturl;
    data['viewurl'] = viewurl;
    data['display_in'] = displayIn;
    data['visible_to'] = visibleTo;
    return data;
  }
}
