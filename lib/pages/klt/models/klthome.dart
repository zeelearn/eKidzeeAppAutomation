import 'dart:ui';

import 'package:flutter/cupertino.dart';

class KltVideoModel {
  KltVideoModel({
    required this.videoId,
    required this.classId,
    required this.videoName,
    required this.thumbanilUrl,
    required this.videoUrl,
    required this.duration,
    required this.views,
    required this.DecryptionKey,
    required this.backgroundColor,
  });
  int videoId;
  int classId;
  String videoName;
  String thumbanilUrl;
  String videoUrl;
  String duration;
  int views;
  String DecryptionKey;
  Color backgroundColor;

  factory KltVideoModel.fromJson(dynamic json) {
    return KltVideoModel(
        videoId: json['Video_ID'] as int,
        classId: json['Class_ID'] as int,
        videoName: json['Video_Name'] as String,
        thumbanilUrl: json['Video_Thumbnail_URL'] as String,
        videoUrl: json['Video_URL'] as String,
        duration: json['Video_Duration'] as String,
        views: json['NoOfDownloads_Views'] as int,
        DecryptionKey: json['DecryptionKey'] as String,
        backgroundColor: const Color(0xffFBB97C));
  }
}
