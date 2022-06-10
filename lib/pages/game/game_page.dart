import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/widgets/pop_up.dart';

import '../../models/deck.dart';

class GamePage extends StatefulWidget {
  const GamePage(
    this._deck, {
    Key? key,
  }) : super(key: key);
  final Deck _deck;
  @override
  State<StatefulWidget> createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  late List<bool> check;
  late List<String> character;
  late List<String> fillCharacter;
  late List<int> fillIndex;
  late int fillLength;
  late String ques;
  late String answer;

  initQuestion() {
    Random random = Random();
    int randNumber = random.nextInt(widget._deck.flashcards.length);
    String tmpAnswer = widget._deck.flashcards[randNumber].word.word;
    String tmpQues = widget._deck.flashcards[randNumber].definition.example ??
        widget._deck.flashcards[randNumber].definition.meaning;
    tmpQues = tmpQues.replaceAll(tmpAnswer, "...");
    tmpAnswer = tmpAnswer.toUpperCase();
    List<String> tmpCharacter = [];
    for (int i = 0; i < 10; ++i) {
      random = Random();
      randNumber = random.nextInt(26);
      tmpCharacter.add(String.fromCharCode(65 + randNumber));
    }
    List<int> cl = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    int step = 0;
    for (int i = 0; i < tmpAnswer.length; ++i) {
      while (true) {
        if (cl[step % 10] == 1) {
          ++step;
        } else {
          random = Random();
          randNumber = random.nextInt(2);
          if (randNumber == 1) {
            cl[step % 10] = 1;
            tmpCharacter[step % 10] = tmpAnswer[i];
            ++step;
            break;
          }
          ++step;
        }
      }
    }
    setState(() {
      fillCharacter = [];
      fillIndex = [];
      check = [true, true, true, true, true, true, true, true, true, true];
      answer = tmpAnswer;
      ques = tmpQues;
      fillLength = tmpAnswer.length;
      character = tmpCharacter;
    });
  }

  @override
  void initState() {
    initQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: kPrimaryColor2,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: height / 3,
                width: width - 2 * kPadding,
                margin: const EdgeInsets.symmetric(
                    horizontal: kPadding, vertical: kPadding * 2),
                padding: EdgeInsets.all(kPadding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  ques,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: kBlackColor),
                ),
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        fillLength,
                        (index) => fillCharacter.length <= index
                            ? GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.brown),
                                      borderRadius:
                                          BorderRadius.circular(kRadius / 2)),
                                  height: width / (fillLength + 2),
                                  width: width / (fillLength + 2),
                                  child: Text('',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              width / (fillLength + 2) - 5)),
                                ),
                                onTap: () {},
                              )
                            : GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                      color: Colors.brown,
                                      border: Border.all(color: Colors.brown),
                                      borderRadius:
                                          BorderRadius.circular(kRadius / 2)),
                                  height: width / (fillLength + 2),
                                  width: width / (fillLength + 2),
                                  child: Text(fillCharacter[index],
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 238, 241, 8),
                                          fontSize: 24)),
                                ),
                                onTap: () => onTapFill(index),
                              ))),
              ),
              Container(
                height: height / 3,
                margin: EdgeInsets.only(bottom: height / 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      2,
                      (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  5,
                                  (j) => check[i * 5 + j]
                                      ? GestureDetector(
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.brown,
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF818384),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        kRadius / 2)),
                                            height: 40,
                                            width: 40,
                                            child: Text(character[i * 5 + j],
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 238, 241, 8),
                                                    fontSize: 35)),
                                          ),
                                          onTap: () async {
                                            onTapBelow(i, j);
                                            if (checkAnswer()) {
                                              final action =
                                                  await PopUp.yesCancelDialog(
                                                      context,
                                                      'Congratulation',
                                                      'Do you want continue?',
                                                      'Cancel',
                                                      'Confirm');
                                              if (action == PopUpAction.yes) {
                                                initQuestion();
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            }
                                          },
                                        )
                                      : Container(
                                          alignment: Alignment.bottomCenter,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: Colors.transparent),
                                          ),
                                          height: 40,
                                          width: 40,
                                          child: const Text('',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 238, 241, 8),
                                                  fontSize: 35)),
                                        )))),
                    )),
              )
            ]));
  }

  onTapBelow(int i, int j) {
    if (fillCharacter.length == fillLength) {
      return;
    }
    List<bool> tmpCheck = check;
    tmpCheck[i * 5 + j] = false;
    List<String> tmpFill = fillCharacter;
    List<int> tmpFillIndex = fillIndex;
    tmpFill.add(character[i * 5 + j]);
    tmpFillIndex.add(i * 5 + j);
    setState(() {
      check = tmpCheck;
      fillCharacter = tmpFill;
    });
  }

  onTapFill(int index) {
    List<String> tmpFill = fillCharacter;
    List<int> tmpFillIndex = fillIndex;
    List<bool> tmpCheck = check;
    tmpCheck[fillIndex[index]] = true;
    tmpFill.removeAt(index);
    tmpFillIndex.removeAt(index);
    setState(() {
      fillCharacter = tmpFill;
      check = tmpCheck;
    });
  }

  bool checkAnswer() {
    if (fillCharacter.length < answer.length) return false;
    for (int i = 0; i < answer.length; ++i) {
      if (fillCharacter[i] != answer[i]) {
        return false;
      }
    }
    return true;
  }
}
