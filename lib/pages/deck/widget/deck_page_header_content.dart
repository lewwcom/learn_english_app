import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/widgets/header/header_search.dart';

class DeckPageHeaderContent extends StatelessWidget {
  final Deck _deck;
  final bool _willMoveToWordsInDeckPage;
  final bool _searchBoxAutoFocus;

  const DeckPageHeaderContent(
    this._deck, {
    Key? key,
    bool willMoveToWordsInDeckPage = false,
    bool searchBoxAutoFocus = false,
  })  : _willMoveToWordsInDeckPage = willMoveToWordsInDeckPage,
        _searchBoxAutoFocus = searchBoxAutoFocus,
        super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          HeaderSearch<Word>(
            title: _deck.name,
            buttonText: "Add word",
            onButtonPressed: () {},
            searchLocation: _willMoveToWordsInDeckPage
                ? "/decks/${_deck.name}/words"
                : null,
            searchBoxAutoFocus: _searchBoxAutoFocus,
          ),
          const SizedBox(height: kPadding / 1.3),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _BottomButton("Learn", () {}),
              const SizedBox(width: kPadding * 1.5),
              _BottomButton("Play", () {})
            ],
          )
        ],
      );
}

class _BottomButton extends StatelessWidget {
  final String _buttonText;
  final void Function()? onPressed;

  const _BottomButton(this._buttonText, this.onPressed, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: ElevatedButton(
          onPressed: onPressed ?? () {},
          child: Text(
            _buttonText,
            style: Theme.of(context)
                .primaryTextTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadius)),
            primary: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.symmetric(vertical: kPadding / 1.3),
          ),
        ),
      );
}
