class DigitalResourceResponseModel{

  late List<DigitalResourceResponse> data;

  DigitalResourceResponseModel({ required this.data});

  DigitalResourceResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DigitalResourceResponse>[];
      json['data'].forEach((v) {
        data.add(DigitalResourceResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class DigitalResourceResponse{

  final String? supportDate;
  final String? supportName;
  final String? className;
  final int? rowNo;
  final String? uploadType;
  final String? subjectName;
  final String? rootPath;
  final String? contentDescription;
  final String? url;
  final int? tierId;
  final int? appID;
  final String? detailId;
  final bool? isVirtualRollover;
  final String? rolloverMsg;
  final String? dyntubeKey;
  final String? dyntubeWebUrl;
  final String? dyntubeAppUrl;
  final int? dSCRatio;

  DigitalResourceResponse({
    this.supportDate,
    this.supportName,
    this.className,
    this.rowNo,
    this.uploadType,
    this.subjectName,
    this.rootPath,
    this.contentDescription,
    this.url,
    this.tierId,
    this.appID,
    this.detailId,
    this.isVirtualRollover,
    this.rolloverMsg,
    this.dyntubeKey,
    this.dyntubeWebUrl,
    this.dyntubeAppUrl,
    this.dSCRatio,
  });

  DigitalResourceResponse.fromJson(Map<String, dynamic> json)
      : supportDate = json['SupportDate'] as String?,
        supportName = json['SupportName'] as String?,
        className = json['ClassName'] as String?,
        rowNo = json['RowNo'] as int?,
        uploadType = json['UploadType'] as String?,
        subjectName = json['SubjectName'] as String?,
        rootPath = json['RootPath'] as String?,
        contentDescription = json['ContentDescription'] as String?,
        url = json['Url'] as String?,
        tierId = json['TierId'] as int?,
        appID = json['AppID'] as int?,
        detailId = json['DetailId'],
        isVirtualRollover = json['IsVirtualRollover'] as bool?,
        rolloverMsg = json['RolloverMsg'] as String?,
        dyntubeKey = json['dyntube_key'],
        dyntubeWebUrl = json['dyntubeWeb_url'],
        dyntubeAppUrl = json['dyntubeApp_url'],
        dSCRatio = json['DSCRatio'] as int?;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SupportDate'] = this.supportDate;
    data['SupportName'] = this.supportName;
    data['ClassName'] = this.className;
    data['RowNo'] = this.rowNo;
    data['UploadType'] = this.uploadType;
    data['SubjectName'] = this.subjectName;
    data['RootPath'] = this.rootPath;
    data['ContentDescription'] = this.contentDescription;
    data['Url'] = this.url;
    data['TierId'] = this.tierId;
    data['AppID'] = this.appID;
    data['DetailId'] = this.detailId;
    data['IsVirtualRollover'] = this.isVirtualRollover;
    data['RolloverMsg'] = this.rolloverMsg;
    data['dyntube_key'] = this.dyntubeKey;
    data['dyntubeWeb_url'] = this.dyntubeWebUrl;
    data['dyntubeApp_url'] = this.dyntubeAppUrl;
    data['DSCRatio'] = this.dSCRatio;
    return data;
  }

}