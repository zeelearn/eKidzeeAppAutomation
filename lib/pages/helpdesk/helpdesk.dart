// import 'package:ekidzee/api/APIService.dart';
// import 'package:expandable_text/expandable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../api/request/helpdesk/helpdesk_request.dart';
// import '../../api/response/helpdesk/helpdesk_response.dart';
// import '../../helper/KidzeePref.dart';
// import '../../helper/LocalConstant.dart';
// import '../../helper/utils.dart';
// import 'helpdesk_details.dart';
//
// class HelpDeskScreen extends StatefulWidget {
//   const HelpDeskScreen({super.key});
//
//   @override
//   _HelpDeskScreen createState() => _HelpDeskScreen();
// }
//
// class _HelpDeskScreen extends State<HelpDeskScreen> {
//   late HelpDeskListResponse helpdeskInfo;
//
//   KidzeePref mKidzeePref = KidzeePref();
//   String userId = '';
//   String userType = '';
//   String frichanceId = '';
//
//   List<HelpdeskModel> mHelpDeskModel = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     mKidzeePref.init();
//     loadData();
//     super.initState();
//   }
//
//   loadData() async {
//     mKidzeePref.init();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString(LocalConstant.KEY_UID) as String;
//     userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
//     frichanceId = prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
//     loadHolidayList();
//   }
//
//   void loadHolidayList() {
//     isLoading = true;
//     HelpdeskRequest request = HelpdeskRequest(
//         user_id: int.parse(userId),
//         FeatureQuestionAnswer_Id: 1,
//         Answer: userType,
//         PageNo: 1,
//         search_Text: '',
//         PageSize: 50);
//
//     APIService apiService = APIService();
//     apiService.getHelpdeskList(request).then((value) {
//       if (value != null) {
//         isLoading = false;
//         mHelpDeskModel.clear();
//         if (value != null) {
//           helpdeskInfo = value;
//           mHelpDeskModel.addAll(helpdeskInfo.data);
//         } else {
//           //debugPrint('null value');
//         }
//         setState(() {});
//       } else {
//         //debugPrint("null value");
//       }
//       //Navigator.pop(context);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         /*  floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (BuildContext context) =>
//                     CreateHelpDeskRequestScreen()));
//           },
//           child: Icon(
//             Icons.add,
//           ),
//         ), */
//         body: Container(
//           padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Center(
//                 child: Text(
//                   "Helpdesk",
//                   style: TextStyle(
//                       color: Colors.blueAccent,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//               getData(),
//             ],
//           ),
//         ));
//   }
//
//   Widget getData() {
//     if (isLoading) {
//       return Center(
//         child: Lottie.asset('assets/json/kidzee_loader.json'),
//       );
//     } else if (mHelpDeskModel.isEmpty) {
//       return Utility.emptyDataSet(context);
//     } else {
//       return Flexible(
//           child: ListView.builder(
//         itemCount: mHelpDeskModel.length,
//         shrinkWrap: true,
//         padding: const EdgeInsets.only(top: 16),
//         itemBuilder: (context, index) {
//           return getView(mHelpDeskModel[index]);
//         },
//       ));
//     }
//   }
//
//   getView(HelpdeskModel model) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (BuildContext context) => HelpDeskDetailScreen(
//                   helpdeskModule: model,
//                 )));
//       },
//       child: Padding(
//         padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 8),
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: const [
//               BoxShadow(
//                 blurRadius: 3,
//                 color: Color(0x430F1113),
//                 offset: Offset(0, 1),
//               )
//             ],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                       child: Text(
//                         'Date : ${model.createdDate}',
//                         style: const TextStyle(
//                           fontFamily: 'Lexend Deca',
//                           color: Color(0xFF4B39EF),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                       child: Text(
//                         'Ref Id : ${model.helpdeskId}',
//                         style: const TextStyle(
//                           fontFamily: 'Lexend Deca',
//                           color: Color(0xFF4B39EF),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ListTile(
//                   title: Padding(
//                     padding: const EdgeInsetsDirectional.all(0),
//                     child: Text(
//                       model.issueTitle!,
//                       style: const TextStyle(
//                         fontFamily: 'Lexend Deca',
//                         color: Color(0xFF090F13),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   subtitle: ExpandableText(
//                     model.issueDescription == null
//                         ? ''
//                         : model.issueDescription!,
//                     expandText: 'show more',
//                     maxLines: 3,
//                     linkColor: Colors.blue,
//                     animation: true,
//                     collapseOnTextTap: true,
//                     hashtagStyle: const TextStyle(
//                       color: Color(0xFF30B6F9),
//                     ),
//                     mentionStyle: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                     urlStyle: const TextStyle(
//                         decoration: TextDecoration.underline,
//                         fontFamily: 'Roboto'),
//                   ),
//                   //),
//                   trailing: Container(
//                     margin: const EdgeInsets.all(1.0),
//                     padding: const EdgeInsets.all(3.0),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent)),
//                     child: Text(model.indentStatus! == ''
//                         ? model.status!
//                         : model.indentStatus!),
//                   )),
//               Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.only(left: 20.0, right: 20),
//                 child: Table(
//                   children: [
//                     TableRow(children: [
//                       const Text('Type'),
//                       Text(model.issueType == null || model.issueType! == ''
//                           ? ''
//                           : model.issueType!),
//                     ]),
//                     TableRow(children: [
//                       const Text('Subcategory'),
//                       Text(model.issueSubcategory == null ||
//                               model.issueSubcategory! == ''
//                           ? ''
//                           : model.issueSubcategory!),
//                     ]),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
//                 child: GestureDetector(
//                   child: const Text('Read More',
//                       style: TextStyle(color: Colors.blue)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
