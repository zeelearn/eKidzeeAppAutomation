// import 'package:ekidzee/api/request/digital_resouce_request.dart';
// import 'package:ekidzee/helper/LocalConstant.dart';
// import 'package:ekidzee/helper/utils.dart';
// import 'package:ekidzee/pages/ecampus/widget/pdfviewer.dart';
// import 'package:ekidzee/ui/app_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../api/APIService.dart';
// import '../../helper/LightColor.dart';
// import '../../videoplayer/ChewieDemo.dart';
// import '../../widget/file/path_bar.dart';
// import '../../widget/file_list_button.dart';
// import 'ecampus_view.dart';

// class CloudScreen extends StatefulWidget  {

//   String supportIndex;
//   CloudScreen({Key? key,required this.supportIndex}) : super(key: key);


//   @override
//   // ignore: library_private_types_in_public_api
//   _CloudScreen createState() => _CloudScreen();

// }
// class ECampusObservar {
//   onContentClickListener(FileDetail data) {}
// }

// class ECampusHistoryModel{
//   late final int index;
//   late final String currentPath;
//   late final String previousPath;
//   late final String content;

//   ECampusHistoryModel({
//     required this.index,
//     required this.currentPath,
//     required this.previousPath,
//     required this.content,
//   });

// }
// class ECampusScreen extends StatefulWidget{
//   const ECampusScreen({Key? key}) : super(key: key);

//   @override
//   _ECampusScreen createState() => _ECampusScreen();
// }
// class _ECampusScreen extends State<ECampusScreen> {
//   int _selectedIndex = 0;

//   final pages = [
//     //CloudScreen(supportIndex: "1"),
//     CloudScreen(supportIndex: "2"),
//   ];

//   void _onItemTapped(int index) {
//     _selectedIndex = index;

//   }

//   @override
//   void initState() {
//     super.initState();

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: pages[_selectedIndex],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Colors.white,
//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//           selectedItemColor: LightColor.darkBlue,
//           unselectedItemColor: Colors.grey.shade300,
//           type: BottomNavigationBarType.fixed,

//           selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: LightColor.purple),
//           unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, color: LightColor.darkgrey),
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.computer),
//                 label: 'Digital Resource',
//             ),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.computer),
//                 label: 'Digital Support',
//             ),
//           ],
//           //type: BottomNavigationBarType.shifting,
//           currentIndex: _selectedIndex,
//           //selectedItemColor: Colors.black,
//           iconSize: 40,
//           onTap: (int index) {
//             _onItemTapped(index);
//             setState((){
//               this._selectedIndex = index; }); },
//           elevation: 5
//       ),
//     );
//   }
// }

// class _CloudScreen extends State<CloudScreen> implements ECampusObservar{
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

//     }else if(data.UploadType == FileType.WorkSheet){
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => goToMyPdf(worksheetUrl: data.path, title: 'Kidzee Worksheet', filename: data.supportName+'.pdf', module: 'cs',),
//         ),
//       );
//     }else if (data.UploadType == FileType.Video) {

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ChewieDemo(
//               fileDetails: data,Title : data.supportName
//             )),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (false) {
//       return Center(
//         child: new CircularProgressIndicator(),
//       );
//     } else {
//       return getWidget(context);
//     }
//   }

//   Widget getWidget(BuildContext context) {
//       return Column(
//         children: [
//           Expanded(
// // First we check if the ViewModel is busy (isBusy :) definitely) and display the Shimmer
//             child: _loadingInProgress
//                 ? Shimmer.fromColors(
//               baseColor: Colors.grey[50]!,
//               highlightColor: Colors.grey[300]!,
//               child: ListView.builder(
//                 itemCount: 6,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     elevation: 1.0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: const SizedBox(height: 80),
//                   );
//                 },
//               ),
//             )
//                 : getContent(),
//           )
//         ],
//       );
//   }
//   Widget getContent() {
//     return Column(
//       children:  <Widget>[
//         Container(
//           child: PathBar(
//             paths: paths,
//             icon: Icons.sd_card,
//             onChanged: (index) {
//               if(index==0){
//                 paths.clear();
//                 path = "HOME";
//                 paths.add("HOME");
//                 supportPath="";
//                 historyList.clear();
//                 loadDigitalResource();
//               }else {

//                 path = paths[index];
//                 for(int j=index+1;j<historyList.length;j++){
//                   historyList.removeAt(index);
//                 }
//                 paths.removeRange(index + 1, paths.length);
//                 pop();

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
//                     const SizedBox(height: 0),
//                     Padding(
//                       padding:  EdgeInsets.all(0),
//                       child: renderContent(),
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
  
//   renderContent(){
//     if(eCampusData.length>0) {
//       return eCampusView(
//           data: eCampusData, observar: observar
//       );
//     }else{
//       return Utility.emptyDataSet(context);
//     }
//   }

//   void pop(){

//     historyList.removeLast();
//     supportPath = historyList.last.currentPath;
//     loadDigitalResource();
//   }

//   void push(FileDetail data,String supportName){
//       String path  = data.ContentDescription;

//       if(supportPath.isEmpty){
//         supportPath  = data.ContentDescription;
//       }else{
//         supportPath = "$supportPath/${data.ContentDescription}";
//       }
//       path = supportPath;
//       historyList.add(ECampusHistoryModel(index: historyList.length + 1, currentPath: path, previousPath: supportName, content: data.ContentDescription));
//       loadDigitalResource();
//   }


//   readPref() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = await prefs.getString(LocalConstant.KEY_UID) ?? "";
//   }

//   Future<void> loadDigitalResource() async {
//     eCampusData.clear();
//     setState(() {
//       _loadingInProgress = true;
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId =  prefs.getString(LocalConstant.KEY_UID)! ;
//     DigitalResouceRequest request = DigitalResouceRequest(User_id: "107",
//         digitalCategoryId: widget.supportIndex,
//         KeySupport: supportPath);
//     ////debugPrint("Response");
//     //debugPrint(request.toJson());
//     APIService apiService = APIService();
//     apiService.getDigitalResouce(request).then((value) async {
//       if (value != null) {

//         ////debugPrint("Response");
//         //debugPrint(value.toJson());
//         for (var support in value.data) {
//           String dyntubeWebUrl = support.dyntubeWebUrl == null ? '' : support.dyntubeWebUrl as String;
//           eCampusData.add(FileDetail(supportName: support.supportName as String, time: support.className as String,
//               ClassName: support.className as String,
//               UploadType: getSupportType(support.uploadType), path: support.url==null? '' : support.url as String,
//           RootPath: support.rootPath as String,
//           ContentDescription: support.contentDescription as String,
//           dyntubeWeb_url: dyntubeWebUrl ,
//           dyntubeApp_url: dyntubeWebUrl));
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
//   FileType type = FileType.Folder;
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

