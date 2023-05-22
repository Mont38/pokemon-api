import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>> signInWithGitHub() async {
  // Create a new provider
  GithubAuthProvider githubProvider = GithubAuthProvider();

  final UserCredential =
      await FirebaseAuth.instance.signInWithProvider(githubProvider);

  final User user = UserCredential.user!;
  bool userExists = false;

  // Verificar si el usuario ya existe en Firebase
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userSnapshot.exists) {
      userExists = true;
    }
  } catch (e) {
    print('Error al verificar el usuario en Firebase: $e');
  }

  final Map<String, dynamic> userInfo = {
    'name': user.displayName,
    'image': user.photoURL!,
    'email': user.email
  };

  if (!userExists) {
    // Agregar usuario a la colección 'users' si no existe previamente
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userInfo);

      print('Datos guardados correctamente');
    } catch (e) {
      print('Error al guardar los datos: $e');
    }
  } else {
    print('El usuario ya existe en Firebase');
  }

  return userInfo;
}
