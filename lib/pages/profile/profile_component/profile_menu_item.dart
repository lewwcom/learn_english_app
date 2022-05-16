import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/size_config.dart';
class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key? key,
    this.iconSrc ="",
    required this.title,
    required this.press,
  }) : super(key: key);

  final String iconSrc, title;
  final void Function() press;


  @override
  Widget build(BuildContext context) {
    double defaultSize=SizeConfig.defaultSize;
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultSize*2, vertical: defaultSize* 3),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(iconSrc),
            SizedBox(width: defaultSize*2),
            Text(
              title,
              style: TextStyle (
                fontSize: defaultSize * 1.6,//16
                color: kTextLigntColor,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: defaultSize*1.6,
              color: kTextLigntColor,
            )
          ],
        ),
      ),
    );
  }
}
