import 'package:ekidzee/helper/utils.dart';

Future<void> downloadFile(String url) async {
  await Utility.downloadFileIOS(url, url.split('/').last);
}
