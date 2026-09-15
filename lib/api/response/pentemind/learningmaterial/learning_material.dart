import '../../../../globals.dart';

class LearningMaterialResponse {
  LearningMaterialResponse({
    required this.success,
    required this.data,
  });
  late final int success;
  late final Data data;

  LearningMaterialResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final data1 = <String, dynamic>{};
    data1['success'] = success;
    data1['data'] = data.toJson();
    return data1;
  }
}

class Data {
  Data({
    required this.CName,
    required this.mateialList,
  });
  late final String CName;
  late final List<LearningMaterialModel> mateialList;

  Data.fromJson(Map<String, dynamic> json) {
    CName = json.containsKey('CName') ? json['CName'] : '';
    mateialList = json.containsKey('LRNMTS')
        ? List.from(json['LRNMTS'])
            .map((e) => LearningMaterialModel.fromJson(e))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['CName'] = CName;
    data['LRNMTS'] = mateialList.map((e) => e.toJson()).toList();
    return data;
  }
}

class LearningMaterialModel {
  LearningMaterialModel({
    required this.RefKey,
    required this.RefValue,
    required this.MediaType,
    required this.ContentCategory,
    required this.ContentDescription,
    required this.WebUrl,
    required this.ThumbnailURL,
    required this.BackgroundURL,
  });
  late final String RefKey;
  late final String RefValue;
  late final String MediaType;
  late final String ContentCategory;
  late final String ContentDescription;
  late final String WebUrl;
  late final String ThumbnailURL;
  late final String BackgroundURL;

  LearningMaterialModel.fromJson(Map<String, dynamic> json) {
    // debugPrint(json);
    RefKey = convertStringJson(json, 'RefKey'); //json['RefKey'] ?? '';
    RefValue = convertStringJson(json, 'RefValue'); //json['RefValue'] ?? '';
    MediaType = convertStringJson(json, 'MediaType'); //json['MediaType'] ?? '';
    ContentCategory = convertStringJson(
        json, 'ContentCategory'); //json['ContentCategory'] ?? '';
    ContentDescription = convertStringJson(
        json, 'ContentDescription'); //json['ContentDescription'] ?? '';
    WebUrl = convertStringJson(json, 'WebUrl'); //json['WebUrl'] ?? '';
    ThumbnailURL =
        convertStringJson(json, 'ThumbnailURL'); //json['ThumbnailURL'] ?? '';
    BackgroundURL =
        convertStringJson(json, 'BackgroundURL'); //json['BackgroundURL'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['RefKey'] = RefKey;
    data['RefValue'] = RefValue;
    data['MediaType'] = MediaType;
    data['ContentCategory'] = ContentCategory;
    data['ContentDescription'] = ContentDescription;
    data['WebUrl'] = WebUrl;
    data['ThumbnailURL'] = ThumbnailURL;
    data['BackgroundURL'] = BackgroundURL;
    return data;
  }
}
