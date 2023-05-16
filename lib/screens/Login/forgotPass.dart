import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});
  static String routeName = "/forgotPassword";
  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _ForgotPassController = TextEditingController();

  void dispose() {
    _ForgotPassController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _ForgotPassController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset  link sent'),
            );
          });
    } on FirebaseAuthException catch (ex) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(ex.message.toString()),
            );
          });
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
              "Enter your Email Address",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _ForgotPassController,
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
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.white),
                  fillColor: Color.fromARGB(98, 246, 241, 241),
                  filled: true,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                passwordReset();
              },
              child: Text('Resset Password'),
              color: Color.fromRGBO(255, 178, 122, 1),
            )
          ],
        ),
      ),
    );
  }
}
