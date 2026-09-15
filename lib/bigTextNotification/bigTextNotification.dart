import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class BigTextNotification {
  static Future<void> showBigPictureAndLargeIconNotification(
      int id, RemoteMessage remoteMessage) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: "big_picture",
            title: 'Big <b>BIG</b> picture title',
            summary: 'Summary <i>text</i>',
            body: remoteMessage.data['body'],
            largeIcon:
                'https://image.freepik.com/vetores-gratis/modelo-de-logotipo-de-restaurante-retro_23-2148451519.jpg',
            bigPicture: 'https://media-cdn.tripadvisor.com/media/photo-s/15/dd/20/61/al-punto.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'uuid': 'uuid-test'}));
  }
}
