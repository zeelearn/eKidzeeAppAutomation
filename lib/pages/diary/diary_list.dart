// import 'package:flutter/material.dart';
// import 'package:styled_widget/styled_widget.dart';

// import '../../api/response/diary_response.dart';
// import '../../helper/LightColor.dart';
// import '../../helper/utils.dart';
// import '../../ui/theme.dart';

// class UserPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final page = ({child}) => Styled.widget(child: child)
//         .padding(vertical: 10, horizontal: 10)
//         .constrained(minHeight: MediaQuery.of(context).size.height - (2 * 30))
//         .scrollable();

//     return <Widget>[
//       Settings(),
//     ].toColumn().parent(page);
//   }
// }

// class ActionsRow extends StatelessWidget {
//   Widget _buildActionItem(String name, IconData icon) {
//     final Widget actionIcon = Icon(icon, size: 20, color: Color(0xFF42526F))
//         .alignment(Alignment.center)
//         .ripple()
//         .constrained(width: 50, height: 50)
//         .backgroundColor(Color(0xfff6f5f8))
//         .clipOval()
//         .padding(bottom: 5);

//     final Widget actionText = Text(
//       name,
//       style: TextStyle(
//         color: Colors.black.withOpacity(0.8),
//         fontSize: 12,
//       ),
//     );

//     return <Widget>[
//       actionIcon,
//       actionText,
//     ].toColumn().padding(vertical: 20);
//   }

//   @override
//   Widget build(BuildContext context) => <Widget>[
//         _buildActionItem('Wallet', Icons.attach_money),
//         _buildActionItem('Delivery', Icons.card_giftcard),
//         _buildActionItem('Message', Icons.message),
//         _buildActionItem('Service', Icons.room_service),
//       ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround);
// }

// class SettingsItemModel {
//   final IconData icon;
//   final Color color;
//   final String title;
//   final String description;

//   const SettingsItemModel({
//     required this.color,
//     required this.description,
//     required this.icon,
//     required this.title,
//   });
// }

// const List<SettingsItemModel> settingsItems = [
//   SettingsItemModel(
//     icon: Icons.location_on,
//     color: Color(0xff8D7AEE),
//     title: '',
//     description: '',
//   ),
// ];

// class Settings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => settingsItems
//       .map((settingsItem) => SettingsItem(
//             settingsItem.icon,
//             settingsItem.color,
//             settingsItem.title,
//             settingsItem.description,
//           ))
//       .toList()
//       .toColumn();
// }

// class SettingsItem extends StatefulWidget {
//   SettingsItem(this.icon, this.iconBgColor, this.title, this.description);

//   final IconData icon;
//   final Color iconBgColor;
//   final String title;
//   final String description;

//   @override
//   _SettingsItemState createState() => _SettingsItemState();
// }

// class _SettingsItemState extends State<SettingsItem> {
//   bool pressed = false;
//   List<DiaryInfo> _diaryList = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     _diaryList.add(DiaryInfo(
//         diaryID: 87476,
//         diaryTitle: 'Topics covered today 7/10/21',
//         diaryMessage:
//             'Dear parents,\n\nThe school will remain closed from 3rd Nov to 14th November for Diwali vacation. The school will reopen on 15th Nov’21 ie on Monday.\n\nThank you ',
//         diaryDate: '02 Nov 2021',
//         diaryCreatedBy: '191780',
//         teacherName: 'Ranju',
//         diaryStudentID: 2339201,
//         studentID: 1564814,
//         studentName: 'HITAKSHI LAKUM',
//         remark: 'Ok',
//         remarkDate: '23 Nov 2021',
//         isRemarked: true));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             /*_header(context),*/

//             SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     getData(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   clipClick(String actionString) {
//     //debugPrint(actionString);
//     if (actionString == 'DATE_SEL') {
//       /*_onPressed(context: context);*/
//     }
//   }

//   Widget getData() {
//     if (_diaryList.length > 0) {
//       return ListView.builder(
//         itemCount: _diaryList.length,
//         shrinkWrap: true,
//         padding: EdgeInsets.only(top: 16),
//         physics: NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           return _DiaryInfo(context, _diaryList[index],
//               _decorationContainerA(Colors.redAccent, -110, -85),
//               background: LightColor.seeBlue);
//         },
//       );
//     } else {
//       return Utility.emptyDataSet(context);
//     }
//   }

//   Widget _decorationContainerA(Color primaryColor, double top, double left) {
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           top: top,
//           left: left,
//           child: CircleAvatar(
//             radius: 100,
//             backgroundColor: LightColor.darkseeBlue,
//           ),
//         ),
//         _smallContainer(LightColor.yellow, 40, 20),
//         Positioned(
//           top: -30,
//           right: -10,
//           child: _circularContainer(80, Colors.transparent,
//               borderColor: Colors.white),
//         ),
//         Positioned(
//           top: 110,
//           right: -50,
//           child: CircleAvatar(
//             radius: 60,
//             backgroundColor: LightColor.darkseeBlue,
//             child:
//                 CircleAvatar(radius: 40, backgroundColor: LightColor.seeBlue),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _circularContainer(double height, Color color,
//       {Color borderColor = Colors.transparent, double borderWidth = 2}) {
//     return Container(
//       height: height,
//       width: height,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         border: Border.all(color: borderColor, width: borderWidth),
//       ),
//     );
//   }

//   Positioned _smallContainer(Color primaryColor, double top, double left,
//       {double radius = 10}) {
//     return Positioned(
//         top: top,
//         left: left,
//         child: CircleAvatar(
//           radius: radius,
//           backgroundColor: primaryColor.withAlpha(255),
//         ));
//   }

//   Widget _DiaryInfo(BuildContext context, DiaryInfo model, Widget decoration,
//       {required Color background}) {
//     return Card(
//         color: Colors.white,
//         elevation: 8,
//         child: GestureDetector(
//           onTap: () {
//             //onEventItemClick(model);
//           },
//           child: Container(
//             padding: EdgeInsets.all(10),
//             width: MediaQuery.of(context).size.width - 20,
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(height: 15),
//                     Container(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           Expanded(
//                             child: Text(model.diaryTitle,
//                                 style: const TextStyle(
//                                     color: LightColor.purple,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold)),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Text('Remark : ${model.remark.toString()}',
//                               style: const TextStyle(
//                                 color: LightColor.grey,
//                                 fontSize: 14,
//                               )),
//                           const SizedBox(width: 10)
//                         ],
//                       ),
//                     ),
//                     Text('Teacher Name : ${model.teacherName.toString()}',
//                         style: AppTheme.h6Style.copyWith(
//                           fontSize: 12,
//                           color: LightColor.grey,
//                         )),
//                     const SizedBox(height: 15),
//                     Text(model.diaryMessage,
//                         style: AppTheme.h6Style.copyWith(
//                             fontSize: 12, color: LightColor.extraDarkPurple)),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: <Widget>[
//                         Text('Event Date : ',
//                             style: AppTheme.h6Style.copyWith(
//                                 fontSize: 12,
//                                 color: LightColor.extraDarkPurple)),
//                         _chip('', model.diaryDate, LightColor.darkOrange,
//                             height: 5),
//                         SizedBox(
//                           width: 20,
//                         ),
//                       ],
//                     )
//                   ],
//                 ))
//               ],
//             ),
//           ),
//         ));
//   }

//   Widget _card(BuildContext context,
//       {Color primaryColor = Colors.redAccent, required Widget backWidget}) {
//     return Card(
//       child: Container(
//         height: 150,
//         width: MediaQuery.of(context).size.width * .34,
//         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//             color: primaryColor,
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                   offset: Offset(0, 5),
//                   blurRadius: 10,
//                   color: Color(0x12000000))
//             ]),
//         child: ClipRRect(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           child: backWidget,
//         ),
//       ),
//     );
//   }

//   Widget _chip(String actionString, String text, Color textColor,
//       {double height = 0, bool isPrimaryCard = false}) {
//     return GestureDetector(
//       //onTap: clipClick(actionString),
//       onTap: () => clipClick(actionString),
//       child: Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(15)),
//           color: textColor.withAlpha(isPrimaryCard ? 150 : 50),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//               color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
//         ),
//       ),
//     );
//   }
// }
