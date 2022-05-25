import 'package:flutter/material.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/questions_model.dart';
import 'package:learn_english_app/pages/learn/learn_page.dart';
import 'package:learn_english_app/widgets/word_card/word_card.dart';
import 'package:learn_english_app/utilities/words.dart';
import 'dart:math';

class DeckLearnListItem extends StatelessWidget {
  final Deck _deck;

  const DeckLearnListItem(this._deck, {Key? key}) : super(key: key);

  // void startLearn(BuildContext context) {
  //   List<String> option = [];
  //   Random random = new Random();
  //   int randNumber = random.nextInt(words.length - 1);
  //   Question question = Question(
  //       1,
  //       "Flutter is an open-source UI software development kit created by ______",
  //       2,
  //       ['Apple', 'Google', 'Facebook', 'Microsoft']);
  //   print("test");
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => LearnScreen(
  //               question: question, initDeck: _deck, currentDeck: _deck)));
  // }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          List<String> option = [];
          Random random = new Random();
          int randNumber = random.nextInt(words.length - 1);
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
                      initDeck: _deck,
                      currentDeck: _deck)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                height: constraints.maxWidth * 1.7 / 3,
                child: WordCard(
                  _deck.name,
                  "${_deck.words.length} words need to learn now",
                ),
              ),
            ),
          ],
        ),
      );
}
