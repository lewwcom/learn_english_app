import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/pages/bottonavbar/my_bottom_nav_bar.dart';
import 'package:learn_english_app/pages/changepassword/change_password_page.dart';
import 'package:learn_english_app/services/api_google_sign_in.dart';
import 'package:learn_english_app/services/api_logout.dart';
import '../../login/login_page.dart';
import '../../../widgets/pop_up.dart';
import '../../notification/notification_alarm_screen.dart';
import 'info.dart';
import 'profile_menu_item.dart';
import 'package:learn_english_app/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  APILogout apiLogout = APILogout();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return ListView(
      children: <Widget>[
        Info(
          image: kApiBaseUrl +
              "static/avatars/" +
              MyBottomNavBar.image_url.toString(),
        ),
        SizedBox(
          height: SizeConfig.defaultSize * 2,
        ),
        ProfileMenuItem(
          iconSrc: "assets/icons/User Icon.svg",
          title: "Account Settings",
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
            );
          },
        ),
        ProfileMenuItem(
          iconSrc: "assets/icons/Bell.svg",
          title: "Notification",
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlarmPage()),
            );
          },
        ),
        ProfileMenuItem(
          iconSrc: "assets/icons/Log out.svg",
          title: "Logout",
          press: () async {
            final action = await PopUp.yesCancelDialog(
                context, 'Logout', 'Are you sure ?', 'Cancel', 'Confirm');
            if (action == PopUpAction.yes) {
              if (GoogleSignInApi.checkGoogleSigin) {
                await GoogleSignInApi.logout();
              }
              apiLogout.logOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
        ),
      ],
    );
  }
}
