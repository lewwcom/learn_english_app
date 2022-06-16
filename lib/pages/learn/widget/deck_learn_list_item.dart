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

  Question genQuestion() {
    List<String> option = [];
    option.add(_deck.flashcards[0].word.word);
    Random random = Random();
    int randNumber = random.nextInt(words.length - 1);
    option.add(words[randNumber]);
    while (option.contains(words[randNumber])) {
      random = Random();
      randNumber = random.nextInt(words.length - 1);
    }
    option.add(words[randNumber]);
    while (option.contains(words[randNumber])) {
      random = Random();
      randNumber = random.nextInt(words.length - 1);
    }
    option.add(words[randNumber]);
    random = Random();
    randNumber = random.nextInt(3);
    if (randNumber != 0) {
      String tg = option[randNumber];
      option[randNumber] = option[0];
      option[0] = tg;
    }
    Question question = Question(
        1, _deck.flashcards[0].word.definitions[0].meaning, randNumber, option);
    return question;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (_deck.flashcards.isNotEmpty) {
            Question question = genQuestion();
            Deck deck = _deck;
            deck.removeFirst();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => LearnScreen(
                        question: question,
                        initDeck: _deck,
                        currentDeck: deck,
                        countUpdate: _deck.flashcards.length)));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                height: constraints.maxWidth * 1.7 / 3,
                child: WordCard(
                  _deck.name,
                  "${_deck.flashcards.length} words need to learn now",
                ),
              ),
            ),
          ],
        ),
      );
}
