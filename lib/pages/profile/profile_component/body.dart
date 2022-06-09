import 'package:flutter/material.dart';
import 'package:learn_english_app/pages/changepassword/change_password_page.dart';
import 'package:learn_english_app/services/api_logout.dart';
import '../../login/login_page.dart';
import 'Info.dart';
import 'profile_menu_item.dart';
import 'package:learn_english_app/size_config.dart';

class Body extends StatelessWidget {
  APILogout apiLogout = new APILogout();
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return ListView(
      children: <Widget>[
        Info(
          image: "assets/images/pic.png",
          name: "Phoebe Brigets",
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
          press: () {},
        ),
        ProfileMenuItem(
          iconSrc: "assets/icons/Parcel.svg",
          title: "Privacy and Security",
          press: () {},
        ),
        ProfileMenuItem(
          iconSrc: "assets/icons/Log out.svg",
          title: "Logout",
          press: () {
            apiLogout.logOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );
  }
}
