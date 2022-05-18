import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/pages/deck/widget/deck_page_header_content.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:learn_english_app/widgets/word_card/word_cards_row.dart';

class DeckPage extends StatelessWidget {
  final Deck _deck;

  const DeckPage(this._deck, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            Header(
              DeckPageHeaderContent(
                _deck,
                searchPageLocation: "/decks/${_deck.name}/cards",
              ),
              bottomHeight: kToolbarHeight * 4.3,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: kPadding),
              sliver: WordCardsRow(
                title: "Word list",
                words: _deck.flashcards
                    .sublist(0, min(5, _deck.flashcards.length))
                    .map((flashcard) => flashcard.word)
                    .toList(),
                onTapWord: (word) => context.push("/words/${word.word}"),
                showMoreAction: () =>
                    context.push("/decks/${_deck.name}/cards", extra: _deck),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: kPadding,
                  left: kPadding,
                  right: kPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Statistics",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: kPadding / 2),
                    LayoutBuilder(
                      builder: (context, constraints) => SizedBox(
                        height: constraints.maxWidth * 2 / 3,
                        child: Container(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
