import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/firebase/auth_user/auth_git.dart';
import 'package:pokemon/firebase/auth_user/auth_google.dart';
import 'package:pokemon/firebase/auth_user/auth_page.dart';
import 'package:pokemon/firebase/firebase_service.dart';
import 'package:pokemon/screens/Login/loading_modal.dart';
import 'package:pokemon/screens/responsive/responsive.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static String routeName = "/Login";

  @override
  State<Login> createState() => _LoginScreenState();
}

final emailController = TextEditingController();
final passwordController = TextEditingController();

//lo debajo son text from donde se ponen los recuadros donde van tanto el correo como la contraseña
//se le puso OutlineInputBorder para poner la linea que rodea los bordes de la caja de texto
class _LoginScreenState extends State<Login> {
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  Firebase_service _firebase = Firebase_service();

  void singUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pushNamed(context, AuthPage.routeName);

      print('sing');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //Wrong Email
        wrongEmail();
      } else if (e.code == 'wrong-password') {
        //Wrong Password
        wrongPassword();
      }
    }
    _firebase.checkAuthenticationStatus();
  }

  void wrongPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Password'),
        );
      },
    );
  }

  void wrongEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
      },
    );
  }

  bool isLoading = false;
//textfields-------------------------------
  final txtEmail = TextFormField(
    controller: emailController,
    decoration: InputDecoration(
      labelText: 'Email',
      labelStyle: TextStyle(color: Color.fromRGBO(244, 244, 244, 1)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromRGBO(255, 178, 122, 1),
          width: 2,
        ),
      ),
      filled: true,
      fillColor: const Color.fromRGBO(66, 71, 106, 0.5),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromRGBO(66, 71, 106, 0.5),
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    ),
  );

  final txtPass = TextFormField(
    controller: passwordController,
    decoration: InputDecoration(
      labelText: 'Password',
      labelStyle: TextStyle(color: Color.fromRGBO(244, 244, 244, 1)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color.fromRGBO(255, 178, 122, 1),
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Color.fromRGBO(66, 71, 106, 0.5),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color.fromRGBO(66, 71, 106, 0.5),
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    ),
    obscureText: true,
  );

  final spaceHorizontal = SizedBox(
    height: 10,
  );
  //Aqui debajo se importó una "libreria" de dev.net que agrega botonos para login de diferentes medias, como google, facebook, etc.

  //Logos images-------------------
  final imgLogo = Image.asset(
    'assets/images/logo.png',
    height: 200,
  );
  final imgLogoDesktop = Image.asset(
    'assets/logoDes.jpg',
    height: 300,
  );
  final imgLogoTablet = Image.asset(
    'assets/logoDes.jpg',
    height: 200,
  );

  @override
  Widget build(BuildContext context) {
    final backbutton = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 13, 13, 13)),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 77, 113, 164)),
        ),
        onPressed: () {
          // Navigator.pushNamed(context, '/Login');
          AuthGoogle().borrarUsuario();
        },
        child: const Icon(
          Icons.exit_to_app,
        ),
      ),
    );
    //buttons authentication -------------------------------
    final btnFace = SignInButton.mini(
      buttonType: ButtonType.facebook,
      onPressed: () {},
    );
    final btnGit = SignInButton.mini(
      buttonType: ButtonType.github,
      onPressed: () async {
        try {
          final Map<String, dynamic> userInfo = await signInWithGitHub();
          Navigator.pushNamed(context, '/Home', arguments: userInfo);
          signInWithGitHub();
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
        }
      },
    );
    final btnGoogle = SignInButton.mini(
      buttonType: ButtonType.google,
      onPressed: () {
        try {
          AuthGoogle().verificarYCrearUsuario(context);
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
        }

        //Navigator.pushNamed(context, '/Password_Google');
        //Navigator.pushNamed(context, AuthPage.routeName);
      },
    );
    const txt = Text(
      "Don't have an account?",
      style: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 16,
      ),
    );
    final txtRegister = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text(
            'Sign up',
            style: TextStyle(
                color: Color.fromRGBO(255, 178, 122, 1),
                fontSize: 16,
                decoration: TextDecoration.underline),
          )),
    );
    final txtForgotPass = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/forgotPassword');
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(
                color: Color.fromRGBO(255, 178, 122, 1),
                fontSize: 16,
                decoration: TextDecoration.underline),
          )),
    );
    final btnEmail = TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 13, 13, 13)),
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(255, 178, 122, 1)),
        ),
        onPressed: () {
          isLoading = true;
          setState(() {});
          Future.delayed(Duration(milliseconds: 3000)).then((value) {
            isLoading = false;
            setState(() {});
            singUserIn();

            print(emailController);
          });
        },
        child: const Text('Sign in'));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              opacity: .9,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/background_login.jpg'),
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal:
                      30), //aqui se le da un padding horizontal simetrico a las cajas de texto para que estas no abarquen toda la pantalla de forma horizontal
              child: Stack(
                children: [
                  Column(
                    children: [
                      Responsive(
                        mobile: MobileLoginScreen(
                            txtEmail: txtEmail,
                            spaceHorizontal: spaceHorizontal,
                            txtPass: txtPass,
                            btnEmail: btnEmail,
                            btnGoogle: btnGoogle,
                            btnFace: btnFace,
                            btnGit: btnGit,
                            txtRegister: txtRegister,
                            imgLogo: imgLogo,
                            backbutton: backbutton,
                            txt: txt,
                            txtForgotPass: txtForgotPass),
                        desktop: Desktop(
                            imgLogoDesktop: imgLogoDesktop,
                            txtEmail: txtEmail,
                            spaceHorizontal: spaceHorizontal,
                            txtPass: txtPass,
                            btnEmail: btnEmail,
                            btnGoogle: btnGoogle,
                            btnFace: btnFace,
                            btnGit: btnGit,
                            backbutton: backbutton,
                            txt: txt,
                            txtForgotPass: txtForgotPass),
                        tablet: tablet(
                            imgLogoTablet: imgLogoTablet,
                            txtEmail: txtEmail,
                            spaceHorizontal: spaceHorizontal,
                            txtPass: txtPass,
                            btnEmail: btnEmail,
                            btnGoogle: btnGoogle,
                            btnFace: btnFace,
                            btnGit: btnGit,
                            backbutton: backbutton,
                            txt: txt,
                            txtForgotPass: txtForgotPass),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          isLoading ? const LoadingModalWidget() : Container()
        ],
      ),
    );
  }
}

class Desktop extends StatelessWidget {
  const Desktop({
    super.key,
    required this.imgLogoDesktop,
    required this.txtEmail,
    required this.spaceHorizontal,
    required this.txtPass,
    required this.btnEmail,
    required this.btnGoogle,
    required this.btnFace,
    required this.btnGit,
    required this.backbutton,
    required this.txt,
    required this.txtForgotPass,
  });

  final Image imgLogoDesktop;
  final TextFormField txtEmail;
  final SizedBox spaceHorizontal;
  final TextFormField txtPass;
  final TextButton btnEmail;
  final SignInButton btnGoogle;
  final SignInButton btnFace;
  final SignInButton btnGit;
  final ClipRRect backbutton;
  final Text txt;
  final Padding txtForgotPass;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            verticalDirection: VerticalDirection.down,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: imgLogoDesktop,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    txtEmail,
                    spaceHorizontal,
                    spaceHorizontal,
                    txtPass,
                    spaceHorizontal,
                    spaceHorizontal,
                    spaceHorizontal,
                    btnEmail,
                    spaceHorizontal,
                    spaceHorizontal,
                    txtForgotPass,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            spaceHorizontal,
                            spaceHorizontal,
                            spaceHorizontal,
                            spaceHorizontal,
                            btnGoogle,
                            spaceHorizontal,
                            btnFace,
                            spaceHorizontal,
                            btnGit,
                            spaceHorizontal,
                            backbutton
                          ]),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class tablet extends StatelessWidget {
  const tablet({
    super.key,
    required this.imgLogoTablet,
    required this.txtEmail,
    required this.spaceHorizontal,
    required this.txtPass,
    required this.btnEmail,
    required this.btnGoogle,
    required this.btnFace,
    required this.btnGit,
    required this.backbutton,
    required this.txt,
    required this.txtForgotPass,
  });

  final Image imgLogoTablet;
  final TextFormField txtEmail;
  final SizedBox spaceHorizontal;
  final TextFormField txtPass;
  final TextButton btnEmail;
  final SignInButton btnGoogle;
  final SignInButton btnFace;
  final SignInButton btnGit;
  final ClipRRect backbutton;
  final Text txt;
  final Padding txtForgotPass;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 230),
          child: Row(
            verticalDirection: VerticalDirection.down,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: imgLogoTablet,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    txtEmail,
                    spaceHorizontal,
                    spaceHorizontal,
                    txtPass,
                    spaceHorizontal,
                    spaceHorizontal,
                    spaceHorizontal,
                    btnEmail,
                    spaceHorizontal,
                    spaceHorizontal,
                    SizedBox(
                      width: 900,
                      child: Column(children: [
                        spaceHorizontal,
                        spaceHorizontal,
                        spaceHorizontal,
                        spaceHorizontal,
                        btnGoogle,
                        spaceHorizontal,
                        btnFace,
                        spaceHorizontal,
                        btnGit,
                        spaceHorizontal,
                        backbutton
                      ]),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    super.key,
    required this.txtEmail,
    required this.spaceHorizontal,
    required this.txtPass,
    required this.btnEmail,
    required this.btnGoogle,
    required this.btnFace,
    required this.btnGit,
    required this.txtRegister,
    required this.imgLogo,
    required this.backbutton,
    required this.txt,
    required this.txtForgotPass,
  });

  final TextFormField txtEmail;
  final SizedBox spaceHorizontal;
  final TextFormField txtPass;
  final TextButton btnEmail;
  final SignInButton btnGoogle;
  final SignInButton btnFace;
  final SignInButton btnGit;
  final Padding txtRegister;
  final Image imgLogo;
  final ClipRRect backbutton;
  final Text txt;
  final Padding txtForgotPass;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15, top: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: imgLogo,
            ),
          ),
          txtEmail,
          spaceHorizontal,
          txtPass,
          spaceHorizontal,
          btnEmail,
          spaceHorizontal,
          spaceHorizontal,
          txtForgotPass,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              btnGoogle,
              spaceHorizontal,
              btnFace,
              spaceHorizontal,
              btnGit,
              spaceHorizontal,
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              txt,
              txtRegister,
            ],
          ),
          spaceHorizontal,
          backbutton,
        ],
      ),
    );
  }
}
