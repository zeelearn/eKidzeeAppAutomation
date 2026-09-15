class InductionContentResponse{

  late List<ContentModule> data;

  InductionContentResponse({ required this.data});

  InductionContentResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ContentModule>[];
      json['data'].forEach((v) {
        data.add(ContentModule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
      return data;
  }
}

class ContentModule {
  String? id;
  double? iPDMContentID;
  String? iPDContentName;
  String? iPDContentThumbnailURL;
  String? iPDContentURL;
  String? iPDContentDecryptionKey;
  int? iPDContentSequenceNumber;
  String? contenStatus;
  String? iPDContentType;

  ContentModule(
      {this.id,
        this.iPDMContentID,
        this.iPDContentName,
        this.iPDContentThumbnailURL,
        this.iPDContentURL,
        this.iPDContentDecryptionKey,
        this.iPDContentSequenceNumber,
        this.contenStatus,
        this.iPDContentType});

  ContentModule.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    iPDMContentID = json['IPDM_ContentID'];
    iPDContentName = json['IPD_ContentName'];
    iPDContentThumbnailURL = json['IPD_ContentThumbnailURL'];
    iPDContentURL = json['IPD_ContentURL'];
    iPDContentDecryptionKey = json['IPD_ContentDecryptionKey'];
    iPDContentSequenceNumber = json['IPD_ContentSequenceNumber'];
    contenStatus = json['ContenStatus'];
    iPDContentType = json['IPD_ContentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['IPDM_ContentID'] = this.iPDMContentID;
    data['IPD_ContentName'] = this.iPDContentName;
    data['IPD_ContentThumbnailURL'] = this.iPDContentThumbnailURL;
    data['IPD_ContentURL'] = this.iPDContentURL;
    data['IPD_ContentDecryptionKey'] = this.iPDContentDecryptionKey;
    data['IPD_ContentSequenceNumber'] = this.iPDContentSequenceNumber;
    data['ContenStatus'] = this.contenStatus;
    data['IPD_ContentType'] = this.iPDContentType;
    return data;
  }
}
