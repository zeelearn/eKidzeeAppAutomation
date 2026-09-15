// import 'package:flutter/cupertino.dart';
//
// import 'class_details_controller.dart';
//
// class ClassDetailsForm extends StatelessWidget {
//   final ClassDetailsController controller;
//
//   const ClassDetailsForm({
//     super.key,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Column(
//         children: [
//           _buildDropdown(),
//           _buildTextField("Franchisee Code",
//               controller.franchiseCode, true),
//           _buildTextField("Class Facilitator",
//               controller.classFacilitator, false),
//           _buildTextField("Center Head / Principal",
//               controller.centerHead, false),
//           ClassPhotoPicker(
//             imageUrl: controller.classPhotoUrl,
//             onImageSelected: (path) {
//               controller.classPhotoUrl.value = path;
//             },
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: controller.submit,
//             child: const Text("Submit"),
//           )
//         ],
//       ),
//     );
//   }
// }
