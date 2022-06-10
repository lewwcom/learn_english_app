import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/pages/game/game_page.dart';
import 'package:learn_english_app/pages/learn/finish_learn.dart';
import 'package:learn_english_app/services/api_learn.dart';
import 'package:learn_english_app/widgets/header/header_search.dart';

class HeaderContent extends StatelessWidget {
  final Deck _deck;
  final String? _searchPageLocation;
  final bool _searchBoxAutoFocus;

  const HeaderContent(
    this._deck, {
    Key? key,
    String? searchPageLocation,
    bool searchBoxAutoFocus = false,
  })  : _searchPageLocation = searchPageLocation,
        _searchBoxAutoFocus = searchBoxAutoFocus,
        super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          HeaderSearch<Flashcard>(
            title: _deck.name,
            buttonText: "Add card",
            onButtonPressed: () => context.push("/search"),
            searchPageLocation: _searchPageLocation,
            searchBoxAutoFocus: _searchBoxAutoFocus,
          ),
          const SizedBox(height: kPadding / 1.3),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _BottomButton("Learn", () async {
                int deckId = _deck.id ?? 0;
                Deck tmpDeck = await readLearn(deckId);
                if (tmpDeck.flashcards.isEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FinishLearnPage(1)));
                }
              }),
              const SizedBox(width: kPadding * 1.5),
              _BottomButton(
                  "Play",
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => GamePage(_deck))))
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold),
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
