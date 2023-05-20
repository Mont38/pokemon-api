import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/screens/responsive/responsive.dart';
import '../../firebase/auth_user/auth_page.dart';
import '../../firebase/firebase_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static String routeName = "/register";

  @override
  State<Register> createState() => _RegisterScreenState();
}

final emailController = TextEditingController();
final passwordController = TextEditingController();
final nameController = TextEditingController();

// final emailController = TextEditingController();
// final passwordController = TextEditingController();
// void singUserIn() async {
//   await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: emailController.text, password: passwordController.text);
// }

//lo debajo son text from donde se ponen los recuadros donde van tanto el correo como la contraseña
//se le puso OutlineInputBorder para poner la linea que rodea los bordes de la caja de texto
class _RegisterScreenState extends State<Register> {
  final auth = FirebaseAuth.instance;

  void RegisterUser() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => addUsers(
              context,
              emailController.text,
              passwordController.text,
              "https://www.shutterstock.com/image-vector/email-icon-envelope-mail-services-260nw-1379676980.jpg",
              nameController.text,
              false));
      //  Navigator.popAndPushNamed(context, '/verify');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  bool isLoading = false;
//textfields-------------------------------
  final txtName = TextFormField(
    controller: nameController,
    decoration: InputDecoration(
      labelText: 'name',
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
    // controller: passwordController,
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
          Navigator.pushNamed(context, '/Login');
        },
        child: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
    );
    //buttons authentication -------------------------------

    final btnRegister = TextButton(
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
            RegisterUser();
          });
        },
        child: const Text('Register'));

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
                          btnRegister: btnRegister,
                          imgLogo: imgLogo,
                          backbutton: backbutton,
                          txtName: txtName,
                        ),
                        desktop: Desktop(
                          imgLogoDesktop: imgLogoDesktop,
                          txtEmail: txtEmail,
                          spaceHorizontal: spaceHorizontal,
                          txtPass: txtPass,
                          btnRegister: btnRegister,
                          backbutton: backbutton,
                          txtName: txtName,
                        ),
                        tablet: tablet(
                          imgLogoTablet: imgLogoTablet,
                          txtEmail: txtEmail,
                          spaceHorizontal: spaceHorizontal,
                          txtPass: txtPass,
                          btnRegister: btnRegister,
                          backbutton: backbutton,
                          txtName: txtName,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
    required this.txtName,
    required this.btnRegister,
    required this.backbutton,
  });

  final Image imgLogoDesktop;
  final TextFormField txtEmail;
  final SizedBox spaceHorizontal;
  final TextFormField txtPass;
  final TextFormField txtName;

  final TextButton btnRegister;
  final ClipRRect backbutton;

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
                    txtName,
                    spaceHorizontal,
                    spaceHorizontal,
                    txtEmail,
                    spaceHorizontal,
                    spaceHorizontal,
                    txtPass,
                    spaceHorizontal,
                    spaceHorizontal,
                    spaceHorizontal,
                    btnRegister,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            spaceHorizontal,
                            backbutton,
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
    required this.txtName,
    required this.btnRegister,
    required this.backbutton,
  });

  final Image imgLogoTablet;
  final TextFormField txtEmail;
  final TextFormField txtName;
  final SizedBox spaceHorizontal;
  final TextFormField txtPass;
  final TextButton btnRegister;
  final ClipRRect backbutton;

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
                    txtName,
                    spaceHorizontal,
                    txtEmail,
                    spaceHorizontal,
                    spaceHorizontal,
                    txtPass,
                    spaceHorizontal,
                    spaceHorizontal,
                    spaceHorizontal,
                    btnRegister,
                    SizedBox(
                      width: 900,
                      child: Column(children: [
                        spaceHorizontal,
                        backbutton,
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
    required this.btnRegister,
    required this.imgLogo,
    required this.backbutton,
    required this.txtName,
  });

  final TextFormField txtEmail;
  final SizedBox spaceHorizontal;
  final TextFormField txtPass;
  final TextButton btnRegister;
  final TextFormField txtName;
  final Image imgLogo;
  final ClipRRect backbutton;

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
          txtName,
          spaceHorizontal,
          txtEmail,
          spaceHorizontal,
          txtPass,
          spaceHorizontal,
          btnRegister,
          spaceHorizontal,
          spaceHorizontal,
          backbutton,
        ],
      ),
    );
  }
}
