import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../constants.dart';
import '../../size_config.dart';
import '../home/home_screen.dart';

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
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  final navKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var iOSIntialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSIntialize);
    localNotification.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    tz.initializeTimeZones();
  }

  Future<void> onSelectNotification(payload) async {
    context.push("/decks");
  }

  Future _showNotification() async {
    var time=Time (0,5,0);//10h0ph0s
    var androidDetails = new AndroidNotificationDetails(
      "channelId",
      "local",
      importance: Importance.max,
    );
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification.showDailyAtTime(
      0, "Learning App", "It's time to study",
      time,
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
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
            SizedBox(height: 40),
            Text("Notification", style: kScreenTitleTextstyle),
            SizedBox(height: 40),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 3),
              decoration: BoxDecoration(
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
                      Text("Allow Notification", style: kTitleTextstyle),
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
