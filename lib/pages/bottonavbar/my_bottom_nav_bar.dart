import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/size_config.dart';
import 'package:learn_english_app/services/api_avatar.dart';
import '../../../models/avatar.dart';

class MyBottomNavBar extends StatefulWidget {
  static String? image_url;

  const MyBottomNavBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  void initState() {
    super.initState();
    initImage();
  }

  initImage() async {
    Avatar ava = await getImage();
    MyBottomNavBar.image_url = ava.content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 3),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -7),
            blurRadius: 30,
            color: const Color(0xFF4B1A39).withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () => context.push("/"),
            icon: SvgPicture.asset('assets/icons/home.svg',
                color: const Color(0xFFD1D4D4)),
          ),
          IconButton(
            onPressed: () => context.push("/vision"),
            icon: SvgPicture.asset('assets/icons/camera.svg',
                color: const Color(0xFFD1D4D4)),
          ),
          IconButton(
            onPressed: () {
              context.push("/profile");
            },
            icon: SvgPicture.asset('assets/icons/user.svg',
                color: const Color(0xFFD1D4D4)),
          ),
        ],
      ),
    );
  }
}
