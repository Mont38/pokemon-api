import 'package:flutter/material.dart';
import 'package:pokemon/firebase/auth_user/auth_page.dart';

import '../../Login/login.dart';
import '/constants.dart';

import '/size_config.dart';

// This is the best practice
import 'PreviewPages_content.dart';
import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "title": "PokeApp",
      "text": "Present by Ryan Serrano and Montserrat Tapia",
      "image": "assets/images/preview.png"
    },
    {
      "title": "Preview Pokemon",
      "text": "",
      "image": "assets/images/pokemones.jfif"
    },
    {
      "title": "Your Pokemons",
      "text": "",
      "image": "assets/images/favoritos.jfif"
    },
    {"title": "Perfil", "text": "", "image": "assets/images/perfil.jfif"},
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                  title: splashData[index]['title'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        Navigator.pushNamed(context, Login.routeName);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimateTime,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: Color.fromRGBO(83, 107, 147, 0.8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
