import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/widgets/word_card/word_card.dart';

class FlashcardsRow extends StatelessWidget {
  final String _title;
  final List<Flashcard> _flashcards;
  final void Function(Flashcard flashcard)? _onTapFlashcard;
  final void Function()? _showMoreAction;

  const FlashcardsRow({
    Key? key,
    required String title,
    required List<Flashcard> flashcards,
    void Function(Flashcard flashcard)? onTapFlashcard,
    void Function()? showMoreAction,
  })  : _title = title,
        _flashcards = flashcards,
        _onTapFlashcard = onTapFlashcard,
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
                _flashcards,
                _showMoreAction != null ? kPadding / 10 : kPadding,
                _onTapFlashcard,
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
  final List<Flashcard> _flashcards;
  final double _bottomPadding;
  final void Function(Flashcard flashcard)? _onTapFlashcard;

  const _WordCards(this._flashcards, this._bottomPadding, this._onTapFlashcard,
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
        itemCount: _flashcards.length,
        itemBuilder: (context, index) => SizedBox(
          width: 300,
          child: GestureDetector(
            onTap: _onTapFlashcard != null
                ? () => _onTapFlashcard!(_flashcards[index])
                : null,
            child: WordCard(
              _flashcards[index].word.word,
              _flashcards[index].definition.meaning,
            ),
          ),
        ),
      );
}
