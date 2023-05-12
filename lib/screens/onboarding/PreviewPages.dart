import 'package:flutter/material.dart';
import 'package:pokemon/screens/onboarding/components/body.dart';

import '/size_config.dart';

class PreviewPages extends StatelessWidget {
  static String routeName = "/previewPages";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 8, 8, 0.8),
      body: Body(),
    );
  }
}
