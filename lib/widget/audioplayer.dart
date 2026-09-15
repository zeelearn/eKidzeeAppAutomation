
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';


// class MyAudioApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Home()
//     );
//   }
// }

// class Home extends  StatefulWidget {
//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {

//   int maxduration = 100;
//   int currentpos = 0;
//   String currentpostlabel = "00:00";
//   String audioasset = "assets/images/LetterN.mp3";
//   bool isplaying = false;
//   bool audioplayed = false;
//   late Uint8List audiobytes;

//   AudioPlayer player = AudioPlayer();

//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () async {

//       ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
//       audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
//       //convert ByteData to Uint8List

//       player.onDurationChanged.listen((Duration d) { //get the duration of audio
//         maxduration = d.inMilliseconds;
//         setState(() {

//         });
//       });

//       /*player.onAudioPositionChanged.listen((Duration  p){
//         currentpos = p.inMilliseconds; //get the current position of playing audio

//         //generating the duration label
//         int shours = Duration(milliseconds:currentpos).inHours;
//         int sminutes = Duration(milliseconds:currentpos).inMinutes;
//         int sseconds = Duration(milliseconds:currentpos).inSeconds;

//         int rhours = shours;
//         int rminutes = sminutes - (shours * 60);
//         int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

//         currentpostlabel = "$rhours:$rminutes:$rseconds";

//         setState(() {
//           //refresh the UI
//         });
//       });*/

//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: Text("Play Audio in Flutter App"),
//             backgroundColor: Colors.redAccent
//         ),
//         body: Container(
//             margin: EdgeInsets.only(top:50),
//             child: Column(
//               children: [

//                 Container(
//                   child: Text(currentpostlabel, style: TextStyle(fontSize: 25),),
//                 ),

//                 Container(
//                     child: Slider(
//                       value: double.parse(currentpos.toString()),
//                       min: 0,
//                       max: double.parse(maxduration.toString()),
//                       divisions: maxduration,
//                       label: currentpostlabel,
//                       onChanged: (double value) async {
//                         int seekval = value.round();
//                         // int result = await player.seek(Duration(milliseconds: seekval));
//                         // if(result == 1){ //seek successful
//                         //   currentpos = seekval;
//                         // }else{
//                         //   //debugPrint("Seek unsuccessful.");
//                         // }
//                       },
//                     )
//                 ),

//                 Container(
//                   child: Wrap(
//                     spacing: 10,
//                     children: [
//                       ElevatedButton.icon(
//                           onPressed: () async {
//                             if(!isplaying && !audioplayed){
//                               int result =0;// await player.playBytes(audiobytes);
//                               if(result == 1){ //play success
//                                 setState(() {
//                                   isplaying = true;
//                                   audioplayed = true;
//                                 });
//                               }else{
//                                 //debugPrint("Error while playing audio.");
//                               }
//                             }else if(audioplayed && !isplaying){
//                               int result = 0;//await player.resume();
//                               if(result == 1){ //resume success
//                                 setState(() {
//                                   isplaying = true;
//                                   audioplayed = true;
//                                 });
//                               }else{
//                                 //debugPrint("Error on resume audio.");
//                               }
//                             }else{
//                               int result = 0;//await player.pause();
//                               if(result == 1){ //pause success
//                                 setState(() {
//                                   isplaying = false;
//                                 });
//                               }else{
//                                 //debugPrint("Error on pause audio.");
//                               }
//                             }
//                           },
//                           icon: Icon(isplaying?Icons.pause:Icons.play_arrow),
//                           label:Text(isplaying?"Pause":"Play")
//                       ),

//                       ElevatedButton.icon(
//                           onPressed: () async {
//                             int result = 0;//await player.stop();
//                             if(result == 1){ //stop success
//                               setState(() {
//                                 isplaying = false;
//                                 audioplayed = false;
//                                 currentpos = 0;
//                               });
//                             }else{
//                               //debugPrint("Error on stop audio.");
//                             }
//                           },
//                           icon: Icon(Icons.stop),
//                           label:Text("Stop")
//                       ),
//                     ],
//                   ),
//                 )

//               ],
//             )

//         )
//     );
//   }
// }