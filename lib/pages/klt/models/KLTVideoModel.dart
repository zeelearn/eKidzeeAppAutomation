
import 'klthome.dart';


class KLTVideoDataModel {
  String Message;
  List<KltVideoModel> videoList;

  KLTVideoDataModel(this.Message, this.videoList);

  factory KLTVideoDataModel.fromJson(dynamic json) {
    return KLTVideoDataModel(
        json['Message'] as String,
        List<KltVideoModel>.from(
            json["videoList"].map((x) => KltVideoModel.fromJson(x))));
  }
  @override
  String toString() {
    return '{ ${this.Message}, ${this.videoList} }';
  }
}
