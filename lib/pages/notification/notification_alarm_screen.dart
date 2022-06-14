import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../constants.dart';
import '../../size_config.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  bool isSwitched = false;

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        _showNotification();
      });
      // ignore: avoid_print
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
      });
      // ignore: avoid_print
      print('Switch Button is OFF');
    }
  }

  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  final navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    var androidInitialize = const AndroidInitializationSettings('ic_launcher');
    var iOSIntialize = const IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSIntialize);
    localNotification.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    tz.initializeTimeZones();
  }

  Future<void> onSelectNotification(payload) async {
    context.push("/decks");
  }

  Future _showNotification() async {
    var time = const Time(0, 5, 0); //10h0ph0s
    var androidDetails = const AndroidNotificationDetails(
      "channelId",
      "local",
      importance: Importance.max,
    );
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    // ignore: deprecated_member_use
    await localNotification.showDailyAtTime(
      0,
      "Learning App",
      "It's time to study",
      time,
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kPrimaryColor,
              kPrimaryColor2,
            ],
            begin: Alignment.topRight,
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            const Text("Notification", style: kScreenTitleTextstyle),
            const SizedBox(height: 40),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 3),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    kPrimaryColor2,
                  ],
                  begin: Alignment.topRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Allow Notification", style: kTitleTextstyle),
                      Switch(value: isSwitched, onChanged: toggleSwitch)
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
