import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/search/widgets/search_history.dart';
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
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding,
                  vertical: kPadding,
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(width: kPadding / 2),
                itemCount: _words.length,
                itemBuilder: (context, index) => _WordCard(
                  _words[index].word,
                  _words[index].defintions.first.meaning,
                ),
              ),
            ),
          ],
        ),
      );
}

class _WordCard extends StatelessWidget {
  final String _word;
  final String _meaning;

  const _WordCard(this._word, this._meaning, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 300,
        child: GestureDetector(
          onTap: () {
            context.read<SearchHistoryNotifier>().add(_word);
            context.push("/word/" + _word);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(2 * kPadding),
              // To pass right constraint to IntrinsicWidth
              child: Center(
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _word,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        _meaning,
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
