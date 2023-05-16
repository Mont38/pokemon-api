import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
