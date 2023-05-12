import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.title,
    this.image,
  }) : super(key: key);
  final String? text, image, title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          title!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: Color.fromRGBO(147, 158, 178, 0.8),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          style: TextStyle(
            color: Color.fromRGBO(254, 254, 254, 0.8),
          ),
          text!,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}
