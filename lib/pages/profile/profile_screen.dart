import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_english_app/constants.dart';
import 'profile_component/body.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      /**
      bottomNavigationBar: MyBottomNavBar(),
       **/
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: IconButton (
        icon:SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: (){},
      ),
      centerTitle: true,
      title:  Text ("Profile"),
    );
  }
}