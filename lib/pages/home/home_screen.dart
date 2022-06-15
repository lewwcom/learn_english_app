import 'package:flutter/material.dart';
import 'package:learn_english_app/pages/bottonavbar/my_bottom_nav_bar.dart';
import 'home_component/body.dart';
import 'package:learn_english_app/size_config.dart';
import 'package:learn_english_app/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
    );
  }
}
