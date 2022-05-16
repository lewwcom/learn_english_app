import 'package:flutter/material.dart';

import 'package:learn_english_app/constants.dart';

class LearningOnYoutubeCard extends StatelessWidget {
  final String image;
  final void Function() press;

  const LearningOnYoutubeCard({
    Key? key,
    required this.image,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0,10),
              blurRadius: 20,
              color: kShadowColor,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Image.asset(image),
          ],
        ),
      ),
    );
  }
}
