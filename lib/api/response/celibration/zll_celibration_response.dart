class ZllResourceResponse {
  ZllResourceResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final List<CelibrationModel> data;

  ZllResourceResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>CelibrationModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
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
  });
  late final int eventId;
  late final String title;
  late final String validfrom;
  late final String validto;
  late final String contenturl;
  late final String viewurl;
  late final String displayIn;
  late final String visibleTo;

  CelibrationModel.fromJson(Map<String, dynamic> json){
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
    final _data = <String, dynamic>{};
    _data['event_id'] = eventId;
    _data['title'] = title;
    _data['validfrom'] = validfrom;
    _data['validto'] = validto;
    _data['contenturl'] = contenturl;
    _data['viewurl'] = viewurl;
    _data['display_in'] = displayIn;
    _data['visible_to'] = visibleTo;
    return _data;
  }
}