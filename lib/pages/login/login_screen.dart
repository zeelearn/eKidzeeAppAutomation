// import 'package:flutter/material.dart';
//
// import '../../Responsive.dart';
// import '../components/background.dart';
// import 'components/login_form.dart';
// import 'components/login_screen_top_image.dart';
//
// class LoginScreen extends StatelessWidget {
//   Map<String, String> params;
//
//   LoginScreen({required this.params, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Background(
//       child: SingleChildScrollView(
//         child: Responsive(
//           mobile: MobileLoginScreen(),
//           desktop: Row(
//             children: [
//               Expanded(
//                 child: LoginScreenTopImage(),
//               ),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 450,
//                       child: LoginForm(params: params),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MobileLoginScreen extends StatelessWidget {
//   const MobileLoginScreen({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         SingleChildScrollView(
//           child: LoginScreenTopImage(),
//         ),
//         Row(
//           children: [
//             Spacer(),
//             Expanded(
//               flex: 8,
//               child: LoginForm(
//                 params: <String, String>{},
//               ),
//             ),
//             Spacer(),
//           ],
//         ),
//       ],
//     );
//   }
// }
