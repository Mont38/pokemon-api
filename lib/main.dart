import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/firebase/auth_user/auth_page.dart';
import 'package:pokemon/screens/onboarding/PreviewPages.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> backgroungHandler(RemoteMessage message) async {
  print("entro");
  print(message.notification!.title);
  print(message.notification!.body);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('user graded${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(backgroungHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokemon',

        // home: SplashScreen(),
        // We use routeName so that we don't need to remember the name
        initialRoute: PreviewPages.routeName,
        routes: Routes().routes);
  }
}
