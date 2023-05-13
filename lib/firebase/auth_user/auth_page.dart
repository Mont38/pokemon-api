import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/screens/Login/login.dart';
import 'package:pokemon/screens/Register/Register.dart';
import 'package:pokemon/screens/home/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  static String routeName = "/Auth";
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            try {
              if (snapshot.hasData) {
                return Home();
              } else {
                return Login();
              }
            } catch (error) {
              return Container();
            }
          }),
    );
  }
}
