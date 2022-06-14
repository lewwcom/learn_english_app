import 'package:flutter/material.dart';
import 'package:learn_english_app/pages/vision/vision_component/vision_body.dart';
import '../../constants.dart';
import '../bottonavbar/my_bottom_nav_bar.dart';

class VisionPage extends StatefulWidget {
  const VisionPage({Key? key}) : super(key: key);

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
      title: Text("Vision"),
    );
  }
}
