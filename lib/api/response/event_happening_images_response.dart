
class EventHappeningImagesResponse {
  int mEventsHappeningsId=0;
  var eventDate;
  String title='';
  String createdDate='';
  List<EventsAndHappeningsImages> eventsAndHappeningsImages=<EventsAndHappeningsImages>[];

  EventHappeningImagesResponse(
      {required this.mEventsHappeningsId,
        required this.eventDate,
        required this.title,
        required this.createdDate,
        required this.eventsAndHappeningsImages});

  EventHappeningImagesResponse.fromJson(List<dynamic> json) {
    mEventsHappeningsId = json[0]['m_Events_Happenings_Id'];
    eventDate = json[0]['Event_Date'];
    title = json[0]['Title'];
    createdDate = json[0]['Created_Date'];
    if (json[0]['EventsAndHappenings_Images'] != null) {
      eventsAndHappeningsImages = <EventsAndHappeningsImages>[];
      json[0]['EventsAndHappenings_Images'].forEach((v) {
        eventsAndHappeningsImages
            .add(new EventsAndHappeningsImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['m_Events_Happenings_Id'] = this.mEventsHappeningsId;
    data['Event_Date'] = this.eventDate;
    data['Title'] = this.title;
    data['Created_Date'] = this.createdDate;
    data['EventsAndHappenings_Images'] =
        this.eventsAndHappeningsImages.map((v) => v.toJson()).toList();
      return data;
  }
}

class EventsAndHappeningsImages {
  String smallImage='';
  String mediumImage='';
  String largeImage='';
  String imageName='';
  String imageType='';
  int iEventsHappeningsId=0;

  EventsAndHappeningsImages(
      {required this.smallImage,
        required this.mediumImage,
        required this.largeImage,
        required this.imageName,
        required this.imageType,
        required this.iEventsHappeningsId});

  EventsAndHappeningsImages.fromJson(Map<String, dynamic> json) {
    smallImage = json['Small_Image'];
    mediumImage = json['Medium_Image'];
    largeImage = json['Large_Image'];
    imageName = json['Image_Name'];
    imageType = json['Image_Type'];
    iEventsHappeningsId = json['I_events_Happenings_Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Small_Image'] = this.smallImage;
    data['Medium_Image'] = this.mediumImage;
    data['Large_Image'] = this.largeImage;
    data['Image_Name'] = this.imageName;
    data['Image_Type'] = this.imageType;
    data['I_events_Happenings_Id'] = this.iEventsHappeningsId;
    return data;
  }
}
