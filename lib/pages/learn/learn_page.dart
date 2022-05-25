import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/questions_model.dart';
import 'package:learn_english_app/pages/learn/widget/question_card.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen(
      {Key? key,
      required this.question,
      required this.initDeck,
      required this.currentDeck})
      : super(key: key);
  final Question question;
  final Deck initDeck;
  final Deck currentDeck;
  @override
  State<StatefulWidget> createState() => _LearnScreen();
}

class _LearnScreen extends State<LearnScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  double timer = 0;
  bool isSelectedAnswer = false;
  bool isCorrectAnswer = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {
          timer = controller.value;
        });
        if (controller.value == 1) {
          setState(() {
            isSelectedAnswer = true;
          });
        }
      });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void setSelectedAnswer() {
    setState(() {
      isSelectedAnswer = true;
      controller.stop();
    });
  }

  void setCorrectAnswer() {
    setState(() {
      isCorrectAnswer = true;
    });
  }

  Widget ProgressBar() {
    return Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF3F4768), width: 2),
            borderRadius: BorderRadius.circular(50)),
        child: Stack(
          children: [
            // LayoutBuider provide the available space for the container
            // constraints.maxWidth need for animation
            LayoutBuilder(
                builder: (context, constraints) => Container(
                      width: constraints.maxWidth * timer,
                      decoration: BoxDecoration(
                          gradient: kPrimaryGradient,
                          borderRadius: BorderRadius.circular(50)),
                    )),
            Positioned.fill(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding - 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //     "${timer.toInt()} ${(timer.toInt()) > 1 ? "seconds" : "second"}"),

                  SvgPicture.asset("assets/icons/clock.svg")
                ],
              ),
            ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          isSelectedAnswer
              ? TextButton(
                  onPressed: () {
                    Question question = Question(
                        1,
                        "Flutter is an open-source UI software development kit created by ______",
                        2,
                        ['Apple', 'Google', 'Facebook', 'Microsoft']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => LearnScreen(
                                question: question,
                                initDeck: widget.initDeck,
                                currentDeck: widget.currentDeck)));
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(color: Colors.white),
                  ))
              : Text("")
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kPrimaryColor,
                kPrimaryColor2,
              ],
              begin: Alignment.topRight,
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 3 * kPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: ProgressBar(),
            ),
            SizedBox(height: kPadding),
            Divider(thickness: 2),
            Expanded(
                child: QuestionCard(
              question: Question(
                  1,
                  "Flutter is an open-source UI software development kit created by ______",
                  2,
                  ['Apple', 'Google', 'Facebook', 'Microsoft']),
              updateSelected: setSelectedAnswer,
              isSelectedAnswer: isSelectedAnswer,
              setCorrectAnswer: setCorrectAnswer,
            ))
          ])),
    );
  }
}
