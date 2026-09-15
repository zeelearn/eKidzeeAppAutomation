import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityPlanerModel{
  ActivityPlanerModel({
    this.image_path = '',
    this.title = '',
    this.desc = "",
    this.background = "",
    this.full_image = "",
    this.isDownload = "",
    this.rating = 3.4,
    this.reviews = 80,
  });

  String image_path;
  String title;
  String desc;
  String background;
  String full_image;
  String isDownload;
  double rating;
  int reviews;

  static List<ActivityPlanerModel> bannerlList = <ActivityPlanerModel>[
    ActivityPlanerModel(
      image_path: 'https://firebasestorage.googleapis.com/v0/b/kidzeeandroidapp-91faf.appspot.com/o/MyActivityBanner%2Fw6d2.png?alt=media&token=ce66da8a-2864-484b-8e2e-d78f98a9f83a',
      title: 'Read',
      desc: 'Week 6 Day 1',
      background: "https://firebasestorage.googleapis.com/v0/b/kidzeeandroidapp-91faf.appspot.com/o/MyActivityBanner%2Fmyactivity_background.png?alt=media&token=6634819c-0b2a-4b15-abd7-7c67e964376f",
      full_image: "https://firebasestorage.googleapis.com/v0/b/kidzeeandroidapp-91faf.appspot.com/o/MyActivityBanner%2Fw6d2.png?alt=media&token=ce66da8a-2864-484b-8e2e-d78f98a9f83a",
      isDownload:"true",
    )
  ];

  factory ActivityPlanerModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,

      ) {
    final data = snapshot.data();
    return ActivityPlanerModel(
      image_path: data?['image_path'],
      title: data?['title'],
      desc: data?['desc'],
      background: data?['background'],
      full_image: data?['full_image'],
      isDownload: data?['isDownload'],
      rating: data?['rating'],
      reviews: data?['reviews'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "image_path": image_path,
      "title": title,
      "desc": desc,
      "background": background,
      "full_image": full_image,
      "isDownload": isDownload,
      "rating": rating,
      "reviews": reviews,
    };
  }
}