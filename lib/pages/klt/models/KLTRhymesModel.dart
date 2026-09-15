
import 'package:ekidzee/pages/klt/models/rhymesmodel.dart';



class KLTRhymesDataModel {

  List<KltRhymesModel> videoList;

  KLTRhymesDataModel( this.videoList);

  factory KLTRhymesDataModel.fromJson(dynamic json) {
    return KLTRhymesDataModel(
        List<KltRhymesModel>.from(
            json["rhymes"].map((x) => KltRhymesModel.fromJson(x))));
  }
  @override
  String toString() {
    return '{ ${this.videoList} }';
  }
}
