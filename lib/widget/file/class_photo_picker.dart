// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dropzone/flutter_dropzone.dart';
// import 'package:get/get.dart';
//
// class ClassPhotoPicker extends StatefulWidget {
//   final RxString imageUrl;
//   final Function(String path) onImageSelected;
//
//   const ClassPhotoPicker({
//     super.key,
//     required this.imageUrl,
//     required this.onImageSelected,
//   });
//
//   @override
//   State<ClassPhotoPicker> createState() => _ClassPhotoPickerState();
// }
//
// class _ClassPhotoPickerState extends State<ClassPhotoPicker> {
//   DropzoneViewController? dropzoneController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Container(
//         height: 200,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Stack(
//           children: [
//             if (kIsWeb)
//               DropzoneView(
//                 onCreated: (ctrl) => dropzoneController = ctrl,
//                 onDrop: (file) async {
//                   final bytes =
//                   await dropzoneController!.getFileData(file);
//                   widget.onImageSelected("web_image");
//                 },
//               ),
//             Center(
//               child: widget.imageUrl.value.isEmpty
//                   ? const Text("Drag & Drop or Click to Upload")
//                   : Image.network(
//                 widget.imageUrl.value,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
