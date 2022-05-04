import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/search/widgets/search_history.dart';
import 'package:learn_english_app/widgets/word_card.dart';
import 'package:provider/provider.dart';

class WordsOfTheDay extends StatelessWidget {
  final List<Word> _words = [
    for (int i = 0; i < 5; ++i) Word.fromString("Word " + i.toString())
  ];

  WordsOfTheDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                "Words of the day",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: _WordCards(_words),
            ),
          ],
        ),
      );
}

class _WordCards extends StatelessWidget {
  final List<Word> _words;

  const _WordCards(this._words, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding,
          vertical: kPadding,
        ),
        separatorBuilder: (context, index) =>
            const SizedBox(width: kPadding / 2),
        itemCount: _words.length,
        itemBuilder: (context, index) => SizedBox(
          width: 300,
          child: GestureDetector(
            onTap: () {
              context.read<SearchHistoryNotifier>().add(_words[index].word);
              context.push("/word/" + _words[index].word);
            },
            child: WordCard(
              _words[index].word,
              _words[index].defintions.first.meaning,
            ),
          ),
        ),
      );
}
