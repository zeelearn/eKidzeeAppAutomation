// import 'package:ekidzee/api/APIService.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../api/request/helpdesk/subcategory_request.dart';
// import '../../api/response/helpdesk/helpdesk_category.dart';
// import '../../api/response/helpdesk/subcategory.dart';
// import '../../constants.dart';
// import '../../helper/KidzeePref.dart';
// import '../../helper/LocalConstant.dart';
//
//
// class CreateHelpDeskRequestScreen extends StatefulWidget {
//
//   CreateHelpDeskRequestScreen(): super();
//
//   @override
//   _CreateHelpDeskRequestScreen createState() => _CreateHelpDeskRequestScreen();
// }
//
// class _CreateHelpDeskRequestScreen extends State<CreateHelpDeskRequestScreen> {
//
//   late HelpDeskCategoryResponse categoryResponse;
//   late HelpDeskSubCategoryResponse subCategoryResponse;
//
//   KidzeePref mKidzeePref = KidzeePref();
//   String userId='';
//   String userType='';
//   String frichanceId='';
//
//   List<HelpDeskCategoryModel> mCategoryList = [];
//   List<HelpDeskSubCategoryModel> mSubCategoryList = [];
//   bool isLoading = true;
//
//   String _currentCategory='Select';
//   String _currentSubCategory='Select';
//   List<String> _category = [];
//   List<String> _subcategory = [];
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
//   void logLogHistory(){
//     isLoading=true;
//     setState(() {
//
//     });
//     APIService apiService = APIService();
//     apiService.getHelpDeskCategory().then((value) {
//       if (value != null) {
//         isLoading = false;
//         mCategoryList.clear();
//         _category.clear();
//
//         if(value !=null){
//           categoryResponse = value ;
//           mCategoryList.addAll(categoryResponse.data);
//           _currentCategory = mCategoryList[0].issueType!;
//           for(int index=0;index<mCategoryList.length;index++){
//             _category.add(mCategoryList[index].issueType!);
//           }
//         }else {
//           //debugPrint('null value');
//         }
//         getSubCategory(_currentCategory);
//       } else {
//         //debugPrint("null value");
//       }
//       //Navigator.pop(context);
//     });
//   }
//
//   int getCategory(String name){
//     int id=0;
//     for(int index=0;index<mCategoryList.length;index++){
//       if(name == mCategoryList[index].issueType!){
//         id = mCategoryList[index].businessIssueId!;
//       }
//     }
//     return id;
//   }
//
//   void getSubCategory(String name){
//     isLoading=true;
//     HelpdeskSubCategoryRequest request= new HelpdeskSubCategoryRequest(ID: getCategory(name));
//     setState(() {
//
//     });
//     APIService apiService = APIService();
//     apiService.getHelpdeskSubCategory(request).then((value) {
//       if (value != null) {
//         isLoading = false;
//         mSubCategoryList.clear();
//         _subcategory.clear();
//         if(value !=null){
//           subCategoryResponse = value ;
//           mSubCategoryList.addAll(subCategoryResponse.data);
//           _currentSubCategory = mSubCategoryList[0].name!;
//           for(int index=0;index<mSubCategoryList.length;index++){
//             _subcategory.add(mSubCategoryList[index].name!);
//           }
//           //debugPrint(_currentSubCategory);
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
//
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
//           SizedBox(width: 10,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text("Category", style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 12,
//               ),),
//               DropdownButton<String>(
//                 focusColor:Colors.white,
//                 value: _currentCategory,
//                 //elevation: 5,
//                 style: TextStyle(color: Colors.white),
//                 iconEnabledColor:Colors.black,
//                 items: _category.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value,style:TextStyle(color:Colors.black),),
//                   );
//                 }).toList(),
//                 hint: const Text(
//                   "Please choose a Type",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500),
//                 ),
//                 onChanged: (value) {
//                   //debugPrint('onChange');
//                   _currentCategory = value as String;
//                   getSubCategory(_currentCategory);
//                   /*if(_currentType == 'Log History'){
//                   logLogHistory();
//                 }else if(_currentType == 'Remarks'){
//                   getHelpdeskRemark();
//                 }else if(_currentType == 'Upload'){
//                   logLogHistory();
//                 }*/
//                 },
//               ),
//             ],
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text("Sub Category", style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 12
//               ),),
//               DropdownButton<String>(
//                 focusColor:Colors.white,
//                 value: _currentSubCategory,
//                 //elevation: 5,
//                 style: TextStyle(color: Colors.white),
//                 iconEnabledColor:Colors.black,
//                 items: _subcategory.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value,style:TextStyle(color:Colors.black),),
//                   );
//                 }).toList(),
//                 hint: const Text(
//                   "Please choose a Sub Category",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500),
//                 ),
//                 onChanged: (value) {
//                   //debugPrint('onChange');
//                   _currentSubCategory = value as String;
//                   /*if(_currentType == 'Log History'){
//                     logLogHistory();
//                   }else if(_currentType == 'Remarks'){
//                     getHelpdeskRemark();
//                   }else if(_currentType == 'Upload'){
//                     logLogHistory();
//                   }*/
//                 },
//               ),
//             ],
//           ),
//           SizedBox(width: 15,),
//           Container(
//             margin: EdgeInsets.only(left: 20,right:20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20,),
//                 TextField(
//
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Issue Title',
//                   ),
//                   onChanged: (text) {
//                     setState(() {
//
//                       //you can access nameController in its scope to get
//                       // the value of text entered as shown below
//                       //fullName = nameController.text;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 20,),
//                 TextField(
//                   maxLength: 400,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Issue Description',
//                   ),
//                   onChanged: (text) {
//                     setState(() {
//
//                       //you can access nameController in its scope to get
//                       // the value of text entered as shown below
//                       //fullName = nameController.text;
//                     });
//                   },
//                 ),
//                 SizedBox(width: 10,),
//               ],
//             ),
//           ),
//           Center(
//             child: CupertinoButton.filled(
//               onPressed: () {},
//               child: const Text('Submit'),
//             ),
//           ),
//
//
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
//
// }
//
