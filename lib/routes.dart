import 'package:flutter/widgets.dart';
import 'package:pokemon/screens/Home/home.dart';
import 'package:pokemon/screens/Login/login.dart';
import 'package:pokemon/screens/onboarding/splash_screen.dart';
import '/screens/profile/profile_screen.dart';

final Map<String, WidgetBuilder> routes = {
  Login.routeName: (context) => Login(),
  SplashScreen.routeName: (context) => SplashScreen(),
  Home.routeName: (context) => Home(),
};
