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

    checkAuthenticationStatus();
    Navigator.pushNamed(context, '/Home');
  } else {
    print('El campo "contrasena" no existe para el usuario actual.');
    Navigator.pushNamed(context, '/Password_Google');
  }
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

Future<void> insertFavorites(String userId, String pokemonId) async {
  await db.collection('favorites').add({
    'id_user': userId,
    'id_pokemon': pokemonId,
  });
}

Future<List<Map<String, dynamic>>> getFavoritesByUserId(String userId) async {
  List<Map<String, dynamic>> favorites = [];

  QuerySnapshot querySnapshot = await db
      .collection('favorites')
      .where('id_user', isEqualTo: userId)
      .get();

  favorites = querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();

  return favorites;
}

<<<<<<< Updated upstream
Future<List<String>> getFavoritePokemonIdsByUserId(String userId) async {
  List<String> favoritePokemonIds = [];

  QuerySnapshot querySnapshot = await db
      .collection('favorites')
      .where('id_user', isEqualTo: userId)
      .get();

  favoritePokemonIds = querySnapshot.docs.map((doc) => doc['id_pokemon'] as String).toList();

  return favoritePokemonIds;
}

Future<void> removeFavorite(String userId, String pokemonId) async {
  QuerySnapshot querySnapshot = await db
      .collection('favorites')
      .where('id_user', isEqualTo: userId)
      .where('id_pokemon', isEqualTo: pokemonId)
      .get();

  querySnapshot.docs.forEach((doc) {
    doc.reference.delete();
  });
}

Future<bool> checkIfPokemonIsFavorite(String userId, String pokemonId) async {
  QuerySnapshot querySnapshot = await db
      .collection('favorites')
      .where('id_user', isEqualTo: userId)
      .where('id_pokemon', isEqualTo: pokemonId)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Stream<List<Map<String, dynamic>>> getFavoritesStreamByUserId(String userId) {
  return db
      .collection('favorites')
      .where('id_user', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
}




=======
// Verificar el estado de autenticación
void checkAuthenticationStatus() {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    // El usuario está autenticado
    if (user.providerData
        .any((userInfo) => userInfo.providerId == 'google.com')) {
      // El usuario se autenticó con Google
      print('El usuario está autenticado con Google');
    } else if (user.providerData
        .any((userInfo) => userInfo.providerId == 'password')) {
      // El usuario se autenticó con correo electrónico y contraseña
      print('El usuario está autenticado con correo electrónico y contraseña');
    }
  } else {
    // El usuario no está autenticado
    print('El usuario no está autenticado');
  }
}

Future<String> getUserDisplayNameFromFirestore(String userId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  try {
    final userData = await userRef.get();
    if (userData.exists) {
      final displayName = userData.get('name') as String;
      return displayName;
    } else {
      return 'Nombre no encontrado'; // O un valor predeterminado en caso de que el campo "name" no exista
    }
  } catch (e) {
    print('Error al obtener el nombre del usuario: $e');
    return 'Error al obtener el nombre';
  }
}

// Future<String> Getuserss() async {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   User? user = auth.currentUser;
//   if (user != null) {
//     String userId = user.uid;

//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     CollectionReference usersCollection = firestore.collection('users');
//     DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

//     if (userSnapshot.exists) {
//       Map<String, dynamic> userData =
//           userSnapshot.data() as Map<String, dynamic>;
//       String username = userData['name'].toString();
//       return username;
//       // Aquí tienes todos los datos del usuario en el mapa `userData`
//       // Puedes acceder a los campos específicos utilizando su nombre, por ejemplo, `userData['nombre']`
//     }
//   } else {
//     return null;
//   }
// }
