// import 'package:ekidzee/api/request/digital_resouce_request.dart';
// import 'package:ekidzee/helper/LocalConstant.dart';
// import 'package:ekidzee/pages/ecampus/widget/pdfviewer.dart';
// import 'package:ekidzee/ui/app_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../api/APIService.dart';
// import '../../videoplayer/ChewieDemo.dart';
// import '../../widget/file/path_bar.dart';
// import '../../widget/file_list_button.dart';
// import 'CloudScreen.dart';
// import 'ecampus_view.dart';

// class DigitalResource extends StatefulWidget  {

//   final String supportIndex="2";
//   const DigitalResource({Key? key}) : super(key: key);


//   @override
//   State<DigitalResource> createState() => _DigitalResource();
// /*@override
//   // ignore: library_private_types_in_public_api
//   _CloudScreen createState() => _CloudScreen();*/

// }

// class _DigitalResource extends State<DigitalResource> implements ECampusObservar{
//   List<FileDetail> eCampusData = [];
//   bool isApiCallProcess = false;
//   String supportPath="";
//   String userId="";

//   List<ECampusHistoryModel> historyList = [];

//   late ECampusObservar observar;
//   bool _loadingInProgress = false;

//   void initState() {

//     super.initState();
//     //_loadingInProgress = true;
//     observar = this;
//     readPref();
//     paths.clear();
//     paths.add("HOME");
//     loadDigitalResource();
//   }


//   @override
//   onContentClickListener(FileDetail data) {
//     if (data.UploadType == FileType.Folder) {
//       push(data, supportPath);

//       paths.add(supportPath);
//       // loadDigitalResource();

//     }else if(data.UploadType == FileType.WorkSheet){
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => goToMyPdf(worksheetUrl: data.path, title: data.ContentDescription, filename: '', module: '', ),
//         ),
//       );
//     }else if (data.UploadType == FileType.Video) {

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ChewieDemo(
//                 fileDetails: data,Title : data.supportName
//             )),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //debugPrint('on build called');
//     if (false) {
//       return Center(
//         child: new CircularProgressIndicator(),
//       );
//     } else {
//       return getWidget(context);
//     }
//   }

//   Widget getWidget(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
// // First we check if the ViewModel is busy (isBusy :) definitely) and display the Shimmer
//           child: _loadingInProgress
//               ? Shimmer.fromColors(
//             baseColor: Colors.grey[50]!,
//             highlightColor: Colors.grey[300]!,
//             child: ListView.builder(
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 return Card(
//                   elevation: 1.0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: const SizedBox(height: 80),
//                 );
//               },
//             ),
//           )
//               : getContent(),
//         )
//       ],
//     );
//   }
//   Widget getContent() {
//     return Column(
//       children:  <Widget>[
//         Container(
//           child: PathBar(
//             paths: paths,
//             icon: Icons.sd_card,
//             onChanged: (index) {
//               //debugPrint("on changed ${index}");
//               if(index==0){
//                 paths.clear();
//                 path = "HOME";
//                 paths.add("HOME");
//                 supportPath="";
//                 historyList.clear();
//                 loadDigitalResource();
//               }else {
//                 //debugPrint(paths[index]);
//                 path = paths[index];
//                 for(int j=index+1;j<historyList.length;j++){
//                   historyList.removeAt(index);
//                 }
//                 paths.removeRange(index + 1, paths.length);
//                 pop();
//                 //debugPrint(historyList.last.currentPath);
//               }
//               setState(() {});
//             },
//           ),
//         ),
//         Expanded(
//           child: CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               SliverList(
//                 delegate: SliverChildListDelegate(
//                   [
//                     // const Padding(
//                     //   padding: EdgeInsets.all(kDefaultSpacing),
//                     //   child: _Header(),
//                     // ),
//                     const SizedBox(height: 0),
//                     Padding(
//                       padding:  EdgeInsets.all(0),
//                       child: eCampusView(
//                           data: eCampusData, observar: observar
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }



//   void pop(){
//     //debugPrint(supportPath);
//     historyList.removeLast();
//     supportPath = historyList.last.currentPath;
//     //debugPrint('last Path ${supportPath}');
//     loadDigitalResource();
//   }

//   void push(FileDetail data,String supportName){
//     String path  = data.ContentDescription;
//     //debugPrint('push path-- ${supportPath}');
//     if(supportPath.isEmpty){
//       //debugPrint('Empty support');
//       supportPath  = data.ContentDescription;
//     }else{
//       supportPath = "$supportPath/${data.ContentDescription}";
//     }
//     path = supportPath;
//     //debugPrint('push path ${supportPath}');
//     historyList.add(ECampusHistoryModel(index: historyList.length + 1, currentPath: path, previousPath: supportName, content: data.ContentDescription));
//     ////debugPrint('Pushed Current Path ${historyList.last.currentPath}');
//     loadDigitalResource();
//   }


//   readPref() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = await prefs.getString(LocalConstant.KEY_USER_ID) ?? "";
//   }

//   Future<void> loadDigitalResource() async {
//     //debugPrint("loadDigitalResource");
//     eCampusData.clear();
//     setState(() {
//       _loadingInProgress = true;
//     });
//     //debugPrint("_selectedIndex is "+widget.supportIndex);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId =  prefs.getString(LocalConstant.KEY_UID)! ;
//     DigitalResouceRequest request = DigitalResouceRequest(User_id: userId,
//         digitalCategoryId: widget.supportIndex,
//         KeySupport: supportPath);
//     ////debugPrint("Response");
//     APIService apiService = APIService();
//     apiService.getDigitalResouce(request).then((value) async {
//       if (value != null) {

//         ////debugPrint("Response");
//         ////debugPrint(value.toJson());
//         for (var support in value.data) {
//           String dyntubeWebUrl = support.dyntubeWebUrl == null ? '' : support.dyntubeWebUrl as String;
//           eCampusData.add(FileDetail(supportName: support.supportName as String, time: support.className as String,
//               ClassName: support.className as String,
//               UploadType: getSupportType(support.uploadType), path: support.url==null? '' : support.url as String,
//               RootPath: support.rootPath as String,
//               ContentDescription: support.contentDescription as String,
//               dyntubeWeb_url: dyntubeWebUrl ,
//               dyntubeApp_url: dyntubeWebUrl));
//         }
//             } else {
//         //debugPrint("Value is null");
//       }
//       _loadingInProgress = false;
//       setState(() {
//         _loadingInProgress = false;
//       });

//     });
//   }

//   FileType getSupportType(String? uploadType){
//     FileType type = FileType.Folder;
//     switch(uploadType){
//       case 'pdf':
//         type = FileType.WorkSheet;
//         break;
//       case 'youtube':
//         type = FileType.Video;
//         break;
//       case 'audio':
//         type = FileType.Rhymes;
//         break;
//     }
//     return type;
//   }

//   late String path;
//   List<String> paths = <String>[];

// }