// import 'package:ekidzee/api/APIService.dart';
// import 'package:expandable_text/expandable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../api/request/helpdesk/log_request.dart';
// import '../../api/response/helpdesk/HelpdeslLogResponse.dart';
// import '../../api/response/helpdesk/helpdesk_response.dart';
// import '../../constants.dart';
// import '../../helper/KidzeePref.dart';
// import '../../helper/LocalConstant.dart';
// import '../../helper/utils.dart';
//
//
// class HelpDeskDetailScreen extends StatefulWidget {
//   late HelpdeskModel helpdeskModule;
//   HelpDeskDetailScreen({required this.helpdeskModule});
//
//   @override
//   _HelpDeskDetailScreen createState() => _HelpDeskDetailScreen();
// }
//
// class _HelpDeskDetailScreen extends State<HelpDeskDetailScreen> {
//
//   late HelpDeskLogResponse helpdeskInfo;
//
//   KidzeePref mKidzeePref = KidzeePref();
//   String userId='';
//   String userType='';
//   String frichanceId='';
//
//   List<HelpDeskLogModel> mHelpDeskModel = [];
//   bool isLoading = true;
//
//   String _currentType='Log History';
//   List<String> helpDeskTypes = ['Log History','Remarks','Upload'];
//
//
//   @override
//   void initState() {
//     mKidzeePref.init();
//     loadData();
//     super.initState();
//
//   }
//
//   loadData() async {
//     mKidzeePref.init();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString(LocalConstant.KEY_UID) as String;
//     userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
//     frichanceId = prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
//     logLogHistory();
//   }
//
//   getHelpdesk(HelpdeskModel model) {
//     return GestureDetector(
//       onTap: () {
//
//       },
//       child: Padding(
//         padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 8),
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
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
//                 padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                       child: Text(
//                         'Date : ${model.createdDate}',
//                         style: TextStyle(
//                           fontFamily: 'Lexend Deca',
//                           color: Color(0xFF4B39EF),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                       child: Text(
//                         'Ref Id : ${model.helpdeskId}',
//                         style: TextStyle(
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
//
//               ListTile(
//                   title: Padding(
//                     padding: EdgeInsetsDirectional.all(0),
//                     child: Text(
//                       '${model.issueTitle!}',
//                       style: const TextStyle(
//                         fontFamily: 'Lexend Deca',
//                         color: Color(0xFF090F13),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   subtitle: ExpandableText(
//                     model.issueDescription==null ? '' : model.issueDescription!,
//                     expandText: 'show more',
//                     maxLines: 3,
//                     linkColor: Colors.blue,
//                     animation: true,
//                     collapseOnTextTap: true,
//                     hashtagStyle: TextStyle(
//                       color: Color(0xFF30B6F9),
//                     ),
//                     mentionStyle: TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                     urlStyle: TextStyle(
//                         decoration: TextDecoration.underline,
//                         fontFamily: 'Roboto'
//                     ),
//                   ),
//                   //),
//                   trailing: Container(
//                     margin: const EdgeInsets.all(1.0),
//                     padding: const EdgeInsets.all(3.0),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent)
//                     ),
//                     child: Text(model.indentStatus! =='' ? model.status! : model.indentStatus!),
//                   )
//               ),
//               Container(
//                 color: Colors.white,
//                 padding: EdgeInsets.only(
//                     left: 20.0,right: 20),
//                 child: Table(
//
//                   children: [
//                     TableRow(children: [
//                       Text('Type'),
//                       Text(model.issueType==null || model.issueType! =='' ? '' : model.issueType!),
//
//                     ]),
//                     TableRow(children: [
//                       Text('Subcategory'),
//                       Text(model.issueSubcategory==null || model.issueSubcategory! =='' ? '' : model.issueSubcategory!),
//                     ]),
//
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
//                 child: GestureDetector(
//                   child: Text('Read More',style: TextStyle(color: Colors.blue)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   void logLogHistory(){
//     isLoading=true;
//     HelpdeskLogRequest request= new HelpdeskLogRequest(HelpdeskID: widget.helpdeskModule.helpdeskId!.toInt(), UserID: int.parse(userId));
//     setState(() {
//
//     });
//     APIService apiService = APIService();
//     apiService.getHelpdeskLOG(request).then((value) {
//       if (value != null) {
//         isLoading = false;
//         mHelpDeskModel.clear();
//         if(value !=null){
//           helpdeskInfo = value ;
//           mHelpDeskModel.addAll(helpdeskInfo.data);
//         }else {
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
//   void getHelpdeskRemark(){
//     isLoading=true;
//     HelpdeskLogRequest request= new HelpdeskLogRequest(HelpdeskID: widget.helpdeskModule.helpdeskId!.toInt(), UserID: int.parse(userId));
//     setState(() {
//
//     });
//     APIService apiService = APIService();
//     apiService.getHelpdeskRemark(request).then((value) {
//       if (value != null) {
//         isLoading = false;
//         mHelpDeskModel.clear();
//         if(value !=null){
//           helpdeskInfo = value ;
//           mHelpDeskModel.addAll(helpdeskInfo.data);
//         }else {
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
//     backgroundColor: Colors.white,
//     appBar: getAppbar(),
//     body: Container(
//         padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Center(
//             child: Text("Helpdesk", style: TextStyle(
//                 color: Colors.blueAccent,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600
//             ),),
//           ),
//           getHelpdesk(widget.helpdeskModule),
//           SizedBox(width: 10,),
//           Center(
//             child: DropdownButton<String>(
//               focusColor:Colors.white,
//               value: _currentType,
//               //elevation: 5,
//               style: TextStyle(color: Colors.white),
//               iconEnabledColor:Colors.black,
//               items: helpDeskTypes.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value,style:TextStyle(color:Colors.black),),
//                 );
//               }).toList(),
//               hint: const Text(
//                 "Please choose a Type",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500),
//               ),
//               onChanged: (value) {
//                 //debugPrint('onChange');
//                 _currentType = value as String;
//                 if(_currentType == 'Log History'){
//                   logLogHistory();
//                 }else if(_currentType == 'Remarks'){
//                   getHelpdeskRemark();
//                 }else if(_currentType == 'Upload'){
//                   logLogHistory();
//                 }
//               },
//             ),
//           ),
//           SizedBox(width: 10,),
//           getData(),
//         ],
//       ),
//     ) );
//   }
//
//   AppBar getAppbar(){
//     return AppBar(
//       backgroundColor: kPrimaryLightColor,
//       centerTitle: true,
//       title: const Text(
//         'HelpDesk',
//         style:
//         TextStyle(fontSize: 17, color: Colors.white, letterSpacing: 0.53),
//       ),
//       /*shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(20),
//         ),
//       ),*/
//       leading: InkWell(
//         onTap: () {
//           Navigator.of(context).pop();
//         },
//         child: const Icon(
//           Icons.arrow_back,
//           color: Colors.white,
//         ),
//       ),
//
//       /*bottom: PreferredSize(
//           child: getAppBottomView(),
//           preferredSize: Size.fromHeight(80.0)),*/
//     );
//   }
//
//   Widget getData(){
//     if (isLoading) {
//       return Center(
//         child: Lottie.asset('assets/json/kidzee_loader.json'),
//       );
//     } else  if( (_currentType =='Remarks' && helpdeskInfo.remarkList==null) || (_currentType =='Log History' && (mHelpDeskModel.length==0))){
//       return Utility.emptyDataSet(context);
//     }else {
//       //debugPrint(_currentType);
//       return Flexible(child: ListView.builder(
//         itemCount: _currentType =='Remarks' ? helpdeskInfo.remarkList.length : mHelpDeskModel.length,
//         shrinkWrap: true,
//         padding: EdgeInsets.only(top: 16),
//         itemBuilder: (context, index) {
//           return _currentType =='Remarks' ? getRemarkView(helpdeskInfo.remarkList[index]) :  getView(helpdeskInfo.data[index]);
//         },
//       ));
//     }
//   }
//
//   getView(HelpDeskLogModel model) {
//     return GestureDetector(
//       onTap: () {
//
//       },
//       child: Padding(
//         padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 8),
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
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
//                 padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                       child: Text(
//                         'Date : ${model.createdDate}',
//                         style: TextStyle(
//                           fontFamily: 'Lexend Deca',
//                           color: Color(0xFF4B39EF),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                       child: Text(
//                         'Created By : ${model.userName}',
//                         style: TextStyle(
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
//                     padding: EdgeInsetsDirectional.all(0),
//                     child: Text(
//                       '${model.status!}',
//                       style: const TextStyle(
//                         fontFamily: 'Lexend Deca',
//                         color: Color(0xFF090F13),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   subtitle: ExpandableText(
//                     'Turnaround Time : ${model.tURNAROUND==null || model.tURNAROUND! =='' ? 'NA' : model.tURNAROUND!}',
//                     expandText: 'show more',
//                     maxLines: 3,
//                     linkColor: Colors.blue,
//                     animation: true,
//                     collapseOnTextTap: true,
//                     hashtagStyle: TextStyle(
//                       color: Color(0xFF30B6F9),
//                     ),
//                     mentionStyle: TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                     urlStyle: TextStyle(
//                         decoration: TextDecoration.underline,
//                         fontFamily: 'Roboto'
//                     ),
//                   ),
//                   //),
//
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   getRemarkView(HelpDeskRemarkModel model) {
//     //debugPrint('getRemark view');
//     return GestureDetector(
//       onTap: () {
//
//       },
//       child: Padding(
//         padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 8),
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
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
//                 padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                       child: Text(
//                         'Date : ${model.createdDate}',
//                         style: TextStyle(
//                           fontFamily: 'Lexend Deca',
//                           color: Color(0xFF4B39EF),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                       child: Text(
//                         'Created By : ${model.userName}',
//                         style: TextStyle(
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
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: ExpandableText(
//                   'Remark : ${model.remarks==null || model.remarks! =='' ? 'NA' : model.remarks!}',
//                   expandText: 'show more',
//                   maxLines: 3,
//                   linkColor: Colors.blue,
//                   animation: true,
//                   collapseOnTextTap: true,
//                   hashtagStyle: TextStyle(
//                     color: Color(0xFF30B6F9),
//                   ),
//                   mentionStyle: TextStyle(
//                     fontWeight: FontWeight.w600,
//                   ),
//                   urlStyle: TextStyle(
//                       decoration: TextDecoration.underline,
//                       fontFamily: 'Roboto'
//                   ),
//                 ),
//               )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
