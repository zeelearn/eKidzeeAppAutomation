// import 'package:ekidzee/helper/KidzeePref.dart';
// import 'package:ekidzee/helper/LocalConstant.dart';
// import 'package:flutter/material.dart';

// import '../../widget/appbar_widget.dart';
// import '../../widget/profile_widget.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     final user = KidzeePref();

//     return Scaffold(
//       appBar: buildAppBar(context),
//       body: ListView(
//         physics: BouncingScrollPhysics(),
//         children: [
//           ProfileWidget(
//             imagePath: 'https://cdn-icons.flaticon.com/png/512/1144/premium/1144709.png?token=exp=1656304692~hmac=e9d30d19660c10c99de06ca45111bc7e',
//             onClicked: () async {},
//           ),
//           const SizedBox(height: 24),
//           buildName(),
//           const SizedBox(height: 24),
//           // Center(child: buildUpgradeButton()),
//           // const SizedBox(height: 24),
//           // NumbersWidget(),
//           // const SizedBox(height: 48),
//           buildAbout(),
//         ],
//       ),
//     );
//   }

//   Widget buildName() => Column(
//     children: [
//       Text(
//         KidzeePref().getString(LocalConstant.KEY_DISPLAY_NAME),
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//       ),
//       const SizedBox(height: 4),
//       Text(
//         KidzeePref().getString(LocalConstant.KEY_EMAILID),
//         style: TextStyle(color: Colors.grey),
//       )
//     ],
//   );

//   // Widget buildUpgradeButton() => ButtonWidget(
//   //   text: 'Upgrade To PRO',
//   //   onClicked: () {},
//   // );

//   Widget buildAbout() => Container(
//     padding: EdgeInsets.symmetric(horizontal: 48),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'About',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           KidzeePref().getString(LocalConstant.KEY_DISPLAY_NAME),
//           style: TextStyle(fontSize: 16, height: 1.4),
//         ),
//       ],
//     ),
//   );
// }
