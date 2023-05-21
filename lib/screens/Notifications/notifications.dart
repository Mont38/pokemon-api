import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});
  static String routeName = '/Notifications';

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String notificacionTitle = "waiting for notification";

  @override
  void initState() {
    super.initState();
    //termiante
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        setState(() {
          notificacionTitle =
              "${event.notification!.title} ${event.notification!.body}I am from terminate";
        });
      }
    });
    //foreground
    FirebaseMessaging.onMessage.listen((event) {
      notificacionTitle =
          "${event.notification!.title} Imcomming from foreground";
    });
    //background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        notificacionTitle =
            "${event.notification!.title} ${event.notification!.body}I am from background";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [
            Container(
              height: 400,
              color: Colors.pink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        notificacionTitle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
