import 'package:flutter/material.dart';

import '../ui/app_helpers.dart';
import 'file_type_icon.dart';


class FileDetail {
  final String supportName;
  final String time;
  final FileType UploadType;
  final String path;
  final String ClassName;
  final String RootPath;
  final String ContentDescription;
  final String? DetailId;
  final bool? IsVirtualRollover;
  final String? RolloverMsg;
  final String? dyntube_key;
  final String? dyntubeWeb_url;
  final String? dyntubeApp_url;


  const FileDetail(
      {required this.supportName,
      required this.time,
        required this.ClassName,
      required this.UploadType,
      required this.path,
        required this.RootPath,
        required this.ContentDescription,
        this.DetailId,
        this.IsVirtualRollover,
        this.RolloverMsg,
        this.dyntube_key,
        required this.dyntubeWeb_url,
        required this.dyntubeApp_url
      });
}

class FileListButton extends StatelessWidget {
  final ValueChanged<FileDetail> onChange;
  const FileListButton({
    required this.data,
    required this.onPressed,
    Key? key,
    required this.onChange,
  }) : super(key: key);

  final FileDetail data;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.white,
      child: ListTile(
        leading: FileTypeIcon(data.UploadType),
        title: Text(
          data.ContentDescription,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          data.time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // subtitle: Text(
        //   filesize(data.size),
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        // ),
        tileColor: Colors.white,
        onTap: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        trailing: IconButton(
          onPressed: () {
            onChange(data);
          },
          icon: Icon(Icons.more_vert_outlined),
          tooltip: "more",
        ),
      ),
    );
  }
}
