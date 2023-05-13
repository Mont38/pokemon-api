import 'package:flutter/widgets.dart';
import 'package:pokemon/firebase/auth_user/auth_page.dart';
import 'package:pokemon/screens/Home/home.dart';
import 'package:pokemon/screens/Login/login.dart';
import 'package:pokemon/screens/Register/Register.dart';
import 'package:pokemon/screens/onboarding/PreviewPages.dart';
import 'package:pokemon/screens/profile/profile_screen.dart';
import 'package:pokemon/firebase/auth_user/auth_page.dart';

final Map<String, WidgetBuilder> routes = {
  Login.routeName: (context) => Login(),
  PreviewPages.routeName: (context) => PreviewPages(),
  Home.routeName: (context) => Home(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  AuthPage.routeName: (context) => AuthPage(),
  Register.routeName: (context) => Register(),
};
