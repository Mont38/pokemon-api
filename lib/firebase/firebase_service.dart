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

<<<<<<< HEAD
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
=======
Future<List> getFavorites() async {
  List favorites = [];
  CollectionReference collectionReferenceFavorites = db.collection('favorites');
  QuerySnapshot queryFavorites = await collectionReferenceFavorites.get();
  queryFavorites.docs.forEach((documento) {
    favorites.add(documento.data());
  });

  return favorites;
}

Future<void> insertFavorites(String user_id, String pokemon_id) async {
  await db.collection('favorites').add({
    'id_user': user_id,
    'id_pokemon': pokemon_id,
  });
}

Future<List<Map<String, dynamic>>> getFavoritesByUserId(String userId) async {
  List<Map<String, dynamic>> favorites = [];
  
  QuerySnapshot querySnapshot = await db
      .collection('favorites')
      .where('id_user', isEqualTo: userId)
      .get();
  
  favorites = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  
  return favorites;
}


>>>>>>> 3770f02442e2751769f5075b86a00ce665a70da4
