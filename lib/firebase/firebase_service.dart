import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUser() async {
  List user = [];
  CollectionReference collectionReferenceUser = db.collection('users');
  QuerySnapshot queryUser = await collectionReferenceUser.get();
  queryUser.docs.forEach((documento) {
    user.add(documento.data());
  });

  return user;
}

Future<void> addUsers(
    String email, String password, String image, String name) async {
  await db.collection("users").add(
      {"email": email, "password": password, "image": image, "name": name});
}

void verificarCampoContrasena(BuildContext context) async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser?.uid)
      .get();

  if (snapshot.exists &&
      snapshot.data() != null &&
      (snapshot.data() as Map<String, dynamic>).containsKey('password')) {
    print('El campo "contrasena" existe para el usuario actual.');

    Navigator.pushNamed(context, '/Home');
  } else {
    print('El campo "contrasena" no existe para el usuario actual.');
    Navigator.pushNamed(context, '/Password_Google');
  }
}
