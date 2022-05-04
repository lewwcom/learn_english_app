import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/widgets/word_card.dart';

class DeckListItem extends StatelessWidget {
  final Deck _deck;

  const DeckListItem(this._deck, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              height: constraints.maxWidth * 1.7 / 3,
              child: WordCard(
                _deck.words.first.word,
                _deck.words.first.defintions.first.meaning,
              ),
            ),
          ),
          const SizedBox(height: kPadding / 2),
          Text(
            _deck.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            _deck.words.length.toString() + " words",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey),
          )
        ],
      );
}
