import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';

class StudyCard extends StatelessWidget {
  final String image;
  final String title;
  final void Function() press;

  const StudyCard({
    Key? key,
    required this.image,
    required this.title,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 20,
              color: kShadowColor,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Image.asset(image),
            const SizedBox(height: 3),
            Text(title, style: kTextstyle)
          ],
        ),
      ),
    );
  }
}
