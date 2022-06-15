import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/utilities/loading_notifier.dart';
import 'package:learn_english_app/widgets/word_card/word_cards_row.dart';
import 'package:provider/provider.dart';

class WordsOfTheDay extends StatelessWidget {
  const WordsOfTheDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      LoadingNotifier<List<Word>> wordsOfTheDayNotifier =
          context.watch<LoadingNotifier<List<Word>>>();
      if (wordsOfTheDayNotifier.result == null) {
        wordsOfTheDayNotifier.fetch();
      }
      return wordsOfTheDayNotifier.result != null
          ? FlashcardsRow(
              title: "Words of the day",
              flashcards: wordsOfTheDayNotifier.result!
                  .map((word) => Flashcard(word, word.definitions.first))
                  .toList(),
              onTapFlashcard: (flashcard) => context
                  .push("/words/${flashcard.word}", extra: flashcard.word),
            )
          : SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      "Words of the day",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const LinearProgressIndicator(),
                  ],
                ),
              ),
            );
    } catch (e) {
      return const SliverToBoxAdapter();
    }
  }
}
