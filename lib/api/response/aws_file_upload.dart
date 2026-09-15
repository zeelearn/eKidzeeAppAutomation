class AwsFileUploadResponse {
  AwsFileUploadResponse({
    required this.message,
    required this.data,
  });
  late final String message;
  late final List<Data> data;

  AwsFileUploadResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.fieldname,
    required this.originalname,
    required this.encoding,
    required this.mimetype,
    required this.size,
    required this.bucket,
    required this.key,
    required this.acl,
    required this.contentType,
    this.contentDisposition,
    this.contentEncoding,
    required this.storageClass,
    this.serverSideEncryption,
    required this.metadata,
    required this.location,
    required this.etag,
  });
  late final String fieldname;
  late final String originalname;
  late final String encoding;
  late final String mimetype;
  late final int size;
  late final String bucket;
  late final String key;
  late final String acl;
  late final String contentType;
  late final Null contentDisposition;
  late final Null contentEncoding;
  late final String storageClass;
  late final Null serverSideEncryption;
  late final Metadata metadata;
  late final String location;
  late final String etag;

  Data.fromJson(Map<String, dynamic> json){
    fieldname = json['fieldname'];
    originalname = json['originalname'];
    encoding = json['encoding'];
    mimetype = json['mimetype'];
    size = json['size'];
    bucket = json['bucket'];
    key = json['key'];
    acl = json['acl'];
    contentType = json['contentType'];
    contentDisposition = null;
    contentEncoding = null;
    storageClass = json['storageClass'];
    serverSideEncryption = null;
    metadata = Metadata.fromJson(json['metadata']);
    location = json['location'];
    etag = json['etag'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fieldname'] = fieldname;
    _data['originalname'] = originalname;
    _data['encoding'] = encoding;
    _data['mimetype'] = mimetype;
    _data['size'] = size;
    _data['bucket'] = bucket;
    _data['key'] = key;
    _data['acl'] = acl;
    _data['contentType'] = contentType;
    _data['contentDisposition'] = contentDisposition;
    _data['contentEncoding'] = contentEncoding;
    _data['storageClass'] = storageClass;
    _data['serverSideEncryption'] = serverSideEncryption;
    _data['metadata'] = metadata.toJson();
    _data['location'] = location;
    _data['etag'] = etag;
    return _data;
  }
}

class Metadata {
  Metadata({
    required this.fieldName,
  });
  late final String fieldName;

  Metadata.fromJson(Map<String, dynamic> json){
    fieldName = json['fieldName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fieldName'] = fieldName;
    return _data;
  }
}