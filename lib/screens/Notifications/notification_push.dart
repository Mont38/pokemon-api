import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static Future _backgroundHandler(RemoteMessage message) async {
    print('backgroundHandelrt${message.messageId}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessageHandelrt${message.messageId}');
  }

  static Future _openHandler(RemoteMessage message) async {
    print('openHandelrt${message.messageId}');
  }

  static Future initializeApp() async {
    //push notification
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);
    //Handles
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_openHandler);
  }
}
