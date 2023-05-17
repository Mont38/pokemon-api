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


