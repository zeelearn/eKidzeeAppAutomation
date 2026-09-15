


class BPSetupModel {
  BPSetupModel({
    required this.image,
    required this.title,
    required this.pinned,
    required this.muted,
    required this.archived,
    required this.status,
    required this.name,
    required this.lastMessage,
    required this.date,
    required this.startDate,
    required this.endDate,
    required this.unread,
    required this.membersCount,
    required this.groupMembers,
  });

  final String image;
  final String title;
  final bool pinned;
  final bool muted;
  final bool archived;
  final String status;
  final String name;
  final String lastMessage;
  final String date;
  final String startDate;
  final String endDate;
  final int unread;
  final String membersCount;
  final List<String> groupMembers;

  factory BPSetupModel.fromJson(Map<String, dynamic> json) => BPSetupModel(
    image: json["image"],
    title: json["title"],
    pinned: json["pinned"],
    muted: json["muted"],
    archived: json["archived"],
    name: json["name"],
    status: json["status"],
    lastMessage: json["lastMessage"],
    date: json["date"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    unread: json["messagesCount"],
    membersCount: json["membersCount"],
    groupMembers: List<String>.from(json["groupMembers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "title": title,
    "pinned": pinned,
    "muted": muted,
    "archived": archived,
    "name": name,
    "lastMessage": lastMessage,
    "date": date,
    "messagesCount": unread,
    "membersCount": membersCount,
    "groupMembers": List<dynamic>.from(groupMembers.map((x) => x)),
  };
}

/*List<Map<String, dynamic>> itemsList = [
  {
    'image': ImageConstant.imgRectangle1623,
    'title': 'Civil Work',
    'pinned': false,
    'muted': false,
    'archived': true,
    'status': 'Completed',
    'name': '',
    'lastMessage': 'Sudhir : PH value of the water should not be less than 6',
    'date': '11:36',
    'startDate': '21-June',
    'endDate': '22-June',
    'messagesCount': 2,
    'membersCount': '1',
    'groupMembers': [
      ImageConstant.imgRectangle163,

      ImageConstant.imgRectangle1632,
      ImageConstant.imgRectangle1633,

    ]
  },
  {
    'image': ImageConstant.imgRectangle1624,
    'title': 'Painting Internal/External',
    'pinned': false,
    'muted': false,
    'archived': false,
    'status': 'In Progress',
    'name': 'Ronald Richards',
    'startDate': '22-June',
    'endDate': '',
    'lastMessage': 'TM : Painting the school building is a great way to give it a fresh and welcoming look',
    'date': '11:25',
    'messagesCount': 2,
    'membersCount': '4',
    'groupMembers': [
      ImageConstant.imgRectangle1633,
      ImageConstant.imgRectangle1632,

    ]
  },
  {
    'image': ImageConstant.imgRectangle1625,
    'title': 'Furniture',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'date': '10:47',
    'startDate': '',
    'endDate': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [

    ]
  },
  {
    'image': ImageConstant.imgRectangle16313,
    'title': 'CCTV setup',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': 'Marvin McKinney',
    'lastMessage': '',
    'date': '10:47',
    'startDate': '',
    'endDate': '',
    'messagesCount': 2,
    'membersCount': '0',
    'groupMembers': [
    ]
  },{
    'image': ImageConstant.imgOfficeSetup,
    'title': 'Office setup',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'date': '',
    'startDate': '',
    'endDate': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },{
    'image': ImageConstant.imgClassroomSetup,
    'title': 'Classroom setup',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'date': '',
    'startDate': '',
    'endDate': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },{
    'image': ImageConstant.imgClassroomSetup,
    'title': 'PG room setup',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'date': '',
    'startDate': '',
    'endDate': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },{
    'image': ImageConstant.imgNurseryRoomSetup,
    'title': 'Nursery room setup',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'date': '',
    'startDate': '',
    'endDate': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },{
    'image': ImageConstant.imgjrkgRoomSetup,
    'title': 'Junior KG classroom setup',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'startDate': '',
    'endDate': '',
    'date': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },
  {
    'image': ImageConstant.imgjrkgRoomSetup,
    'title': 'Senior KG classroom setup',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'startDate': '',
    'endDate': '',
    'date': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },{
    'image': ImageConstant.imgPlayArea,
    'title': 'Play Area',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'date': '',
    'startDate': '',
    'endDate': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },{
    'image': ImageConstant.imgRestRoom,
    'title': 'Wash Room	',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'date': '',
    'startDate': '',
    'endDate': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },
  {
    'image': ImageConstant.imgOutdoor,
    'title': 'Outdoor Activity Area',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'date': '',
    'startDate': '',
    'endDate': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },{
    'image': ImageConstant.imgFireSefty,
    'title': 'Fire Sefty',
    'pinned': false,
    'muted': true,
    'archived': true,
    'status': 'Start',
    'name': '',
    'lastMessage': '',
    'startDate': '',
    'endDate': '',
    'date': '',
    'messagesCount': 0,
    'membersCount': '0',
    'groupMembers': [
    ]
  },
];*/
