import 'dart:convert';
import 'dart:io';

import 'package:ekidzee/api/request/bpms/get_task_comments.dart';
import 'package:ekidzee/api/request/bpms/insert_attachment.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/math_utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/APIService.dart';
import '../../../api/ServiceHandler.dart';
import '../../../api/request/bpms/update_task.dart';
import '../../../api/response/bpms/getTaskDetailsResponseModel.dart';
import '../../../api/response/bpms/get_comments_response.dart';
import '../../../api/response/bpms/insert_attachment_response.dart';
import '../../../api/response/bpms/update_task_response.dart';
import '../../../api/response/pentemind/learninggoals/uploadimage.dart';
import '../../../app_routes.dart';
import '../../../helper/helpers.dart';
import '../../../helper/utils.dart';
import '../../../iface/onClick.dart';
import '../../../iface/onResponse.dart';
import '../../../utils/theme/colors/light_colors.dart';
import '../../../widget/button_widget.dart';
import '../CustomUI/OwnMessgaeCrad.dart';

/// This class design by Suhhir Patil on behalf of zeelearn
/// on 27th June 2023
/// *

class IndividualPage extends StatefulWidget {
  const IndividualPage(
      {super.key, required this.taskModel, required this.clickListener});
  final TaskDetailModel taskModel;
  final onClickListener clickListener;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage>
    implements onResponse, onClickListener {
  bool show = false;
  bool isLoading = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<CommentModel> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _status = '';
  bool isAnyChange = false;

  String _priorityValue = 'Select Priority';
  List<String> priorityOptions = ['Select Priority', 'High', 'Normal', 'LOW'];

  String _statusValue = 'Select Status';
  List<String> statusOptions = [
    'Select Status',
    'In Progress',
    'Cancelled',
    'Completed'
  ];

  String lastsync = '';
  static List<String> imgList = [];

  String _menuName = '';

  @override
  void initState() {
    super.initState();
    // connect();
    initData();
//     debugPrint('Status is ${widget.taskModel.statusname}');
    if (widget.taskModel.status == 1) {
      statusOptions = [
        'Select Status',
        'Pending',
        'In Progress',
        'Cancelled',
        'Completed'
      ];
    }
  }

  gsOfflineData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isInternet = await Utility.isInternet();
    var chatSummery = prefs.getString(getId());
    debugPrint(chatSummery);
    bool isOfflineEligble = await Utility.isOfflineEligble(
        context, prefs.getString('sync_${getId()}') ?? '');
    if (chatSummery == null) {
      isInternet = false;
      isLoading = false;
      loadTaskComments();
    } else if (isOfflineEligble || !isInternet) {
      isInternet = true;
      isLoading = false;
      getLocalData(chatSummery);
    } else {
      loadTaskComments();
    }
  }

  getLocalData(data) {
    bool isLoad = false;
    try {
      messages.clear();
      isLoading = false;
      GetCommentResponse response = GetCommentResponse.fromJson(
        json.decode(data!),
      );
      // debugPrint(response.toJson());
      messages.addAll(response.commentModelList);
      setState(() {});
      setState(() {});
      isLoad = true;
    } catch (e) {
      // debugPrint(e);
      isLoad = false;
    }
    return isLoad;
  }

  generateMenu() {
    if (widget.taskModel.statusname == 'Pending') {
      _menuName = 'Mark In Progress';
    } else if (widget.taskModel.statusname == 'In Progress') {
      _menuName = 'Completed';
    }
  }

  initData() async {
    await getUserInfo();
    imgList.clear();
    if (widget.taskModel.files.isNotEmpty) {
      imgList.addAll(widget.taskModel.files.split(','));
    }
    setState(() {});
    gsOfflineData();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  String userId = '';
  String francId = '';
  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    francId = prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
    userId = prefs.getString(LocalConstant.KEY_UID) as String;
    loadTaskComments();
  }

  void loadTaskComments() {
    GetTaskCommentRequest request =
        GetTaskCommentRequest(task_id: widget.taskModel.id);
    ApiServiceHandler().getTaskComments(request, this);
  }

  void sendMessage(String message) {
    CommentModel messageModel = CommentModel(
        comment: message,
        CreatedBy: userId,
        CreatedDate: Utility.parseShortDate(''),
        createdtime: DateTime.now().toString().substring(10, 16),
        ModifiedBy: userId,
        ModifiedDate: Utility.parseShortDate(''),
        createduser: userId);
    //setMessage("source", messageModel);
    updateTaskDetails(widget.taskModel, widget.taskModel.statusname, message);
    /*socket.emit("message",{"message": message, "sourceId": sourceId, "targetId": targetId});*/
  }

  void setMessage(String type, CommentModel messageModel) {
    /*MessageModel messageModel = MessageModel(
        type: type,
        message: message,
        time: DateTime.now().toString().substring(10, 16));
    debugPrint(messages);*/
    isAnyChange = true;
    List<CommentModel> temp = [messageModel];
    temp.addAll(messages);
    messages.clear();
    messages.addAll(temp);
//     debugPrint('length ${messages.length}');
    if (messages.length > 4 && widget.taskModel.statusname != 'Pending') {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
    //messages.reversed;
    /*setState(() {

    });*/
  }

  Widget getImages() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: imgList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(5),
                  color: Colors.white24,
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return goToImageViewer(
                            imageUrl: imgList[index].toString());
                      }));
                    },
                    child: Center(
                      child: loadImage(imgList[index], File(imgList[index])),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadImage(String networkImage, File imageFile) {
    return Card(
        borderOnForeground: true,
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(2),
          child: networkImage.contains('file')
              ? Image(
                  image: FileImage(imageFile),
                  width: 100,
                  height: 150,
                )
              : FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/placeholder.png'),
                  image: NetworkImage(networkImage),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image(image: FileImage(imageFile));
                  },
                  fit: BoxFit.cover,
                ),
        ));
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: 1000,
                        height: 100,
                      ),
                      /*Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'No. ${imgList.indexOf(item)} image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),*/
                    ],
                  )),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/image/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
//                   debugPrint('App bar back listener..$isAnyChange.');
                  if (isAnyChange) {
                    Navigator.pop(context, widget.taskModel);
                    widget.clickListener.onClick(0, 1212);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.taskModel.title,
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      foundation.kIsWeb
                          ? SizedBox.shrink()
                          : Text(
                              lastsync,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            )
                    ],
                  ),
                ),
              ),
              actions: widget.taskModel.statusname == 'Pending' ||
                      widget.taskModel.statusname == 'BP Completed' ||
                      widget.taskModel.statusname == 'Completed'
                  ? null
                  : [
                      /*IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
                IconButton(icon: Icon(Icons.call), onPressed: () {}),*/

                      InkWell(
                        onTap: () {
                          _status = 'BP Completed';
                          //Navigator.of(context).pop();
                          updateTaskDetails(
                              widget.taskModel, 'BP Completed', 'BP Completed');
                          /*showModalBottomSheet(
                        backgroundColor:
                        Colors.transparent,
                        context: context,
                        builder: (builder) =>
                            showBottomSheetStartTask(context,widget.taskModel));*/
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: LightColors.kLightRed,
                            child: Center(
                              child: Text(
                                '  Mark Completed  ',
                                style: LightColors.textHeaderStyle13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*PopupMenuButton<String>(
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    debugPrint(value);
                    Navigator.of(context).pop();
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(child:
                        InkWell(
                          onTap: () {
                            _status ='BP Completed';
                            Navigator.of(context).pop();
                            updateTaskDetails(widget.taskModel,'BP Completed','BP Completed');
                            showModalBottomSheet(
                            backgroundColor:
                            Colors.transparent,
                            context: context,
                            builder: (builder) =>
                            showBottomSheetStartTask(context,widget.taskModel));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: LightColors.kBlue,
                              child: Text('Mark Completed'),
                            ),
                          ),
                        ),
                      ),

                      */ /*PopupMenuItem(
                        child: InkWell(
                          onTap: (){
                            _status ='BP Completed';
                            Navigator.of(context).pop();
                            updateTaskDetails(widget.taskModel,'BP Completed','BP Completed');
                            */ /**/ /*Navigator.of(context).pop();
                            showModalBottomSheet(
                                backgroundColor:
                                Colors.transparent,
                                context: context,
                                builder: (builder) =>
                                    showBottomSheetStartTask(context,widget.taskModel));*/ /**/ /*

                          },
                          child: Text("Mark Completed" ),
                        ),
                        value: "Update Status",
                      ),*/ /*
                    ];
                  },
                ),*/
                    ],
            ),
          ),
          body: isLoading
              ? Utility.showLoader()
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: WillPopScope(
                    child: widget.taskModel.statusname.isEmpty ||
                            widget.taskModel.statusname == 'Pending'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              showBottomSheetStartTask1(
                                  context, widget.taskModel)
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                child: imgList.isNotEmpty
                                    ? Card(
                                        margin: const EdgeInsets.only(
                                            left: 2, right: 2, bottom: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                        ),
                                        child: getImages())
                                    : const Text(''),
                              ),

                              /*Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                      ),
                      items: imageSliders,
                    ),
                  ),*/
                              Expanded(
                                // height: MediaQuery.of(context).size.height - 150,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  reverse: true,
                                  controller: _scrollController,
                                  itemCount: messages.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == messages.length) {
                                      return Container(
                                        height: 70,
                                      );
                                    }
                                    return OwnMessageCard(
                                      message: messages[index].comment,
                                      time: Utility.parseShortTime(
                                          messages[index].CreatedDate),
                                    );
                                    /*if (messages[index].type == "img") {
                          return ImageMessageCard(
                            model: messages[index],
                          );
                        }else if (messages[index].type == "source") {
                          return OwnMessageCard(
                            message: messages[index].message,
                            time: messages[index].time,
                          );
                        } else {
                          return ReplyCard(
                            message: messages[index].message,
                            time: messages[index].time,
                          );
                        }*/
                                  },
                                ),
                              ),
                              widget.taskModel.statusname == 'BP Completed' ||
                                      widget.taskModel.status == 3
                                  ? const SizedBox(
                                      width: 0,
                                    )
                                  : Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      60,
                                                  child: Card(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 2,
                                                            right: 2,
                                                            bottom: 8),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    child: TextFormField(
                                                      controller: _controller,
                                                      focusNode: focusNode,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      onChanged: (value) {
                                                        if (value.isNotEmpty) {
                                                          setState(() {
                                                            sendButton = true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            sendButton = false;
                                                          });
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Type a message",
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                        suffixIcon: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(Icons
                                                                  .attach_file),
                                                              onPressed: () {
                                                                showModalBottomSheet(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (builder) =>
                                                                            bottomSheet());
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons
                                                                      .camera_alt),
                                                              onPressed:
                                                                  () async {
                                                                showImagePicker(
                                                                    ImageSource
                                                                        .camera);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(5),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 8,
                                                    right: 2,
                                                    left: 2,
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        const Color(0xFF128C7E),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.send,
                                                        /*sendButton ? Icons.send : Icons.mic,*/
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        if (sendButton) {
                                                          _scrollController.animateTo(
                                                              _scrollController
                                                                  .position
                                                                  .maxScrollExtent,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300),
                                                              curve: Curves
                                                                  .easeOut);
                                                          sendMessage(
                                                              _controller.text);
                                                          _controller.clear();
                                                          setState(() {
                                                            sendButton = false;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            show ? emojiSelect() : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                    onWillPop: () {
//                       debugPrint('back button listener');
                      if (show) {
                        setState(() {
                          show = false;
                        });
                      } else {
                        if (isAnyChange) {
                          Navigator.pop(context, widget.taskModel);
                        } else {
                          Navigator.of(context).pop();
                        }
                      }
                      return Future.value(false);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*iconCreation(
                      Icons.insert_drive_file, Colors.indigo, LocalConstant.ACTION_PDF),
                  SizedBox(
                    width: 40,
                  ),*/
                  iconCreation(Icons.camera_alt, Colors.pink,
                      LocalConstant.ACTION_CAMERA),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple,
                      LocalConstant.ACTION_GALLERY),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.update, Colors.orange, LocalConstant.ACTION_UPDATE_STATUS),
                  SizedBox(
                    width: 40,
                  ),
                  */ /*iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),*/ /*
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {
        onClick(LocalConstant.ACTION_USER_EVENT, text);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (Category? category, Emoji emoji) {
        // Do something when emoji is tapped (optional)
      },
      onBackspacePressed: () {
        // Do something when the user taps the backspace button (optional)
        // Set it to null to hide the Backspace-Button
      },
      textEditingController:
          _controller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
    ); /*EmojiPicker(
        onEmojiSelected: (emoji, category) {
          debugPrint(emoji);
          setState(() {
            _controller.text = _controller.text + emoji.toString();
          });
        });*/
  }

  showImagePicker(source) async {
    final ImagePicker picker = ImagePicker();
    if (source == ImageSource.gallery || source == ImageSource.camera) {
      XFile? photo;
      photo = await picker.pickImage(source: source, imageQuality: 72);
      if (photo != null) {
//         debugPrint('image upload');
        setState(() {
          isLoading = true;
        });
        APIService().uploadImage(userId, photo, listener: this);
      }
    } else {
//       debugPrint('image not found');
      /*debugPrint('Image Profile is ${widget.profileImage}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String imageAvtar = prefs.getString(LocalConstant.KEY_USER_AVTAR) as String;
      debugPrint(imageAvtar);
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageViewer(imageUrl: widget.profileImage.toString());
      }));*/
    }
  }

  void updateTaskDetails(TaskDetailModel item, String status, String remark) {
    _status = status;
    isAnyChange = true;
    CommentModel messageModel = CommentModel(
        comment: remark,
        CreatedBy: userId,
        CreatedDate: Utility.getServerDate(),
        createdtime: DateTime.now().toString().substring(10, 16),
        ModifiedBy: userId,
        ModifiedDate: Utility.getServerDate(),
        createduser: userId);
    setMessage("source", messageModel);
    UpdateBpmsTaskRequest request = UpdateBpmsTaskRequest(
        taskid: int.parse(item.id),
        status: status,
        remark: remark,
        startDate: widget.taskModel.startDate.isEmpty
            ? Utility.getServerDate()
            : widget.taskModel.startDate,
        endDate: Utility.getServerDate(),
        userId: userId);
    ApiServiceHandler().updateTaskDetails(request, true, this);
    //Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  void insertTaskAttachment(String filepath) {
    TaskDetailModel item = widget.taskModel;
    InsertTaskAttachmentRequest request = InsertTaskAttachmentRequest(
        taskId: item.id, filePath: filepath, userId: userId);
    ApiServiceHandler().insertTaskAttachment(request, this);
  }

  final _priorityKey = GlobalKey<FormState>();
  final _statusKey = GlobalKey<FormState>();
  final _descriptionKey = GlobalKey<FormState>();
  final TextEditingController _descriptinoController = TextEditingController();

  int ACTION_DROPDOWN_PRIORITY = 1001;
  int ACTION_DROPDOWN_STATUS = 1002;

  Widget showBottomSheetStartTask(BuildContext context, TaskDetailModel item) {
    return isLoading
        ? Utility.showLoader()
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: const EdgeInsets.all(18.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: size.width,
                        child: Text(
                          'Update Task ',
                          style: LightColors.textHeaderStyle16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*getDropdownField(_priorityKey, 'Select Priority', _priorityValue, priorityOptions,this, size, size.width * 0.4,ACTION_DROPDOWN_PRIORITY),
                  SizedBox(
                    width: 10,
                  ),*/
                        getDropdownField(
                            _statusKey,
                            'Select Status',
                            _statusValue,
                            statusOptions,
                            this,
                            size,
                            size.width * 0.4,
                            ACTION_DROPDOWN_STATUS),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    getTextAreaField(
                        _descriptionKey,
                        _descriptinoController,
                        'Description',
                        Icons.description,
                        size,
                        size.width * 0.83),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: ButtonWidget(
                          text: 'Update',
                          backColor: false
                              ? [
                                  Colors.black,
                                  Colors.black,
                                ]
                              : const [Color(0xff92A3FD), Color(0xff9DCEFF)],
                          textColor: const [
                            Colors.white,
                            Colors.white,
                          ],
                          onPressed: () async {
//                             debugPrint('onPress calleed');
                            //Navigator.of(context).pop();
                            updateTaskDetails(item, _statusValue,
                                _descriptinoController.text.toString());
                            /*if (userName.trim().isEmpty) {
                        buildSnackError('Please Enter your userName',context,size,
                        );
                      }*/
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  int getStatus(String statusName) {
    int status = 1;
    switch (statusName) {
      case 'Pending':
        status = 1;
        break;
      case 'In Progress':
        status = 2;
        break;
      case 'Cancelled':
        status = 3;
        break;
      case 'Completed':
        status = 4;
        break;
    }
    return status;
  }

  Widget showBottomSheetStartTask1(BuildContext context, TaskDetailModel item) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: size.width,
                  child: Text(
                    item.title,
                    style: LightColors.textHeaderStyle16,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                width: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: size.width,
                  child: Text(
                    widget.taskModel.statusname == 'Pending'
                        ? '${item.title} Task still not started, Do you want to Start the task'
                        : 'Are you sure to complete the ${item.title}',
                    style: LightColors.textHeaderStyle16,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: ButtonWidget(
                      text: 'Let\'s Start',
                      backColor: false
                          ? [
                              Colors.black,
                              Colors.black,
                            ]
                          : const [Color(0xff92A3FD), Color(0xff9DCEFF)],
                      textColor: const [
                        Colors.white,
                        Colors.white,
                      ],
                      onPressed: () async {
                        widget.taskModel.statusname = 'In Progress';
                        isAnyChange = true;
                        updateTaskDetails(item, 'In Progress',
                            '${item.title} task has been started');
                      }),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onError(int action, value) {
    //Navigator.pop(context);
    isLoading = false;
    setState(() {});
  }

  @override
  void onResponseStart() {
//     debugPrint('onResponseStart');
    isLoading = true;
    setState(() {});
  }

  getId() {
    return 'task_${widget.taskModel.mtaskId}';
  }

  saveComments(String json) async {
    if (json != 'null' && json.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(getId(), json);
      prefs.setString('sync_${getId()}', Utility.formatDate());
    }
  }

  @override
  void onSuccess(value) {
//     debugPrint('onSuccess');
//     debugPrint('in BP COmpltedadadakldnakldn123');
    isLoading = false;
    if (value is UpdateBpmsTaskResponse) {
      UpdateBpmsTaskResponse responseModel = value;
      widget.taskModel.statusname = _status;

      if (_status == 'BP Completed') {
        widget.taskModel.statusname = 'BP Completed';
        widget.taskModel.status = getStatus(_status);
//         debugPrint('in BP COmpltedadadakldnakldn');
        Navigator.pop(context, widget.taskModel);
      } else {
        setState(() {});
      }
    } else if (value is GetCommentResponse) {
      GetCommentResponse commentResponse = value;
      messages.clear();
      String json = jsonEncode(commentResponse);
      saveComments(json);
      if (commentResponse.commentModelList.isNotEmpty) {
        messages.addAll(commentResponse.commentModelList);
        //messages.reversed;
        if (messages.isNotEmpty) {
          lastsync =
              'last sync is ${Utility.parseShortTime(messages[0].CreatedDate)}';
        }
      }
      setState(() {});
    } else if (value is InsertTaskAttachmentResponse) {
      isAnyChange = true;
      InsertTaskAttachmentResponse response = value;
      if (response.data.isNotEmpty) {
        Utility.showMessage(context, response.data[0].msg);
      }
      setState(() {});
    }
  }

  updateImage(String url) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String franchiseeId =
          prefs.getString(LocalConstant.KEY_FRANCHISEE_ID) as String;
      var taskDetails = prefs.getString('synctask_$franchiseeId');
//       debugPrint('task detasil $taskDetails');
      GetTaskDetailsResponseModel response =
          GetTaskDetailsResponseModel.fromJson(json.decode(taskDetails!));
      for (int index = 0; index < response.taskDetail.length; index++) {
        if (response.taskDetail[index].id == widget.taskModel.id) {
          response.taskDetail[index].files =
              '${response.taskDetail[index].files}, $url';
          debugPrint(url);
//           debugPrint('file updated.......');
        }
      }
      String savejson = jsonEncode(response);
      saveTaskDetails(savejson, franchiseeId);
    } catch (e) {
      // debugPrint(e);
    }
  }

  saveTaskDetails(String json, String franchiseeId) async {
    if (json != 'null' && json.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('synctask_$franchiseeId', json);
      debugPrint(json);
    }
  }

  @override
  void onClick(int action, value) {
//     debugPrint('click listener action $action value $value');
    if (action == 0 && value == 0) {
      widget.clickListener.onClick(action, value);
    } else if (action == ACTION_DROPDOWN_PRIORITY) {
      _priorityValue = value;
    } else if (action == ACTION_DROPDOWN_STATUS) {
      _statusValue = value;
    } else if (action == LocalConstant.ACTION_USER_EVENT) {
      Navigator.of(context).pop();
      switch (value) {
        case LocalConstant.ACTION_UPDATE_STATUS:
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (builder) =>
                  showBottomSheetStartTask(context, widget.taskModel));
          break;
        case LocalConstant.ACTION_CAMERA:
          showImagePicker(ImageSource.camera);
          break;
        case LocalConstant.ACTION_GALLERY:
          showImagePicker(ImageSource.gallery);
          break;
      }
    } else if (action == Utility.ACTION_IMAGE_UPLOAD_RESPONSE_OK) {
      if (value is UploadImageResponse) {
        UploadImageResponse response = value;
        if (value.message.contains('Successfully')) {
          imgList.add(value.imageModel![0].location);
          insertTaskAttachment(value.imageModel![0].location);
          updateImage(value.imageModel![0].location);
          setState(() {
            isLoading = false;
          });
        } else {
          Utility.showMessageCallback(context, 'Alert', value.message, this);
        }
        //Navigator.of(context, rootNavigator: true).pop('dialog');
      }
    } else if (action == 111) {
      TaskDetailModel taskModel = value;
      //updateTaskDetails(response);
      //showChatScreen(context, taskModel);
      /*showModalBottomSheet(
          backgroundColor:
          Colors.transparent,
          context: context,
          builder: (builder) =>
              showBottomSheetEditTask(context,model));*/
    }
  }
}
