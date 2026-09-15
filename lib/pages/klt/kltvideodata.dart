import 'package:ekidzee/pages/klt/models/rhymesmodel.dart';
import 'package:flutter/cupertino.dart';

import 'models/klthome.dart';


List<KltRhymesModel> getRhymes(){
  List<KltRhymesModel> data = <KltRhymesModel>[];
  return data;
}

List<KltVideoModel> getVideoList() {
  List<KltVideoModel> data = <KltVideoModel>[];

  data.add(KltVideoModel(
      videoId: 1,
      classId: 3,
      videoName: "AIR TRANSPORT",
      thumbanilUrl:
          "http://103.241.146.154/KLT/PG/Videos_Thumbnails/Air%20Transports_PG-01.png",
      videoUrl: "http://103.241.146.154/KLT/PG/Videos/AIR TRANSPORT.mp4",
      duration: "",
      views: 100,
      DecryptionKey: "",
      backgroundColor: const Color(0xffFBB97C)));

  data.add(KltVideoModel(
      videoId: 1,
      classId: 3,
      videoName: "BIRDS",
      thumbanilUrl:
          "http://103.241.146.154/KLT/PG/Videos_Thumbnails/Birds_PG-01.png",
      videoUrl: "http://103.241.146.154/KLT/PG/Videos/BIRDS.mp4",
      duration: "",
      views: 100,
      DecryptionKey: "",
      backgroundColor: const Color(0xffFBB97C)));

  data.add(KltVideoModel(
      videoId: 1,
      classId: 3,
      videoName: "INSECTS & OTHER SMALL ANIMALS",
      thumbanilUrl:
          "http://103.241.146.154/KLT/PG/Videos_Thumbnails/Insects%20and%20others_PG-01.png",
      videoUrl: "http://103.241.146.154/KLT/PG/Videos/BIRDS.mp4",
      duration: "",
      views: 100,
      DecryptionKey: "",
      backgroundColor: const Color(0xffFBB97C)));

  return data;
}
