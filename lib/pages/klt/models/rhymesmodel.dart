import 'dart:ui';

import 'package:flutter/cupertino.dart';

class KltRhymesModel {
  KltRhymesModel({
    required this.videoId,
    required this.classId,
    required this.videoName,
    required this.thumbanilUrl,
    required this.videoUrl,
    required this.duration,
    required this.views,
    required this.DecryptionKey,
    required this.backgroundColor,
    required this.Rhyme_Type
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
  String Rhyme_Type;

  factory KltRhymesModel.fromJson(dynamic json) {
    return KltRhymesModel(
        videoId: json['Rhyme_ID'] as int,
        classId: json['Class_ID'] as int,
        videoName: json['Rhyme_Name'] as String,
        thumbanilUrl: json['Rhyme_Thumbnail_URL'] as String,
        videoUrl: json['Rhyme_URL'] as String,
        duration: json['Rhyme_Duration'] as String,
        views: json['NoOfDownloads_Views'] as int,
        DecryptionKey: json['DecryptionKey'] as String,
        Rhyme_Type: json['Rhyme_Type'] as String,
        backgroundColor: const Color(0xffFBB97C));
  }
}
