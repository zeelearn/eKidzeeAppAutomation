// import 'package:ekidzee/api/response/Holidaynfo.dart';
// import 'package:expandable_text/expandable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../api/APIService.dart';
// import '../../api/request/ledger/ledger_request.dart';
// import '../../api/response/ledger/MyLedgerResponse.dart';
// import '../../helper/KidzeePref.dart';
// import '../../helper/LocalConstant.dart';
// import '../../helper/utils.dart';
//
// class MyLedgerScreen extends StatefulWidget {
//   const MyLedgerScreen({super.key});
//
//   @override
//   _MyLedgerScreen createState() => _MyLedgerScreen();
// }
//
// class _MyLedgerScreen extends State<MyLedgerScreen> {
//   final String _currentAcademicYear = '';
//
//   late LedgerResponse ledgerInfo;
//   KidzeePref mKidzeePref = KidzeePref();
//   String userId = '';
//   String userType = '';
//   String frichanceId = '';
//   int Status_ID = 0;
//   String From_Date = "";
//   String To_Date = "";
//   String SelectedYearVal = "";
//   String SelectedMonthVal = "11";
//   String Type = "KID";
//
//   List<LedgerModel> ledgerModel = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     mKidzeePref.init();
//     loadData();
//     super.initState();
//     From_Date = startDate();
//     To_Date = endDate();
//   }
//
//   String endDate() {
//     DateTime dt = DateTime.now();
//     String newDate = '';
//     try {
//       newDate = DateFormat('dd-MMM-yyyy').format(dt);
//     } catch (e) {
//       e.toString();
//     }
//     return newDate;
//   }
//
//   String startDate() {
//     DateTime pastMonth = DateTime.now().subtract(const Duration(days: 90));
//     String newDate = '';
//     try {
//       newDate = DateFormat('dd-MMM-yyyy').format(pastMonth);
//     } catch (e) {
//       e.toString();
//     }
//     return newDate;
//   }
//
//   loadData() async {
//     mKidzeePref.init();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString(LocalConstant.KEY_USER_ID) as String;
//     userType = prefs.getString(LocalConstant.KEY_USER_TYPE) as String;
//     frichanceId = prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
//     loadLedger();
//   }
//
//   void loadLedger() {
//     isLoading = true;
//     APIService apiService = APIService();
//     LedgerRequest request = LedgerRequest(
//         Franchisee_Id: int.parse(frichanceId),
//         Status_ID: Status_ID,
//         From_Date: From_Date,
//         To_Date: To_Date,
//         SelectedYearVal: SelectedYearVal,
//         SelectedMonthVal: SelectedMonthVal,
//         Type: Type);
//
//     debugPrint('Request of ledger api is - ${request.getJson()}');
//     apiService.getMyLedger(request).then((value) {
//       debugPrint('Response from ledger api is - ${value.toString()}');
//       if (value != null) {
//         isLoading = false;
//         ledgerModel.clear();
//         if (value != null) {
//           ledgerInfo = value;
//           ledgerModel.addAll(ledgerInfo.data);
//         } else {
//           //debugPrint('null value');
//         }
//         setState(() {});
//       } else {
//         //Navigator.pop(context);
//         Utility.showMessage(context, "Unable to load Ledger");
//         //debugPrint("null value");
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Center(
//                 child: Text(
//                   "My Ledger ",
//                   style: TextStyle(
//                       color: Colors.blueAccent,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//
//               /*Row(
//             children: [
//               Text("Select Month", style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600
//               ),),
//               SizedBox(width: 10,),
//               DropdownButton<String>(
//                 value: _currentAcademicYear,
//                 items: academicYearList.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   _currentAcademicYear = value!;;
//                   //debugPrint(_currentAcademicYear);
//                   loadHolidayList();
//                 },
//               ),
//             ],
//           ),*/
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
//     } else if (ledgerModel.isEmpty) {
//       return Utility.emptyDataSet(context);
//     } else {
//       return Flexible(
//           child: ListView.builder(
//         itemCount: ledgerModel.length,
//         shrinkWrap: true,
//         padding: const EdgeInsets.only(top: 16),
//         itemBuilder: (context, index) {
//           return getView(ledgerModel[index]);
//         },
//       ));
//     }
//   }
//
//   getView(LedgerModel model) {
//     return GestureDetector(
//       onTap: () {},
//       child: Padding(
//         padding: const EdgeInsetsDirectional.fromSTEB(2, 5, 0, 2),
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
//                         'Date : ${model.transDAte!}',
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
//                         'Tran Id : ${model.transId}',
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
//                       model.transType!,
//                       style: const TextStyle(
//                         fontFamily: 'Lexend Deca',
//                         color: Color(0xFF090F13),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   subtitle: ExpandableText(
//                     model.transDesc!,
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
//                     child: Text('₹ ${model.transAmount!}'),
//                   )),
//               Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.only(left: 20.0, right: 20),
//                 child: Table(
//                   children: [
//                     TableRow(children: [
//                       const Text('Status'),
//                       Text(
//                           model.indentStatus != null || model.indentStatus != ''
//                               ? model.indentStatus!
//                               : 'NA'),
//                     ]),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   DateTime parseDate(String value) {
//     DateTime dt = DateTime.now();
//     try {
//       dt = DateFormat('dd MMM yyyy').parse(value);
//     } catch (e) {
//       e.toString();
//     }
//     return dt;
//   }
// }
//
// class HolidayAdaptar extends StatefulWidget {
//   HolidayInfoModel holidayInfoModel;
//   HolidayAdaptar({super.key, required this.holidayInfoModel});
//
//   @override
//   _HolidayAdaptar createState() => _HolidayAdaptar();
// }
//
// class _HolidayAdaptar extends State<HolidayAdaptar> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         padding:
//             const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 children: <Widget>[
//                   Image.asset(
//                     'assets/icons/ic_holiday.png',
//                     width: 15,
//                   ),
//                   const SizedBox(
//                     width: 16,
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             widget.holidayInfoModel.description,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(
//                             height: 6,
//                           ),
//                           Text(
//                             '${widget.holidayInfoModel.fromDate} to ${widget.holidayInfoModel.toDate}',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade600,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               widget.holidayInfoModel.holidayTypeCode,
//               style:
//                   const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
