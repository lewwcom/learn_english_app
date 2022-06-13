import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/pages/home/home_component/LearningYoutube.dart';
import 'package:learn_english_app/pages/login/login_page.dart';
import 'package:learn_english_app/pages/profile/profile_screen.dart';
import 'package:learn_english_app/pages/youtube/youtube_page.dart';
import 'studycard.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kPrimaryColor,
            kPrimaryColor2,
          ],
          begin: Alignment.topRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

      SizedBox(height: 20),
      Text("Hello, "+LoginPage.username.toString(), style: kUserstyle),
      SizedBox(height: 30),
      Text("Study with us", style: kTitleTextstyle),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    StudyCard(
                      image: "assets/images/learning.png",
                      title: "Learning",
                      press: () => context.push("/learn"),
                    ),
                    StudyCard(
                        image: "assets/images/reading.png",
                        title: "My Decks",
                        press: () => context.push("/decks")),
                    StudyCard(
                        image: "assets/images/vocab.png",
                        title: "Lookup",
                        press: () => context.push("/search")),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Learning with video",
                  style: kTitleTextstyle,
                ),
                SizedBox(height: 10),
                LearningOnYoutubeCard(
                  image: 'assets/images/video_learn.jpg',
                  press: () => context.push("/youtube"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
