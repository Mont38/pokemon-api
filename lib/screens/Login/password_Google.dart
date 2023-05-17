import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Password_Google extends StatefulWidget {
  const Password_Google({super.key});
  static String routeName = "/Password_Google";
  @override
  State<Password_Google> createState() => _Password_GoogleState();
}

class _Password_GoogleState extends State<Password_Google> {
  final _PassController = TextEditingController();

  void dispose() {
    _PassController.dispose();
    super.dispose();
  }

  // Future passwordReset() async {
  //   try {
  //     await FirebaseAuth.instance
  //         .sendPasswordResetEmail(email: _ForgotPassController.text.trim());
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             content: Text('Password reset  link sent'),
  //           );
  //         });
  //   } on FirebaseAuthException catch (ex) {
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             content: Text(ex.message.toString()),
  //           );
  //         });
  //   }
  // }

  void _addPassword() async {
    final String password = _PassController.text;

    if (password.isNotEmpty) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user!.uid);

        await userDoc.set({
          'password': password,
          'email': user.email,
          'name': user.displayName
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña agregada con éxito')),
        );
        Navigator.pushNamed(context, '/Home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar la contraseña')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 178, 122, 1),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          opacity: .9,
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background_login.jpg'),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please enter you password.",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              " You can enter with your password o with de Google button",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _PassController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(255, 178, 122, 1)),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 178, 122, 1),
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white),
                  fillColor: Color.fromARGB(98, 246, 241, 241),
                  filled: true,
                ),
                obscureText: true,
              ),
            ),
            MaterialButton(
              onPressed: () {
                _addPassword();
                // passwordReset();
              },
              child: Text('Save Password'),
              color: Color.fromRGBO(255, 178, 122, 1),
            )
          ],
        ),
      ),
    );
  }
}
