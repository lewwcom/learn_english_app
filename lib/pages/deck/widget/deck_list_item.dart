import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/widgets/word_card/word_card.dart';

class DeckListItem extends StatelessWidget {
  final Deck _deck;

  const DeckListItem(this._deck, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push("/decks/${_deck.name}", extra: _deck),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                height: constraints.maxWidth * 1.7 / 3,
                child: _deck.flashcards.isNotEmpty
                    ? WordCard(
                        _deck.flashcards.first.word.word,
                        _deck.flashcards.first.definition.meaning,
                      )
                    : const WordCard("Empty!", "Add cards to begin"),
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
              "${_deck.flashcards.length} cards",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey),
            )
          ],
        ),
      );
}
