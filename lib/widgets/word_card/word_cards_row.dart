import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/widgets/word_card/word_card.dart';

class WordCardsRow extends StatelessWidget {
  final String _title;
  final List<Word> _words;
  final void Function(Word word)? _onTapWord;
  final void Function()? _showMoreAction;

  const WordCardsRow({
    Key? key,
    required String title,
    required List<Word> words,
    void Function(Word word)? onTapWord,
    void Function()? showMoreAction,
  })  : _title = title,
        _words = words,
        _onTapWord = onTapWord,
        _showMoreAction = showMoreAction,
        super(key: key);

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: GestureDetector(
                onTap: _showMoreAction,
                child: Text(
                  _title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: _WordCards(
                _words,
                _showMoreAction != null ? kPadding / 10 : kPadding,
                _onTapWord,
              ),
            ),
            if (_showMoreAction != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showMoreAction,
                    child: const Text("Show more"),
                  ),
                ),
              )
          ],
        ),
      );
}

class _WordCards extends StatelessWidget {
  final List<Word> _words;
  final double _bottomPadding;
  final void Function(Word word)? _onTapWord;

  const _WordCards(this._words, this._bottomPadding, this._onTapWord,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
          top: kPadding,
          right: kPadding,
          left: kPadding,
          bottom: _bottomPadding,
        ),
        separatorBuilder: (context, index) =>
            const SizedBox(width: kPadding / 2),
        itemCount: _words.length,
        itemBuilder: (context, index) => SizedBox(
          width: 300,
          child: GestureDetector(
            onTap: _onTapWord != null ? () => _onTapWord!(_words[index]) : null,
            child: WordCard(
              _words[index].word,
              _words[index].definitions.first.meaning,
            ),
          ),
        ),
      );
}
