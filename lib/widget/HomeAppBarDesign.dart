// // ignore_for_file: unnecessary_const

// import 'package:ekidzee/helper/KidzeePref.dart';
// import 'package:ekidzee/helper/LocalConstant.dart';
// import 'package:flutter/material.dart';

// class HomeAppBarDesign extends StatelessWidget{
//   HomeAppBarDesign( this.title) : super(key: null);

//   final title;

//   @override
//   Size get preferredSize => const Size.fromHeight(60);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Color.fromARGB(255, 42, 143, 194),
//       centerTitle: false,
//       automaticallyImplyLeading: true,
//       title: PreferredSize(
//           child: Center(child: getAppBottomView()),
//           preferredSize: const Size.fromHeight(0.0)),

//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(10),
//         ),
//       ),
//       leading: InkWell(
//         onTap: () {},
//         child: const Icon(
//           Icons.subject,
//           color: Colors.white,
//         ),
//       ),
//       actions: [
//         InkWell(
//           onTap: () {},
//           child: const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(
//               Icons.notifications,
//               size: 25,
//             ),
//           ),
//         ),
//       ],

//     );
//   }

//   Widget getAppBottomView() {
//     return Container(
//       padding: const EdgeInsets.only(left:0, top: 0),
//       child: Row(
//         children: [
//           getProfileView(),
//           Container(
//             margin: const EdgeInsets.only(left: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children:  [
//                 Text(
//                   KidzeePref().getString(LocalConstant.KEY_DISPLAY_NAME) ?? '',
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white),
//                 ),
//                 Text(
//                   KidzeePref().getString(LocalConstant.KEY_EMAILID),
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.white,
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget getProfileView() {
//     return Stack(
//       children: const [
//         CircleAvatar(
//           radius: 20,
//           backgroundColor: Colors.white,
//           child: Icon(Icons.person_outline_rounded),
//         ),
//       ],
//     );
//   }
// }
