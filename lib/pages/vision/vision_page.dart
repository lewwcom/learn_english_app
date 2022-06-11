
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learn_english_app/pages/vision/vision_component/vision_body.dart';
import '../../constants.dart';
import '../bottonavbar/my_bottom_nav_bar.dart';

class VisionPage extends StatefulWidget {

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: VisionBody(
        image: "assets/images/vision_sample.png",
        content: "cat",
      ),
      bottomNavigationBar: MyBottomNavBar(),

    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
      centerTitle: true,
      title: Text("Vision"),
    );
  }
}

