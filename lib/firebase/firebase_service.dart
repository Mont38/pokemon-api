import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/model/user_model.dart';

class Firebase_service {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference users_pkemon =
      FirebaseFirestore.instance.collection('users');
  CollectionReference? _users;
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  Firebase_service() {
    _users = _firebase.collection('users');
  }

  Future<List> getUser() async {
    List user = [];

    CollectionReference collectionReferenceUser = db.collection('users');
    QuerySnapshot queryUser = await collectionReferenceUser.get();
    queryUser.docs.forEach((documento) {
      user.add(documento.data());
    });

    return user;
  }

  void updateEmailVerificationStatus(BuildContext context, String email) {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Realiza una consulta para buscar el usuario con el correo electrónico especificado
    usersCollection
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      // Verifica si se encontró un usuario con el correo electrónico especificado
      if (querySnapshot.size > 0) {
        // Actualiza el campo 'emailVerified' a true para todos los usuarios encontrados
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          doc.reference.update({'emailVerified': true}).then((value) {
            print(
                'Campo emailVerified actualizado correctamente para el usuario con el correo electrónico: $email');
            Navigator.pushNamed(context, '/Home');
          }).catchError((error) {
            print('Error al actualizar el campo emailVerified: $error');
          });
        });
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico: $email');
      }
    }).catchError((error) {
      print('Error al realizar la consulta: $error');
    });
  }

  Future<void> addUsers(BuildContext context, String email, String password,
      String image, String name, bool emailVerified) async {
    await db.collection("users").add({
      "email": email,
      "password": password,
      "image": image,
      "name": name,
      "emailVerified": emailVerified
    }).then((value) => Navigator.popAndPushNamed(context, '/verify'));
  }

  Future<String> getUserImageByEmail(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.size > 0) {
      // Se encontró un usuario con el correo electrónico especificado
      final userDocument = querySnapshot.docs.first;
      final userData = userDocument.data();
      final image = userData['image'];
      return image;
    } else {
      // No se encontró ningún usuario con el correo electrónico especificado
      throw Exception(
          'No se encontró ningún usuario con el correo electrónico: $email');
    }
  }

  Future<void> updateUserInfo(String email, String name, String image) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Realiza una consulta para buscar el usuario con el correo electrónico especificado
    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    // Verifica si se encontró un usuario con el correo electrónico especificado
    if (querySnapshot.size > 0) {
      // Obtiene la referencia del documento del usuario encontrado
      DocumentReference userDocRef = querySnapshot.docs.first.reference;

      // Actualiza los campos 'username' e 'image' del usuario
      await userDocRef.update({
        'name': name,
        'image': image,
      });
    } else {
      throw Exception(
          'No se encontró ningún usuario con el correo electrónico: $email');
    }
  }

  Future<String> getUserImageUrlByEmail(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs.first;
      // Aquí, accede al campo correspondiente que contiene la URL de la imagen del usuario
      final imageUrl = userDoc.get('image');
      return imageUrl;
    }

    // Si no se encuentra ningún usuario con el correo electrónico proporcionado, retorna una URL de imagen por defecto
    return 'assets/images/pokeball.png';
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
    CollectionReference collectionReferenceFavorites =
        db.collection('favorites');
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

  Future<List<String>> getFavoritePokemonIdsByUserId(String userId) async {
    List<String> favoritePokemonIds = [];

    QuerySnapshot querySnapshot = await db
        .collection('favorites')
        .where('id_user', isEqualTo: userId)
        .get();

    favoritePokemonIds =
        querySnapshot.docs.map((doc) => doc['id_pokemon'] as String).toList();

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
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

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
        print(
            'El usuario está autenticado con correo electrónico y contraseña');
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
  Stream<QuerySnapshot> getAllFavorites(String? email) {
    return _users!
        .where('email', isEqualTo: email) // Assuming the field name is 'userId'
        .snapshots();
  }

  addUsers_git(BuildContext context) {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final Map<String, dynamic> userInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String name = userInfo['name'];
    final String image = userInfo['image'];
    final String email = userInfo['email'];
    usersCollection.add({
      'name': name,
      'image': image,
      'email': email,
    }).then((value) {
      print('Datos guardados correctamente');
    }).catchError((error) {
      print('Error al guardar los datos: $error');
    });
  }
}
