
import 'package:flutter/material.dart';
import '../ui/app_helpers.dart';
import '../ui/custom_icons.dart';

class FileTypeIcon extends StatelessWidget {

  const FileTypeIcon(this.type, {this.size = 50, Key? key}) : super(key: key);

  final double size;
  final FileType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      // decoration: BoxDecoration(
      //   color: Color.fromRGBO(235, 222, 240,0.4),
      //   gradient: _gradient(type),
      //   borderRadius: BorderRadius.circular(size / 5),
      // ),
      child: Image.asset(getImage(type)),
    );
  }

  getImage(FileType type){
    String image = 'assets/icons/ic_folder.png';
    switch (type) {
      case FileType.Folder:
        image = 'assets/icons/ic_folder.png';
        break;
      case FileType.WorkSheet:
        image = 'assets/icons/ic_worksheet.png';
        break;
      case FileType.Video:
        image = 'assets/icons/ic_video.png';
        break;
      case FileType.Rhymes:
        image = 'assets/icons/ic_worksheet.png';
        break;
      case FileType.Artwork:
        image = 'assets/icons/ic_rhymes.png';
        break;
      case FileType.other:
        image = 'assets/icons/ic_alerts.png';
        break;
      default:
        image = 'assets/icons/ic_alerts.png';
        break;
    }
    return image;
  }

  //_icon(type)

  Widget _icon(FileType type) {
    late IconData iconData;

    switch (type) {
      case FileType.Folder:
        iconData = CustomIcons.cloud_outlined;
        break;
      case FileType.WorkSheet:
        iconData = CustomIcons.ms_access;
        break;
      case FileType.Video:
        iconData = CustomIcons.ms_excel;
        break;
      case FileType.Rhymes:
        iconData = CustomIcons.ms_outlook;
        break;
      case FileType.Artwork:
        iconData = CustomIcons.ms_power_point;
        break;
      case FileType.other:
        iconData = CustomIcons.ms_word;
        break;
      default:
        iconData = Icons.extension;
        break;
    }

    return Icon(
      iconData,
      color: Colors.white,
      size: size / 2,
    );
  }

  LinearGradient _gradient(FileType type) {
    switch (type) {
      case FileType.WorkSheet:
        return const LinearGradient(colors: [
          Colors.redAccent,
          Colors.red,
        ]);
      case FileType.Video:
        return const LinearGradient(colors: [
          Colors.greenAccent,
          Colors.green,
        ]);
      case FileType.other:
        return const LinearGradient(colors: [
          Colors.lightBlueAccent,
          Colors.lightBlue,
        ]);
      case FileType.Artwork:
        return const LinearGradient(colors: [
          Colors.orangeAccent,
          Colors.orange,
        ]);
      case FileType.Rhymes:
        return const LinearGradient(colors: [
          Colors.blueAccent,
          Colors.blue,
        ]);
      default:
        return const LinearGradient(colors: [
          Colors.deepOrangeAccent,
          Colors.deepOrange,
        ]);
    }
  }
}
