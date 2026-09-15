class ChatModel {
  String name;
  String icon;
  bool isGroup;
  String time;
  String currentMessage;
  String status;
  bool select = false;
  int id;
  ChatModel({
    required this.name,
    this.icon='',
    this.isGroup=false,
    this.time='',
    this.currentMessage='',
    required this.status,
    this.select = false,
    this.id=0,
  });
}
