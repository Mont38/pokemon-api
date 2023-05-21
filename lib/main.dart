import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/screens/Notifications/notification_push.dart';
import 'package:pokemon/screens/onboarding/PreviewPages.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> backgroungHandler(RemoteMessage message) async {
//   print("entro");
//   print(message.notification!.title);
//   print(message.notification!.body);
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final pushNotification = new PushNotification();
    pushNotification.initNotification();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokemon',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),

        // home: SplashScreen(),
        // We use routeName so that we don't need to remember the name
        initialRoute: PreviewPages.routeName,
        routes: Routes().routes);
  }
}
