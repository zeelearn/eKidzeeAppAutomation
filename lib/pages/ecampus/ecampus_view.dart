// import 'package:ekidzee/pages/ecampus/CloudScreen.dart';
// import 'package:flutter/material.dart';
// import '../../widget/file_list_button.dart';

// class eCampusView extends StatelessWidget {
//   const eCampusView({required this.data, Key? key, required this.observar}) : super(key: key);
//   final ECampusObservar observar;
//   final List<FileDetail> data;
//   @override
//   Widget build(BuildContext context) {
//     //debugPrint('ecampus view');
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ...data
//             .map(
//               (e) => FileListButton(
//                 data: e,
//                 onPressed: () {

//                   //openContent(context, e);
//                   observar.onContentClickListener(e);
//                 },
//                 onChange: (FileDetail data) {
//                   //debugPrint("open content onChange " + data.ContentDescription);
//                   //openContent(context, data);
//                 },
//               ),
//             )
//             .toList()
//       ],
//     );
//   }

//   void openContent(BuildContext context, FileDetail fileDetail) {
//     //debugPrint("openContent --- ");
//     //if (fileDetail.UploadType == FileType.Folder){
//       ECampusObservar().onContentClickListener(fileDetail);
//     //}
//     // if (fileDetail.type == FileType.WorkSheet) {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => goToMyPdf(),
//     //     ),
//     //   );
//     // } else if (fileDetail.type == FileType.Video) {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //         builder: (context) => VideoApp(
//     //               fileDetails: fileDetail,
//     //             )),
//     //   );
//     // } else if (fileDetail.type == FileType.Artwork) {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //         builder: (context) =>
//     //             ImageViewer(title: fileDetail.name, url: fileDetail.path)),
//     //   );
//     // }
//   }
// }
