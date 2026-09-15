class QuestionEntity {
  int surveyId;
  String user_id;

  // final String id;
  // final String survey_id;
  // final String text;
  // final List<String> options;
  // final bool isMultiple;

  int? success;
  List<Data>? data;

  QuestionEntity.request({required this.surveyId, required this.user_id})
      : success = null,
        data = null;

  // QuestionEntity.createQuestion({
  //   required this.id,
  //   required this.text,
  //   required this.options,
  //   required this.survey_id,
  //   this.isMultiple = false,
  // })  : surveyId = 0,
  //       user_id = '';

  QuestionEntity.fromJson(Map<String, dynamic> json,
      {required this.surveyId, required this.user_id}) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? msg;
  int? surveyID;
  String? title;
  int? questionID;
  String? questionText;
  String? questionType;
  bool? isMandotry;
  bool? isMediaMandotry;
  int? isShowIntro;
  String? mediaURL;
  String? mediaType;
  List<Options>? options;

  Data(
      {this.surveyID,
      this.msg,
      this.title,
      this.questionID,
      this.questionText,
      this.questionType,
      this.isMandotry,
      this.isMediaMandotry,
      this.isShowIntro,
      this.mediaURL,
      this.mediaType,
      this.options});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    surveyID = json['SurveyID'];
    title = json['Title'];
    questionID = json['QuestionID'];
    questionText = json['QuestionText'];
    isMandotry = json['IsMandatory'] == 1;
    isMediaMandotry = json['isMediaMandotry'] ?? false;
    isShowIntro = json['IsShowIntro'] ?? 1;

    mediaURL = json[
            'MediaURL'] /* ??
        /* 'https://fastly.picsum.photos/id/218/200/300.jpg?hmac=S2tW-K1x-k9tZ7xyNVAdnie_NW9LJEby6GBgYpL7kfo' */ 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4' */
        ;
    mediaType = json['MediaType'] /* ?? 'video' */;
    questionType = json['QuestionType'];
    if (json['Options'] != null) {
      options = <Options>[];
      json['Options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    data['SurveyID'] = surveyID;
    data['Title'] = title;
    data['QuestionID'] = questionID;
    data['QuestionText'] = questionText;
    data['IsMandatory'] = isMandotry! ? 1 : false;
    data['isMediaMandotry'] = isMediaMandotry;
    data['IsShowIntro'] = isShowIntro;
    data['MediaURL'] = mediaURL;
    data['MediaType'] = mediaType;
    data['QuestionType'] = questionType;
    if (options != null) {
      data['Options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? optionID;
  String? optionText;

  Options({this.optionID, this.optionText});

  Options.fromJson(Map<String, dynamic> json) {
    optionID = json['OptionID'];
    optionText = json['OptionText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OptionID'] = optionID;
    data['OptionText'] = optionText;
    return data;
  }
}
