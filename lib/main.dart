import 'package:flutter/material.dart';
import 'package:pokemon/screens/onboarding/splash_screen.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Oasis Shop',

      // home: SplashScreen(),
      // We use routeName so that we don't need to remember the name
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
