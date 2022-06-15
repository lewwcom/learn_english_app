import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/pages/bottonavbar/my_bottom_nav_bar.dart';
import 'profile_component/body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const Body(),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: IconButton(
        icon: Image.asset("assets/images/logo.png"),
        onPressed: () {},
      ),
      centerTitle: true,
      title: const Text("Profile"),
    );
  }
}
