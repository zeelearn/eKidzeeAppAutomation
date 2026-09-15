import 'package:ekidzee/pages/k12/presentation/pages/folders/tree_page.dart';
import 'package:flutter/material.dart';

class FoldersStructureModel {
  int? success;
  List<FolderData>? data;

  FoldersStructureModel({this.success, this.data});

  FoldersStructureModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    if (json['data'] != null) {
      data = <FolderData>[];
      json['data'].forEach((v) {
        data!.add(FolderData.fromJson(v));
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

class FolderData {
  late int contentid;
  List<FolderModel>? folders;
  List<FolderFiles>? files;
  List<MyNode> nodes = [];

  FolderData({this.folders, this.files, required this.contentid});

  FolderData.fromJson(Map<String, dynamic> json) {
    contentid = json.containsKey('contentid') ? json['contentid'] : 0;
//     debugPrint('content id ${contentid}');
    if (json['Folders'] != null) {
      folders = <FolderModel>[];
      debugPrint('Folders runtime type - ${json['Folders'].runtimeType}');
      json['Folders'].forEach((v) {
        folders!.add(FolderModel.fromJson(v));
      });
    }
    if (json['Files'] != null) {
      files = <FolderFiles>[];
      json['Files'].forEach((v) {
        files!.add(FolderFiles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contentid'] = contentid;
    if (folders != null) {
      //data['Folders'] = this.folders!.map((v) => v.toJson()).toList();
    }
    if (files != null) {
      data['Files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FolderModel {
  final int contentId;
  final String name;
  final int parentContentId;
  final bool isDownload;

  FolderModel(
      {required this.contentId,
      required this.name,
      required this.parentContentId,
      required this.isDownload});

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
        contentId: json['ContentID'],
        name: json['Name'],
        parentContentId: json['ParentContentID'],
        isDownload: json['IsDownload']);
  }
}

class Folders {
  int? contentID;
  String? name;
  int? parentContentID;
  bool? isDownload;

  Folders({this.contentID, this.name, this.parentContentID, this.isDownload});

  Folders.fromJson(Map<String, dynamic> json) {
    contentID = json['ContentID'];
    name = json['Name'];
    parentContentID = json['ParentContentID'];
    isDownload = json.containsKey('IsDownload') ? json['IsDownload'] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ContentID'] = contentID;
    data['Name'] = name;
    data['ParentContentID'] = parentContentID;
    data['IsDownload'] = isDownload;
    return data;
  }
}

class FolderFiles {
  int? pID;
  String? title;
  String? description;
  String? photoDate;
  String? type;
  int? categoryid;
  String? fileName;
  String? url;
  String? dimension;
  String? size;
  String? ext;
  int? projectId;
  String? imgType;
  String? password;

  FolderFiles(
      {this.pID,
      this.title,
      this.description,
      this.photoDate,
      this.type,
      this.categoryid,
      this.fileName,
      this.url,
      this.dimension,
      this.size,
      this.ext,
      this.projectId,
      this.imgType,
      this.password});

  FolderFiles.fromJson(Map<String, dynamic> json) {
    pID = json['PID'];
    title = json['Title'];
    description = json['Description'];
    photoDate = json['PhotoDate'];
    type = json['Type'];
    categoryid = json['Categoryid'];
    fileName = json['FileName'];
    url = json['Url'];
    dimension = json['Dimension'];
    size = json['size'];
    ext = json['ext'];
    projectId = json['ProjectId'];
    imgType = json['ImgType'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PID'] = pID;
    data['Title'] = title;
    data['Description'] = description;
    data['PhotoDate'] = photoDate;
    data['Type'] = type;
    data['Categoryid'] = categoryid;
    data['FileName'] = fileName;
    data['Url'] = url;
    data['Dimension'] = dimension;
    data['size'] = size;
    data['ext'] = ext;
    data['ProjectId'] = projectId;
    data['ImgType'] = imgType;
    data['password'] = password;
    return data;
  }
}
