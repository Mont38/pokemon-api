import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/screens/Notifications/notification_push.dart';
import 'package:pokemon/screens/onboarding/PreviewPages.dart';
import 'package:pokemon/settings/flags_provider.dart';
import 'package:pokemon/settings/theme_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'routes.dart';

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
  await PushNotification.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool('is_dark') ?? false;
  final isLight = sharedPreferences.getBool('is_light') ?? false;

  runApp(MyApp(isDark: isDark, isLight: isLight));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final bool isLight;
  const MyApp({
    super.key,
    required this.isDark,
    required this.isLight,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider(isDark, isLight)),
      ChangeNotifierProvider(create: (_) => FlagsProvider())
    ], child: PMSNApp());

    //   MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'Pokemon',
    //       theme: ThemeData.dark(),

    //       // home: SplashScreen(),
    //       // We use routeName so that we don't need to remember the name
    //       initialRoute: PreviewPages.routeName,
    //       routes: Routes().routes);
    // });
  }
}

class PMSNApp extends StatelessWidget {
  PMSNApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: theme.currentTheme,
      routes: Routes().routes,
      initialRoute: PreviewPages.routeName,
    );
  }
}
